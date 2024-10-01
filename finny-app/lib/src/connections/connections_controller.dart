import 'package:finny/src/connections/connections_service.dart';
import 'package:finny/src/connections/plaid_item.dart';
import 'package:flutter/material.dart';

class ConnectionsController {
  ConnectionsController(this.connectionsService);

  final ConnectionsService connectionsService;
  final ValueNotifier<bool> connectionSuccessNotifier = ValueNotifier(false);

  Future<void> openPlaidLink() async {
    await connectionsService.openPlaidLink(onConnectionSuccess: () {
      connectionSuccessNotifier.value = true;
    });
  }

  Future<List<PlaidItem>> getPlaidItems() async {
    return connectionsService.getPlaidItems();
  }

  Future<void> deletePlaidItem(PlaidItem item) async {
    return connectionsService.deletePlaidItem(item);
  }
}
