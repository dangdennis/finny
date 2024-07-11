
import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';


/// Displays detailed information about a SampleItem.
class AccountDetailsView extends StatelessWidget {
  const AccountDetailsView({super.key, required this.connectionsController});

  static const routeName = Routes.accountDetails;
  final ConnectionsController connectionsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: connectionsController.openPlaidLink,
                  child: const Text("Manage Connections")),
            ),
          ],
        ),
      ),
    );
  }
}
