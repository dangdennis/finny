import 'package:finny/src/connections/connections_service.dart';

class ConnectionsController {
  const ConnectionsController(this.connectionsService);

  final ConnectionsService connectionsService;

  Future<void> openPlaidLink() async {
    await connectionsService.openPlaidLink();
  }
}
