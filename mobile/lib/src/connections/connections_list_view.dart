import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/plaid_item.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ConnectionsListView extends StatefulWidget {
  final ConnectionsController connectionsController;
  static const routeName = Routes.connections;

  const ConnectionsListView({super.key, required this.connectionsController});

  @override
  State<ConnectionsListView> createState() => _ConnectionsListViewState();
}

class _ConnectionsListViewState extends State<ConnectionsListView> {
  late Future<List<PlaidItem>> _futurePlaidItems;
  List<PlaidItem> _plaidItems = [];
  final Logger _logger = Logger('ConnectionsListView');

  @override
  void initState() {
    super.initState();
    _futurePlaidItems = fetchConnections();
    widget.connectionsController.connectionSuccessNotifier
        .addListener(_onConnectionSuccess);
  }

  @override
  void dispose() {
    widget.connectionsController.connectionSuccessNotifier
        .removeListener(_onConnectionSuccess);
    super.dispose();
  }

  void _onConnectionSuccess() {
    if (widget.connectionsController.connectionSuccessNotifier.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Your institution was connected successfully. Syncing data...')),
      );
      // Reset the notifier
      widget.connectionsController.connectionSuccessNotifier.value = false;
      // Refresh the connections list
      setState(() {
        _futurePlaidItems = fetchConnections();
      });
    }
  }

  Future<List<PlaidItem>> fetchConnections() async {
    try {
      final items = await widget.connectionsController.getPlaidItems();
      _plaidItems = items;
      return items;
    } catch (e) {
      _logger.warning('Failed to fetch connections', e);
      rethrow;
    }
  }

  Future<void> deleteConnection(PlaidItem item) async {
    try {
      await widget.connectionsController.deletePlaidItem(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.institutionName} deleted')),
        );
      }
    } catch (e) {
      _logger.warning('Failed to delete connection', e);
      setState(() {
        _plaidItems.add(item);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete connection')),
        );
      }
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String institutionName) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Connection'),
          content: Text(
              'Are you sure you want to delete the connection with $institutionName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Institutions')),
      body: FutureBuilder<List<PlaidItem>>(
        future: _futurePlaidItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to load connections',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futurePlaidItems = fetchConnections();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        'Start linking your institutions to begin your journey to financial freedom.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final plaidItems = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futurePlaidItems = fetchConnections();
                });
                await _futurePlaidItems;
              },
              child: ListView.builder(
                itemCount: plaidItems.length,
                itemBuilder: (context, index) {
                  final item = plaidItems[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await _showConfirmationDialog(
                              context, item.institutionName) ??
                          false;
                    },
                    onDismissed: (direction) {
                      setState(() {
                        _plaidItems.removeAt(index);
                      });
                      deleteConnection(item);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(item.institutionName),
                      subtitle: Text(
                          "${item.accounts.length} account${item.accounts.length == 1 ? '' : 's'}"),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          onPressed: () {
            widget.connectionsController.openPlaidLink();
          },
          icon: const Icon(Icons.add),
          label: const Text("Link Institution")),
    );
  }
}
