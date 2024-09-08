import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('profiles', [
    Column.text('date_of_birth'),
    Column.integer('retirement_age'),
    Column.text('risk_profile'),
    Column.text('fire_profile')
  ]),
  Table('accounts', [
    Column.text('item_id'),
    Column.text('user_id'),
    Column.text('name'),
    Column.text('mask'),
    Column.text('official_name'),
    Column.real('current_balance'),
    Column.real('available_balance'),
    Column.text('iso_currency_code'),
    Column.text('unofficial_currency_code'),
    Column.text('type'),
    Column.text('subtype'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at')
  ]),
  Table('transactions', [
    Column.text('account_id'),
    Column.text('category'),
    Column.text('subcategory'),
    Column.text('type'),
    Column.text('name'),
    Column.real('amount'),
    Column.text('iso_currency_code'),
    Column.text('unofficial_currency_code'),
    Column.text('date'),
    Column.integer('pending'),
    Column.text('account_owner'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at')
  ]),
  Table('investment_holdings', [
    Column.text('account_id'),
    Column.real('institution_price'),
    Column.text('institution_price_as_of'),
    Column.real('institution_value'),
    Column.real('cost_basis'),
    Column.real('quantity'),
    Column.text('iso_currency_code'),
    Column.real('vested_value'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at')
  ]),
  Table('goals', [
    Column.text('name'),
    Column.real('amount'),
    Column.text('target_date'),
    Column.text('user_id'),
    Column.real('progress'),
    Column.text('goal_type'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at')
  ]),
  Table('goal_accounts', [
    Column.text('goal_id'),
    Column.text('account_id'),
    Column.text('amount'),
    Column.text('percentage'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at')
  ]),
  Table('account_balances', [
    Column.text('account_id'),
    Column.text('balance_date'),
    Column.real('current_balance'),
    Column.real('available_balance')
  ]),
  Table('investment_holdings_daily', [
    Column.text('account_id'),
    Column.text('investment_security_id'),
    Column.text('holding_date'),
    Column.real('quantity'),
    Column.real('institution_price'),
    Column.real('institution_value'),
    Column.real('cost_basis'),
    Column.text('created_at')
  ])
]);
