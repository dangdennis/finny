import 'dart:io';

import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class AccountDetailsView extends StatefulWidget {
  const AccountDetailsView({super.key, required this.connectionsController});

  static const routeName = Routes.accountDetails;
  final ConnectionsController connectionsController;

  @override
  State<AccountDetailsView> createState() => _AccountDetailsViewState();
}

class _AccountDetailsViewState extends State<AccountDetailsView> {
  bool isLoading = false;

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
                onPressed: isLoading
                    ? null
                    : () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          await widget.connectionsController.openPlaidLink();
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(16),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey
                            .shade400; // Default color when the button is disabled
                      }
                      return Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.onPrimary ??
                          Colors.blue;
                    },
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Manage Connections"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
