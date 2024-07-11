import 'package:finny/src/connections/connections_service.dart';

class ConnectionsController {
  const ConnectionsController(this.connectionsService);

  final ConnectionsService connectionsService;

  void openPlaidLink() {
    connectionsService.openPlaidLink();
  }
}
