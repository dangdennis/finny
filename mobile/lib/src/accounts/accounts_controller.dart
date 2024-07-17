import 'package:finny/src/accounts/account.dart';
import 'package:finny/src/accounts/accounts_service.dart';

class AccountsController {
  AccountsController(this.accountsService);

  final AccountsService accountsService;

  Future<List<Account>> loadAccounts() async {
    return await accountsService.loadAccounts();
  }
}
