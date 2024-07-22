import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/plaid_item.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ConnectionsListView extends StatelessWidget {
  final ConnectionsController connectionsController;
  static const routeName = Routes.connections;

  const ConnectionsListView({super.key, required this.connectionsController});

  Future<List<PlaidItem>> fetchConnections() async {
    try {
      return await connectionsController.getPlaidItems();
    } catch (e) {
      Logger('ConnectionsListView').warning('Failed to fetch connections', e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connections')),
      floatingActionButton: FutureBuilder<List<PlaidItem>>(
        future: fetchConnections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              onPressed: () {
                connectionsController.openPlaidLink();
              },
              child: const Icon(Icons.add),
            );
          } else {
            return FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              onPressed: () {
                connectionsController.openPlaidLink();
              },
              child: const Icon(Icons.add),
            );
          }
        },
      ),
      body: FutureBuilder<List<PlaidItem>>(
        future: fetchConnections(),
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
                      connectionsController.openPlaidLink();
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
                  const Text(
                    'No connections yet',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      connectionsController.openPlaidLink();
                    },
                    child: const Text('Connect an institution'),
                  ),
                ],
              ),
            );
          } else {
            final plaidItems = snapshot.data!;
            return RefreshIndicator(
              onRefresh: fetchConnections,
              child: ListView.builder(
                itemCount: plaidItems.length,
                itemBuilder: (context, index) {
                  final item = plaidItems[index];
                  return ListTile(
                    title: Text(item.institutionName),
                    subtitle: Text(
                        "${item.accounts.length} account${item.accounts.length == 1 ? '' : 's'}"),
                    // onTap: () {
                    //   Navigator.of(context).pushNamed(Routes.transactions,
                    //       arguments: {'plaidItemId': item.plaidItemId});
                    // },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
