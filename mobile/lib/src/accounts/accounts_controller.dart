import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/accounts/accounts_service.dart';

enum AccountType { depository, investment, credit, loan, other }

extension AccountTypeExtension on AccountType {
  String get string {
    switch (this) {
      case AccountType.depository:
        return 'depository';
      case AccountType.investment:
        return 'investment';
      case AccountType.credit:
        return 'credit';
      case AccountType.loan:
        return 'loan';
      case AccountType.other:
        return 'other';
      default:
        throw Exception('Unknown account type');
    }
  }
}

class AccountsController {
  AccountsController(this.accountsService);

  final AccountsService accountsService;

  Stream<List<Account>> watchAccounts() {
    return accountsService.watchAccounts();
  }

  Future<List<Account>> getAccounts() async {
    return await accountsService.getAccounts(GetAccountsInput());
  }

  List<Account> filterDepositoryAccounts(List<Account> accounts) {
    return accounts
        .where((account) =>
            account.type == AccountType.depository.string ||
            account.type == AccountType.other.string)
        .toList();
  }

  List<Account> filterInvestmentAccounts(List<Account> accounts) {
    return accounts
        .where((account) => account.type == AccountType.investment.string)
        .toList();
  }

  List<Account> filterCreditCardAccounts(List<Account> accounts) {
    return accounts
        .where((account) => account.type == AccountType.credit.string)
        .toList();
  }

  List<Account> filterLoanAccounts(List<Account> accounts) {
    return accounts
        .where((account) => account.type == AccountType.loan.string)
        .toList();
  }
}
