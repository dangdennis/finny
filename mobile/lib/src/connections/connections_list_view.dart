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
  List<PlaidItem> _plaidItems = [];
  bool _isLoading = true;
  final Logger _logger = Logger('ConnectionsListView');

  @override
  void initState() {
    super.initState();
    fetchConnections();
  }

  Future<void> fetchConnections() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _logger.info('Fetching connections');
      final items = await widget.connectionsController.getPlaidItems();
      _logger.info('Items: $items');
      setState(() {
        _plaidItems = items;
        _isLoading = false;
      });
    } catch (e) {
      _logger.warning('Failed to fetch connections', e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connections')),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              onPressed: () {
                widget.connectionsController.openPlaidLink();
              },
              child: const Icon(Icons.add),
            ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _plaidItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No connections yet',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                widget.connectionsController.openPlaidLink();
                              },
                        child: const Text('Connect an institution'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _plaidItems.length,
                  itemBuilder: (context, index) {
                    final item = _plaidItems[index];
                    return ListTile(
                      title: Text(item.id),
                      subtitle: Text(item.institutionId),
                      // onTap: () {
                      //   Navigator.of(context).pushNamed(Routes.transactions,
                      //       arguments: {'plaidItemId': item.plaidItemId});
                      // },
                    );
                  },
                ),
    );
  }
}
