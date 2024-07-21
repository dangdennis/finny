import 'package:powersync/powersync.dart';

const schema = Schema([
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
  ])
]);
