import 'package:finny/src/connections/connections_service.dart';
import 'package:finny/src/connections/plaid_item.dart';

class ConnectionsController {
  const ConnectionsController(this.connectionsService);

  final ConnectionsService connectionsService;

  Future<void> openPlaidLink() async {
    await connectionsService.openPlaidLink();
  }

  Future<List<PlaidItem>> getPlaidItems() async {
    return connectionsService.getPlaidItems();
  }
}
