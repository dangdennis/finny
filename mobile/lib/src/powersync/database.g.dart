// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maskMeta = const VerificationMeta('mask');
  @override
  late final GeneratedColumn<String> mask = GeneratedColumn<String>(
      'mask', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _officialNameMeta =
      const VerificationMeta('officialName');
  @override
  late final GeneratedColumn<String> officialName = GeneratedColumn<String>(
      'official_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentBalanceMeta =
      const VerificationMeta('currentBalance');
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
      'current_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _availableBalanceMeta =
      const VerificationMeta('availableBalance');
  @override
  late final GeneratedColumn<double> availableBalance = GeneratedColumn<double>(
      'available_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isoCurrencyCodeMeta =
      const VerificationMeta('isoCurrencyCode');
  @override
  late final GeneratedColumn<String> isoCurrencyCode = GeneratedColumn<String>(
      'iso_currency_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unofficialCurrencyCodeMeta =
      const VerificationMeta('unofficialCurrencyCode');
  @override
  late final GeneratedColumn<String> unofficialCurrencyCode =
      GeneratedColumn<String>('unofficial_currency_code', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtypeMeta =
      const VerificationMeta('subtype');
  @override
  late final GeneratedColumn<String> subtype = GeneratedColumn<String>(
      'subtype', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        itemId,
        userId,
        name,
        mask,
        officialName,
        currentBalance,
        availableBalance,
        isoCurrencyCode,
        unofficialCurrencyCode,
        type,
        subtype,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<AccountsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('mask')) {
      context.handle(
          _maskMeta, mask.isAcceptableOrUnknown(data['mask']!, _maskMeta));
    }
    if (data.containsKey('official_name')) {
      context.handle(
          _officialNameMeta,
          officialName.isAcceptableOrUnknown(
              data['official_name']!, _officialNameMeta));
    }
    if (data.containsKey('current_balance')) {
      context.handle(
          _currentBalanceMeta,
          currentBalance.isAcceptableOrUnknown(
              data['current_balance']!, _currentBalanceMeta));
    }
    if (data.containsKey('available_balance')) {
      context.handle(
          _availableBalanceMeta,
          availableBalance.isAcceptableOrUnknown(
              data['available_balance']!, _availableBalanceMeta));
    }
    if (data.containsKey('iso_currency_code')) {
      context.handle(
          _isoCurrencyCodeMeta,
          isoCurrencyCode.isAcceptableOrUnknown(
              data['iso_currency_code']!, _isoCurrencyCodeMeta));
    }
    if (data.containsKey('unofficial_currency_code')) {
      context.handle(
          _unofficialCurrencyCodeMeta,
          unofficialCurrencyCode.isAcceptableOrUnknown(
              data['unofficial_currency_code']!, _unofficialCurrencyCodeMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('subtype')) {
      context.handle(_subtypeMeta,
          subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      mask: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mask']),
      officialName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_name']),
      currentBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_balance']),
      availableBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}available_balance']),
      isoCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}iso_currency_code']),
      unofficialCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unofficial_currency_code']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      subtype: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtype']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final String? itemId;
  final String? userId;
  final String? name;
  final String? mask;
  final String? officialName;
  final double? currentBalance;
  final double? availableBalance;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String? type;
  final String? subtype;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  const AccountsTableData(
      {this.itemId,
      this.userId,
      this.name,
      this.mask,
      this.officialName,
      this.currentBalance,
      this.availableBalance,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      this.type,
      this.subtype,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || mask != null) {
      map['mask'] = Variable<String>(mask);
    }
    if (!nullToAbsent || officialName != null) {
      map['official_name'] = Variable<String>(officialName);
    }
    if (!nullToAbsent || currentBalance != null) {
      map['current_balance'] = Variable<double>(currentBalance);
    }
    if (!nullToAbsent || availableBalance != null) {
      map['available_balance'] = Variable<double>(availableBalance);
    }
    if (!nullToAbsent || isoCurrencyCode != null) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode);
    }
    if (!nullToAbsent || unofficialCurrencyCode != null) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || subtype != null) {
      map['subtype'] = Variable<String>(subtype);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      mask: mask == null && nullToAbsent ? const Value.absent() : Value(mask),
      officialName: officialName == null && nullToAbsent
          ? const Value.absent()
          : Value(officialName),
      currentBalance: currentBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(currentBalance),
      availableBalance: availableBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(availableBalance),
      isoCurrencyCode: isoCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isoCurrencyCode),
      unofficialCurrencyCode: unofficialCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(unofficialCurrencyCode),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      subtype: subtype == null && nullToAbsent
          ? const Value.absent()
          : Value(subtype),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AccountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      itemId: serializer.fromJson<String?>(json['itemId']),
      userId: serializer.fromJson<String?>(json['userId']),
      name: serializer.fromJson<String?>(json['name']),
      mask: serializer.fromJson<String?>(json['mask']),
      officialName: serializer.fromJson<String?>(json['officialName']),
      currentBalance: serializer.fromJson<double?>(json['currentBalance']),
      availableBalance: serializer.fromJson<double?>(json['availableBalance']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      type: serializer.fromJson<String?>(json['type']),
      subtype: serializer.fromJson<String?>(json['subtype']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String?>(itemId),
      'userId': serializer.toJson<String?>(userId),
      'name': serializer.toJson<String?>(name),
      'mask': serializer.toJson<String?>(mask),
      'officialName': serializer.toJson<String?>(officialName),
      'currentBalance': serializer.toJson<double?>(currentBalance),
      'availableBalance': serializer.toJson<double?>(availableBalance),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'type': serializer.toJson<String?>(type),
      'subtype': serializer.toJson<String?>(subtype),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  AccountsTableData copyWith(
          {Value<String?> itemId = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> mask = const Value.absent(),
          Value<String?> officialName = const Value.absent(),
          Value<double?> currentBalance = const Value.absent(),
          Value<double?> availableBalance = const Value.absent(),
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> subtype = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> deletedAt = const Value.absent()}) =>
      AccountsTableData(
        itemId: itemId.present ? itemId.value : this.itemId,
        userId: userId.present ? userId.value : this.userId,
        name: name.present ? name.value : this.name,
        mask: mask.present ? mask.value : this.mask,
        officialName:
            officialName.present ? officialName.value : this.officialName,
        currentBalance:
            currentBalance.present ? currentBalance.value : this.currentBalance,
        availableBalance: availableBalance.present
            ? availableBalance.value
            : this.availableBalance,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        type: type.present ? type.value : this.type,
        subtype: subtype.present ? subtype.value : this.subtype,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('mask: $mask, ')
          ..write('officialName: $officialName, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('unofficialCurrencyCode: $unofficialCurrencyCode, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      itemId,
      userId,
      name,
      mask,
      officialName,
      currentBalance,
      availableBalance,
      isoCurrencyCode,
      unofficialCurrencyCode,
      type,
      subtype,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.mask == this.mask &&
          other.officialName == this.officialName &&
          other.currentBalance == this.currentBalance &&
          other.availableBalance == this.availableBalance &&
          other.isoCurrencyCode == this.isoCurrencyCode &&
          other.unofficialCurrencyCode == this.unofficialCurrencyCode &&
          other.type == this.type &&
          other.subtype == this.subtype &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<String?> itemId;
  final Value<String?> userId;
  final Value<String?> name;
  final Value<String?> mask;
  final Value<String?> officialName;
  final Value<double?> currentBalance;
  final Value<double?> availableBalance;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String?> type;
  final Value<String?> subtype;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.mask = const Value.absent(),
    this.officialName = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.availableBalance = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.mask = const Value.absent(),
    this.officialName = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.availableBalance = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<AccountsTableData> custom({
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? mask,
    Expression<String>? officialName,
    Expression<double>? currentBalance,
    Expression<double>? availableBalance,
    Expression<String>? isoCurrencyCode,
    Expression<String>? unofficialCurrencyCode,
    Expression<String>? type,
    Expression<String>? subtype,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (mask != null) 'mask': mask,
      if (officialName != null) 'official_name': officialName,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (availableBalance != null) 'available_balance': availableBalance,
      if (isoCurrencyCode != null) 'iso_currency_code': isoCurrencyCode,
      if (unofficialCurrencyCode != null)
        'unofficial_currency_code': unofficialCurrencyCode,
      if (type != null) 'type': type,
      if (subtype != null) 'subtype': subtype,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith(
      {Value<String?>? itemId,
      Value<String?>? userId,
      Value<String?>? name,
      Value<String?>? mask,
      Value<String?>? officialName,
      Value<double?>? currentBalance,
      Value<double?>? availableBalance,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String?>? type,
      Value<String?>? subtype,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return AccountsTableCompanion(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      mask: mask ?? this.mask,
      officialName: officialName ?? this.officialName,
      currentBalance: currentBalance ?? this.currentBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
      unofficialCurrencyCode:
          unofficialCurrencyCode ?? this.unofficialCurrencyCode,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mask.present) {
      map['mask'] = Variable<String>(mask.value);
    }
    if (officialName.present) {
      map['official_name'] = Variable<String>(officialName.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (availableBalance.present) {
      map['available_balance'] = Variable<double>(availableBalance.value);
    }
    if (isoCurrencyCode.present) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode.value);
    }
    if (unofficialCurrencyCode.present) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(subtype.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('mask: $mask, ')
          ..write('officialName: $officialName, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('unofficialCurrencyCode: $unofficialCurrencyCode, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isoCurrencyCodeMeta =
      const VerificationMeta('isoCurrencyCode');
  @override
  late final GeneratedColumn<String> isoCurrencyCode = GeneratedColumn<String>(
      'iso_currency_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unofficialCurrencyCodeMeta =
      const VerificationMeta('unofficialCurrencyCode');
  @override
  late final GeneratedColumn<String> unofficialCurrencyCode =
      GeneratedColumn<String>('unofficial_currency_code', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pendingMeta =
      const VerificationMeta('pending');
  @override
  late final GeneratedColumn<int> pending = GeneratedColumn<int>(
      'pending', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _accountOwnerMeta =
      const VerificationMeta('accountOwner');
  @override
  late final GeneratedColumn<String> accountOwner = GeneratedColumn<String>(
      'account_owner', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        accountId,
        category,
        subcategory,
        type,
        name,
        amount,
        isoCurrencyCode,
        unofficialCurrencyCode,
        date,
        pending,
        accountOwner,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('subcategory')) {
      context.handle(
          _subcategoryMeta,
          subcategory.isAcceptableOrUnknown(
              data['subcategory']!, _subcategoryMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('iso_currency_code')) {
      context.handle(
          _isoCurrencyCodeMeta,
          isoCurrencyCode.isAcceptableOrUnknown(
              data['iso_currency_code']!, _isoCurrencyCodeMeta));
    }
    if (data.containsKey('unofficial_currency_code')) {
      context.handle(
          _unofficialCurrencyCodeMeta,
          unofficialCurrencyCode.isAcceptableOrUnknown(
              data['unofficial_currency_code']!, _unofficialCurrencyCodeMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('pending')) {
      context.handle(_pendingMeta,
          pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta));
    }
    if (data.containsKey('account_owner')) {
      context.handle(
          _accountOwnerMeta,
          accountOwner.isAcceptableOrUnknown(
              data['account_owner']!, _accountOwnerMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      isoCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}iso_currency_code']),
      unofficialCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unofficial_currency_code']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      pending: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pending']),
      accountOwner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_owner']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String? accountId;
  final String? category;
  final String? subcategory;
  final String? type;
  final String? name;
  final double? amount;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String? date;
  final int? pending;
  final String? accountOwner;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  const TransactionsTableData(
      {this.accountId,
      this.category,
      this.subcategory,
      this.type,
      this.name,
      this.amount,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      this.date,
      this.pending,
      this.accountOwner,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || isoCurrencyCode != null) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode);
    }
    if (!nullToAbsent || unofficialCurrencyCode != null) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || pending != null) {
      map['pending'] = Variable<int>(pending);
    }
    if (!nullToAbsent || accountOwner != null) {
      map['account_owner'] = Variable<String>(accountOwner);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      isoCurrencyCode: isoCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isoCurrencyCode),
      unofficialCurrencyCode: unofficialCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(unofficialCurrencyCode),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      pending: pending == null && nullToAbsent
          ? const Value.absent()
          : Value(pending),
      accountOwner: accountOwner == null && nullToAbsent
          ? const Value.absent()
          : Value(accountOwner),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      accountId: serializer.fromJson<String?>(json['accountId']),
      category: serializer.fromJson<String?>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      type: serializer.fromJson<String?>(json['type']),
      name: serializer.fromJson<String?>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      date: serializer.fromJson<String?>(json['date']),
      pending: serializer.fromJson<int?>(json['pending']),
      accountOwner: serializer.fromJson<String?>(json['accountOwner']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String?>(accountId),
      'category': serializer.toJson<String?>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'type': serializer.toJson<String?>(type),
      'name': serializer.toJson<String?>(name),
      'amount': serializer.toJson<double?>(amount),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'date': serializer.toJson<String?>(date),
      'pending': serializer.toJson<int?>(pending),
      'accountOwner': serializer.toJson<String?>(accountOwner),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  TransactionsTableData copyWith(
          {Value<String?> accountId = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> subcategory = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<double?> amount = const Value.absent(),
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          Value<String?> date = const Value.absent(),
          Value<int?> pending = const Value.absent(),
          Value<String?> accountOwner = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> deletedAt = const Value.absent()}) =>
      TransactionsTableData(
        accountId: accountId.present ? accountId.value : this.accountId,
        category: category.present ? category.value : this.category,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        type: type.present ? type.value : this.type,
        name: name.present ? name.value : this.name,
        amount: amount.present ? amount.value : this.amount,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        date: date.present ? date.value : this.date,
        pending: pending.present ? pending.value : this.pending,
        accountOwner:
            accountOwner.present ? accountOwner.value : this.accountOwner,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('accountId: $accountId, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('unofficialCurrencyCode: $unofficialCurrencyCode, ')
          ..write('date: $date, ')
          ..write('pending: $pending, ')
          ..write('accountOwner: $accountOwner, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      accountId,
      category,
      subcategory,
      type,
      name,
      amount,
      isoCurrencyCode,
      unofficialCurrencyCode,
      date,
      pending,
      accountOwner,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.accountId == this.accountId &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.type == this.type &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.isoCurrencyCode == this.isoCurrencyCode &&
          other.unofficialCurrencyCode == this.unofficialCurrencyCode &&
          other.date == this.date &&
          other.pending == this.pending &&
          other.accountOwner == this.accountOwner &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String?> accountId;
  final Value<String?> category;
  final Value<String?> subcategory;
  final Value<String?> type;
  final Value<String?> name;
  final Value<double?> amount;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String?> date;
  final Value<int?> pending;
  final Value<String?> accountOwner;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.accountId = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.date = const Value.absent(),
    this.pending = const Value.absent(),
    this.accountOwner = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    this.accountId = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.date = const Value.absent(),
    this.pending = const Value.absent(),
    this.accountOwner = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<TransactionsTableData> custom({
    Expression<String>? accountId,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<String>? type,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? isoCurrencyCode,
    Expression<String>? unofficialCurrencyCode,
    Expression<String>? date,
    Expression<int>? pending,
    Expression<String>? accountOwner,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (isoCurrencyCode != null) 'iso_currency_code': isoCurrencyCode,
      if (unofficialCurrencyCode != null)
        'unofficial_currency_code': unofficialCurrencyCode,
      if (date != null) 'date': date,
      if (pending != null) 'pending': pending,
      if (accountOwner != null) 'account_owner': accountOwner,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith(
      {Value<String?>? accountId,
      Value<String?>? category,
      Value<String?>? subcategory,
      Value<String?>? type,
      Value<String?>? name,
      Value<double?>? amount,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String?>? date,
      Value<int?>? pending,
      Value<String?>? accountOwner,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return TransactionsTableCompanion(
      accountId: accountId ?? this.accountId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      type: type ?? this.type,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
      unofficialCurrencyCode:
          unofficialCurrencyCode ?? this.unofficialCurrencyCode,
      date: date ?? this.date,
      pending: pending ?? this.pending,
      accountOwner: accountOwner ?? this.accountOwner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isoCurrencyCode.present) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode.value);
    }
    if (unofficialCurrencyCode.present) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (pending.present) {
      map['pending'] = Variable<int>(pending.value);
    }
    if (accountOwner.present) {
      map['account_owner'] = Variable<String>(accountOwner.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('accountId: $accountId, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('unofficialCurrencyCode: $unofficialCurrencyCode, ')
          ..write('date: $date, ')
          ..write('pending: $pending, ')
          ..write('accountOwner: $accountOwner, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentHoldingsTableTable extends InvestmentHoldingsTable
    with TableInfo<$InvestmentHoldingsTableTable, InvestmentHoldingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _institutionPriceMeta =
      const VerificationMeta('institutionPrice');
  @override
  late final GeneratedColumn<double> institutionPrice = GeneratedColumn<double>(
      'institution_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _institutionPriceAsOfMeta =
      const VerificationMeta('institutionPriceAsOf');
  @override
  late final GeneratedColumn<String> institutionPriceAsOf =
      GeneratedColumn<String>('institution_price_as_of', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _institutionValueMeta =
      const VerificationMeta('institutionValue');
  @override
  late final GeneratedColumn<double> institutionValue = GeneratedColumn<double>(
      'institution_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _costBasisMeta =
      const VerificationMeta('costBasis');
  @override
  late final GeneratedColumn<double> costBasis = GeneratedColumn<double>(
      'cost_basis', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isoCurrencyCodeMeta =
      const VerificationMeta('isoCurrencyCode');
  @override
  late final GeneratedColumn<String> isoCurrencyCode = GeneratedColumn<String>(
      'iso_currency_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vestedValueMeta =
      const VerificationMeta('vestedValue');
  @override
  late final GeneratedColumn<double> vestedValue = GeneratedColumn<double>(
      'vested_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        accountId,
        institutionPrice,
        institutionPriceAsOf,
        institutionValue,
        costBasis,
        quantity,
        isoCurrencyCode,
        vestedValue,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investment_holdings';
  @override
  VerificationContext validateIntegrity(
      Insertable<InvestmentHoldingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('institution_price')) {
      context.handle(
          _institutionPriceMeta,
          institutionPrice.isAcceptableOrUnknown(
              data['institution_price']!, _institutionPriceMeta));
    }
    if (data.containsKey('institution_price_as_of')) {
      context.handle(
          _institutionPriceAsOfMeta,
          institutionPriceAsOf.isAcceptableOrUnknown(
              data['institution_price_as_of']!, _institutionPriceAsOfMeta));
    }
    if (data.containsKey('institution_value')) {
      context.handle(
          _institutionValueMeta,
          institutionValue.isAcceptableOrUnknown(
              data['institution_value']!, _institutionValueMeta));
    }
    if (data.containsKey('cost_basis')) {
      context.handle(_costBasisMeta,
          costBasis.isAcceptableOrUnknown(data['cost_basis']!, _costBasisMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('iso_currency_code')) {
      context.handle(
          _isoCurrencyCodeMeta,
          isoCurrencyCode.isAcceptableOrUnknown(
              data['iso_currency_code']!, _isoCurrencyCodeMeta));
    }
    if (data.containsKey('vested_value')) {
      context.handle(
          _vestedValueMeta,
          vestedValue.isAcceptableOrUnknown(
              data['vested_value']!, _vestedValueMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  InvestmentHoldingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentHoldingsTableData(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      institutionPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}institution_price']),
      institutionPriceAsOf: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}institution_price_as_of']),
      institutionValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}institution_value']),
      costBasis: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_basis']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      isoCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}iso_currency_code']),
      vestedValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vested_value']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $InvestmentHoldingsTableTable createAlias(String alias) {
    return $InvestmentHoldingsTableTable(attachedDatabase, alias);
  }
}

class InvestmentHoldingsTableData extends DataClass
    implements Insertable<InvestmentHoldingsTableData> {
  final String? accountId;
  final double? institutionPrice;
  final String? institutionPriceAsOf;
  final double? institutionValue;
  final double? costBasis;
  final double? quantity;
  final String? isoCurrencyCode;
  final double? vestedValue;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  const InvestmentHoldingsTableData(
      {this.accountId,
      this.institutionPrice,
      this.institutionPriceAsOf,
      this.institutionValue,
      this.costBasis,
      this.quantity,
      this.isoCurrencyCode,
      this.vestedValue,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || institutionPrice != null) {
      map['institution_price'] = Variable<double>(institutionPrice);
    }
    if (!nullToAbsent || institutionPriceAsOf != null) {
      map['institution_price_as_of'] = Variable<String>(institutionPriceAsOf);
    }
    if (!nullToAbsent || institutionValue != null) {
      map['institution_value'] = Variable<double>(institutionValue);
    }
    if (!nullToAbsent || costBasis != null) {
      map['cost_basis'] = Variable<double>(costBasis);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || isoCurrencyCode != null) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode);
    }
    if (!nullToAbsent || vestedValue != null) {
      map['vested_value'] = Variable<double>(vestedValue);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  InvestmentHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return InvestmentHoldingsTableCompanion(
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      institutionPrice: institutionPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionPrice),
      institutionPriceAsOf: institutionPriceAsOf == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionPriceAsOf),
      institutionValue: institutionValue == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionValue),
      costBasis: costBasis == null && nullToAbsent
          ? const Value.absent()
          : Value(costBasis),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      isoCurrencyCode: isoCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isoCurrencyCode),
      vestedValue: vestedValue == null && nullToAbsent
          ? const Value.absent()
          : Value(vestedValue),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory InvestmentHoldingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentHoldingsTableData(
      accountId: serializer.fromJson<String?>(json['accountId']),
      institutionPrice: serializer.fromJson<double?>(json['institutionPrice']),
      institutionPriceAsOf:
          serializer.fromJson<String?>(json['institutionPriceAsOf']),
      institutionValue: serializer.fromJson<double?>(json['institutionValue']),
      costBasis: serializer.fromJson<double?>(json['costBasis']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      vestedValue: serializer.fromJson<double?>(json['vestedValue']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String?>(accountId),
      'institutionPrice': serializer.toJson<double?>(institutionPrice),
      'institutionPriceAsOf': serializer.toJson<String?>(institutionPriceAsOf),
      'institutionValue': serializer.toJson<double?>(institutionValue),
      'costBasis': serializer.toJson<double?>(costBasis),
      'quantity': serializer.toJson<double?>(quantity),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'vestedValue': serializer.toJson<double?>(vestedValue),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  InvestmentHoldingsTableData copyWith(
          {Value<String?> accountId = const Value.absent(),
          Value<double?> institutionPrice = const Value.absent(),
          Value<String?> institutionPriceAsOf = const Value.absent(),
          Value<double?> institutionValue = const Value.absent(),
          Value<double?> costBasis = const Value.absent(),
          Value<double?> quantity = const Value.absent(),
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<double?> vestedValue = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> deletedAt = const Value.absent()}) =>
      InvestmentHoldingsTableData(
        accountId: accountId.present ? accountId.value : this.accountId,
        institutionPrice: institutionPrice.present
            ? institutionPrice.value
            : this.institutionPrice,
        institutionPriceAsOf: institutionPriceAsOf.present
            ? institutionPriceAsOf.value
            : this.institutionPriceAsOf,
        institutionValue: institutionValue.present
            ? institutionValue.value
            : this.institutionValue,
        costBasis: costBasis.present ? costBasis.value : this.costBasis,
        quantity: quantity.present ? quantity.value : this.quantity,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        vestedValue: vestedValue.present ? vestedValue.value : this.vestedValue,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('InvestmentHoldingsTableData(')
          ..write('accountId: $accountId, ')
          ..write('institutionPrice: $institutionPrice, ')
          ..write('institutionPriceAsOf: $institutionPriceAsOf, ')
          ..write('institutionValue: $institutionValue, ')
          ..write('costBasis: $costBasis, ')
          ..write('quantity: $quantity, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('vestedValue: $vestedValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      accountId,
      institutionPrice,
      institutionPriceAsOf,
      institutionValue,
      costBasis,
      quantity,
      isoCurrencyCode,
      vestedValue,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentHoldingsTableData &&
          other.accountId == this.accountId &&
          other.institutionPrice == this.institutionPrice &&
          other.institutionPriceAsOf == this.institutionPriceAsOf &&
          other.institutionValue == this.institutionValue &&
          other.costBasis == this.costBasis &&
          other.quantity == this.quantity &&
          other.isoCurrencyCode == this.isoCurrencyCode &&
          other.vestedValue == this.vestedValue &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class InvestmentHoldingsTableCompanion
    extends UpdateCompanion<InvestmentHoldingsTableData> {
  final Value<String?> accountId;
  final Value<double?> institutionPrice;
  final Value<String?> institutionPriceAsOf;
  final Value<double?> institutionValue;
  final Value<double?> costBasis;
  final Value<double?> quantity;
  final Value<String?> isoCurrencyCode;
  final Value<double?> vestedValue;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const InvestmentHoldingsTableCompanion({
    this.accountId = const Value.absent(),
    this.institutionPrice = const Value.absent(),
    this.institutionPriceAsOf = const Value.absent(),
    this.institutionValue = const Value.absent(),
    this.costBasis = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.vestedValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentHoldingsTableCompanion.insert({
    this.accountId = const Value.absent(),
    this.institutionPrice = const Value.absent(),
    this.institutionPriceAsOf = const Value.absent(),
    this.institutionValue = const Value.absent(),
    this.costBasis = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isoCurrencyCode = const Value.absent(),
    this.vestedValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<InvestmentHoldingsTableData> custom({
    Expression<String>? accountId,
    Expression<double>? institutionPrice,
    Expression<String>? institutionPriceAsOf,
    Expression<double>? institutionValue,
    Expression<double>? costBasis,
    Expression<double>? quantity,
    Expression<String>? isoCurrencyCode,
    Expression<double>? vestedValue,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (institutionPrice != null) 'institution_price': institutionPrice,
      if (institutionPriceAsOf != null)
        'institution_price_as_of': institutionPriceAsOf,
      if (institutionValue != null) 'institution_value': institutionValue,
      if (costBasis != null) 'cost_basis': costBasis,
      if (quantity != null) 'quantity': quantity,
      if (isoCurrencyCode != null) 'iso_currency_code': isoCurrencyCode,
      if (vestedValue != null) 'vested_value': vestedValue,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentHoldingsTableCompanion copyWith(
      {Value<String?>? accountId,
      Value<double?>? institutionPrice,
      Value<String?>? institutionPriceAsOf,
      Value<double?>? institutionValue,
      Value<double?>? costBasis,
      Value<double?>? quantity,
      Value<String?>? isoCurrencyCode,
      Value<double?>? vestedValue,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return InvestmentHoldingsTableCompanion(
      accountId: accountId ?? this.accountId,
      institutionPrice: institutionPrice ?? this.institutionPrice,
      institutionPriceAsOf: institutionPriceAsOf ?? this.institutionPriceAsOf,
      institutionValue: institutionValue ?? this.institutionValue,
      costBasis: costBasis ?? this.costBasis,
      quantity: quantity ?? this.quantity,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
      vestedValue: vestedValue ?? this.vestedValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (institutionPrice.present) {
      map['institution_price'] = Variable<double>(institutionPrice.value);
    }
    if (institutionPriceAsOf.present) {
      map['institution_price_as_of'] =
          Variable<String>(institutionPriceAsOf.value);
    }
    if (institutionValue.present) {
      map['institution_value'] = Variable<double>(institutionValue.value);
    }
    if (costBasis.present) {
      map['cost_basis'] = Variable<double>(costBasis.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (isoCurrencyCode.present) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode.value);
    }
    if (vestedValue.present) {
      map['vested_value'] = Variable<double>(vestedValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentHoldingsTableCompanion(')
          ..write('accountId: $accountId, ')
          ..write('institutionPrice: $institutionPrice, ')
          ..write('institutionPriceAsOf: $institutionPriceAsOf, ')
          ..write('institutionValue: $institutionValue, ')
          ..write('costBasis: $costBasis, ')
          ..write('quantity: $quantity, ')
          ..write('isoCurrencyCode: $isoCurrencyCode, ')
          ..write('vestedValue: $vestedValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
      'target_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        name,
        amount,
        targetDate,
        userId,
        progress,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<GoalsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_date']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String? name;
  final double? amount;
  final String? targetDate;
  final String? userId;
  final double? progress;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  const GoalsTableData(
      {this.name,
      this.amount,
      this.targetDate,
      this.userId,
      this.progress,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<String>(targetDate);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<double>(progress);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      name: serializer.fromJson<String?>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      targetDate: serializer.fromJson<String?>(json['targetDate']),
      userId: serializer.fromJson<String?>(json['userId']),
      progress: serializer.fromJson<double?>(json['progress']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String?>(name),
      'amount': serializer.toJson<double?>(amount),
      'targetDate': serializer.toJson<String?>(targetDate),
      'userId': serializer.toJson<String?>(userId),
      'progress': serializer.toJson<double?>(progress),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalsTableData copyWith(
          {Value<String?> name = const Value.absent(),
          Value<double?> amount = const Value.absent(),
          Value<String?> targetDate = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<double?> progress = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalsTableData(
        name: name.present ? name.value : this.name,
        amount: amount.present ? amount.value : this.amount,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        userId: userId.present ? userId.value : this.userId,
        progress: progress.present ? progress.value : this.progress,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, amount, targetDate, userId, progress,
      createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.targetDate == this.targetDate &&
          other.userId == this.userId &&
          other.progress == this.progress &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String?> name;
  final Value<double?> amount;
  final Value<String?> targetDate;
  final Value<String?> userId;
  final Value<double?> progress;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.progress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.progress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<GoalsTableData> custom({
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? targetDate,
    Expression<String>? userId,
    Expression<double>? progress,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (targetDate != null) 'target_date': targetDate,
      if (userId != null) 'user_id': userId,
      if (progress != null) 'progress': progress,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith(
      {Value<String?>? name,
      Value<double?>? amount,
      Value<String?>? targetDate,
      Value<String?>? userId,
      Value<double?>? progress,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalsTableCompanion(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      targetDate: targetDate ?? this.targetDate,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<String>(targetDate.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalAccountsTableTable extends GoalAccountsTable
    with TableInfo<$GoalAccountsTableTable, GoalAccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalAccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<String> percentage = GeneratedColumn<String>(
      'percentage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [goalId, accountId, amount, percentage, createdAt, updatedAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_accounts';
  @override
  VerificationContext validateIntegrity(
      Insertable<GoalAccountsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  GoalAccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalAccountsTableData(
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount']),
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}percentage']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalAccountsTableTable createAlias(String alias) {
    return $GoalAccountsTableTable(attachedDatabase, alias);
  }
}

class GoalAccountsTableData extends DataClass
    implements Insertable<GoalAccountsTableData> {
  final String? goalId;
  final String? accountId;
  final String? amount;
  final String? percentage;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  const GoalAccountsTableData(
      {this.goalId,
      this.accountId,
      this.amount,
      this.percentage,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<String>(amount);
    }
    if (!nullToAbsent || percentage != null) {
      map['percentage'] = Variable<String>(percentage);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalAccountsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalAccountsTableCompanion(
      goalId:
          goalId == null && nullToAbsent ? const Value.absent() : Value(goalId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      percentage: percentage == null && nullToAbsent
          ? const Value.absent()
          : Value(percentage),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalAccountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalAccountsTableData(
      goalId: serializer.fromJson<String?>(json['goalId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      amount: serializer.fromJson<String?>(json['amount']),
      percentage: serializer.fromJson<String?>(json['percentage']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<String?>(goalId),
      'accountId': serializer.toJson<String?>(accountId),
      'amount': serializer.toJson<String?>(amount),
      'percentage': serializer.toJson<String?>(percentage),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalAccountsTableData copyWith(
          {Value<String?> goalId = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          Value<String?> amount = const Value.absent(),
          Value<String?> percentage = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalAccountsTableData(
        goalId: goalId.present ? goalId.value : this.goalId,
        accountId: accountId.present ? accountId.value : this.accountId,
        amount: amount.present ? amount.value : this.amount,
        percentage: percentage.present ? percentage.value : this.percentage,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalAccountsTableData(')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('amount: $amount, ')
          ..write('percentage: $percentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      goalId, accountId, amount, percentage, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalAccountsTableData &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.amount == this.amount &&
          other.percentage == this.percentage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalAccountsTableCompanion
    extends UpdateCompanion<GoalAccountsTableData> {
  final Value<String?> goalId;
  final Value<String?> accountId;
  final Value<String?> amount;
  final Value<String?> percentage;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalAccountsTableCompanion({
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.percentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalAccountsTableCompanion.insert({
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.percentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<GoalAccountsTableData> custom({
    Expression<String>? goalId,
    Expression<String>? accountId,
    Expression<String>? amount,
    Expression<String>? percentage,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (accountId != null) 'account_id': accountId,
      if (amount != null) 'amount': amount,
      if (percentage != null) 'percentage': percentage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalAccountsTableCompanion copyWith(
      {Value<String?>? goalId,
      Value<String?>? accountId,
      Value<String?>? amount,
      Value<String?>? percentage,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalAccountsTableCompanion(
      goalId: goalId ?? this.goalId,
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<String>(percentage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalAccountsTableCompanion(')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('amount: $amount, ')
          ..write('percentage: $percentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $InvestmentHoldingsTableTable investmentHoldingsTable =
      $InvestmentHoldingsTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $GoalAccountsTableTable goalAccountsTable =
      $GoalAccountsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accountsTable,
        transactionsTable,
        investmentHoldingsTable,
        goalsTable,
        goalAccountsTable
      ];
}

typedef $$AccountsTableTableInsertCompanionBuilder = AccountsTableCompanion
    Function({
  Value<String?> itemId,
  Value<String?> userId,
  Value<String?> name,
  Value<String?> mask,
  Value<String?> officialName,
  Value<double?> currentBalance,
  Value<double?> availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$AccountsTableTableUpdateCompanionBuilder = AccountsTableCompanion
    Function({
  Value<String?> itemId,
  Value<String?> userId,
  Value<String?> name,
  Value<String?> mask,
  Value<String?> officialName,
  Value<double?> currentBalance,
  Value<double?> availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$AccountsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableProcessedTableManager,
    $$AccountsTableTableInsertCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder> {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AccountsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AccountsTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AccountsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String?> itemId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            Value<double?> currentBalance = const Value.absent(),
            Value<double?> availableBalance = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion(
            itemId: itemId,
            userId: userId,
            name: name,
            mask: mask,
            officialName: officialName,
            currentBalance: currentBalance,
            availableBalance: availableBalance,
            isoCurrencyCode: isoCurrencyCode,
            unofficialCurrencyCode: unofficialCurrencyCode,
            type: type,
            subtype: subtype,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String?> itemId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            Value<double?> currentBalance = const Value.absent(),
            Value<double?> availableBalance = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion.insert(
            itemId: itemId,
            userId: userId,
            name: name,
            mask: mask,
            officialName: officialName,
            currentBalance: currentBalance,
            availableBalance: availableBalance,
            isoCurrencyCode: isoCurrencyCode,
            unofficialCurrencyCode: unofficialCurrencyCode,
            type: type,
            subtype: subtype,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$AccountsTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableProcessedTableManager,
    $$AccountsTableTableInsertCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder> {
  $$AccountsTableTableProcessedTableManager(super.$state);
}

class $$AccountsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get mask => $state.composableBuilder(
      column: $state.table.mask,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get officialName => $state.composableBuilder(
      column: $state.table.officialName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get currentBalance => $state.composableBuilder(
      column: $state.table.currentBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get availableBalance => $state.composableBuilder(
      column: $state.table.availableBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unofficialCurrencyCode => $state.composableBuilder(
      column: $state.table.unofficialCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get subtype => $state.composableBuilder(
      column: $state.table.subtype,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AccountsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get mask => $state.composableBuilder(
      column: $state.table.mask,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get officialName => $state.composableBuilder(
      column: $state.table.officialName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get currentBalance => $state.composableBuilder(
      column: $state.table.currentBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get availableBalance => $state.composableBuilder(
      column: $state.table.availableBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unofficialCurrencyCode =>
      $state.composableBuilder(
          column: $state.table.unofficialCurrencyCode,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subtype => $state.composableBuilder(
      column: $state.table.subtype,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TransactionsTableTableInsertCompanionBuilder
    = TransactionsTableCompanion Function({
  Value<String?> accountId,
  Value<String?> category,
  Value<String?> subcategory,
  Value<String?> type,
  Value<String?> name,
  Value<double?> amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> date,
  Value<int?> pending,
  Value<String?> accountOwner,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableTableUpdateCompanionBuilder
    = TransactionsTableCompanion Function({
  Value<String?> accountId,
  Value<String?> category,
  Value<String?> subcategory,
  Value<String?> type,
  Value<String?> name,
  Value<double?> amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> date,
  Value<int?> pending,
  Value<String?> accountOwner,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$TransactionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionsTableData,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableProcessedTableManager,
    $$TransactionsTableTableInsertCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder> {
  $$TransactionsTableTableTableManager(
      _$AppDatabase db, $TransactionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$TransactionsTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TransactionsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String?> accountId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<int?> pending = const Value.absent(),
            Value<String?> accountOwner = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion(
            accountId: accountId,
            category: category,
            subcategory: subcategory,
            type: type,
            name: name,
            amount: amount,
            isoCurrencyCode: isoCurrencyCode,
            unofficialCurrencyCode: unofficialCurrencyCode,
            date: date,
            pending: pending,
            accountOwner: accountOwner,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String?> accountId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<int?> pending = const Value.absent(),
            Value<String?> accountOwner = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion.insert(
            accountId: accountId,
            category: category,
            subcategory: subcategory,
            type: type,
            name: name,
            amount: amount,
            isoCurrencyCode: isoCurrencyCode,
            unofficialCurrencyCode: unofficialCurrencyCode,
            date: date,
            pending: pending,
            accountOwner: accountOwner,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$TransactionsTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $TransactionsTableTable,
        TransactionsTableData,
        $$TransactionsTableTableFilterComposer,
        $$TransactionsTableTableOrderingComposer,
        $$TransactionsTableTableProcessedTableManager,
        $$TransactionsTableTableInsertCompanionBuilder,
        $$TransactionsTableTableUpdateCompanionBuilder> {
  $$TransactionsTableTableProcessedTableManager(super.$state);
}

class $$TransactionsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get subcategory => $state.composableBuilder(
      column: $state.table.subcategory,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unofficialCurrencyCode => $state.composableBuilder(
      column: $state.table.unofficialCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get pending => $state.composableBuilder(
      column: $state.table.pending,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountOwner => $state.composableBuilder(
      column: $state.table.accountOwner,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TransactionsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subcategory => $state.composableBuilder(
      column: $state.table.subcategory,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unofficialCurrencyCode =>
      $state.composableBuilder(
          column: $state.table.unofficialCurrencyCode,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pending => $state.composableBuilder(
      column: $state.table.pending,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountOwner => $state.composableBuilder(
      column: $state.table.accountOwner,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$InvestmentHoldingsTableTableInsertCompanionBuilder
    = InvestmentHoldingsTableCompanion Function({
  Value<String?> accountId,
  Value<double?> institutionPrice,
  Value<String?> institutionPriceAsOf,
  Value<double?> institutionValue,
  Value<double?> costBasis,
  Value<double?> quantity,
  Value<String?> isoCurrencyCode,
  Value<double?> vestedValue,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$InvestmentHoldingsTableTableUpdateCompanionBuilder
    = InvestmentHoldingsTableCompanion Function({
  Value<String?> accountId,
  Value<double?> institutionPrice,
  Value<String?> institutionPriceAsOf,
  Value<double?> institutionValue,
  Value<double?> costBasis,
  Value<double?> quantity,
  Value<String?> isoCurrencyCode,
  Value<double?> vestedValue,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$InvestmentHoldingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentHoldingsTableTable,
    InvestmentHoldingsTableData,
    $$InvestmentHoldingsTableTableFilterComposer,
    $$InvestmentHoldingsTableTableOrderingComposer,
    $$InvestmentHoldingsTableTableProcessedTableManager,
    $$InvestmentHoldingsTableTableInsertCompanionBuilder,
    $$InvestmentHoldingsTableTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsTableTableTableManager(
      _$AppDatabase db, $InvestmentHoldingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$InvestmentHoldingsTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$InvestmentHoldingsTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$InvestmentHoldingsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String?> accountId = const Value.absent(),
            Value<double?> institutionPrice = const Value.absent(),
            Value<String?> institutionPriceAsOf = const Value.absent(),
            Value<double?> institutionValue = const Value.absent(),
            Value<double?> costBasis = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<double?> vestedValue = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentHoldingsTableCompanion(
            accountId: accountId,
            institutionPrice: institutionPrice,
            institutionPriceAsOf: institutionPriceAsOf,
            institutionValue: institutionValue,
            costBasis: costBasis,
            quantity: quantity,
            isoCurrencyCode: isoCurrencyCode,
            vestedValue: vestedValue,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String?> accountId = const Value.absent(),
            Value<double?> institutionPrice = const Value.absent(),
            Value<String?> institutionPriceAsOf = const Value.absent(),
            Value<double?> institutionValue = const Value.absent(),
            Value<double?> costBasis = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<double?> vestedValue = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentHoldingsTableCompanion.insert(
            accountId: accountId,
            institutionPrice: institutionPrice,
            institutionPriceAsOf: institutionPriceAsOf,
            institutionValue: institutionValue,
            costBasis: costBasis,
            quantity: quantity,
            isoCurrencyCode: isoCurrencyCode,
            vestedValue: vestedValue,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$InvestmentHoldingsTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $InvestmentHoldingsTableTable,
        InvestmentHoldingsTableData,
        $$InvestmentHoldingsTableTableFilterComposer,
        $$InvestmentHoldingsTableTableOrderingComposer,
        $$InvestmentHoldingsTableTableProcessedTableManager,
        $$InvestmentHoldingsTableTableInsertCompanionBuilder,
        $$InvestmentHoldingsTableTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsTableTableProcessedTableManager(super.$state);
}

class $$InvestmentHoldingsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvestmentHoldingsTableTable> {
  $$InvestmentHoldingsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get institutionPrice => $state.composableBuilder(
      column: $state.table.institutionPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get institutionPriceAsOf => $state.composableBuilder(
      column: $state.table.institutionPriceAsOf,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get institutionValue => $state.composableBuilder(
      column: $state.table.institutionValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get costBasis => $state.composableBuilder(
      column: $state.table.costBasis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get vestedValue => $state.composableBuilder(
      column: $state.table.vestedValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$InvestmentHoldingsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvestmentHoldingsTableTable> {
  $$InvestmentHoldingsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get institutionPrice => $state.composableBuilder(
      column: $state.table.institutionPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get institutionPriceAsOf => $state.composableBuilder(
      column: $state.table.institutionPriceAsOf,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get institutionValue => $state.composableBuilder(
      column: $state.table.institutionValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get costBasis => $state.composableBuilder(
      column: $state.table.costBasis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get isoCurrencyCode => $state.composableBuilder(
      column: $state.table.isoCurrencyCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get vestedValue => $state.composableBuilder(
      column: $state.table.vestedValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GoalsTableTableInsertCompanionBuilder = GoalsTableCompanion Function({
  Value<String?> name,
  Value<double?> amount,
  Value<String?> targetDate,
  Value<String?> userId,
  Value<double?> progress,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalsTableTableUpdateCompanionBuilder = GoalsTableCompanion Function({
  Value<String?> name,
  Value<double?> amount,
  Value<String?> targetDate,
  Value<String?> userId,
  Value<double?> progress,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableProcessedTableManager,
    $$GoalsTableTableInsertCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder> {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalsTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GoalsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String?> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> targetDate = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<double?> progress = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion(
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String?> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> targetDate = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<double?> progress = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion.insert(
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$GoalsTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableProcessedTableManager,
    $$GoalsTableTableInsertCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder> {
  $$GoalsTableTableProcessedTableManager(super.$state);
}

class $$GoalsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get targetDate => $state.composableBuilder(
      column: $state.table.targetDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get progress => $state.composableBuilder(
      column: $state.table.progress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GoalsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get targetDate => $state.composableBuilder(
      column: $state.table.targetDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get progress => $state.composableBuilder(
      column: $state.table.progress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GoalAccountsTableTableInsertCompanionBuilder
    = GoalAccountsTableCompanion Function({
  Value<String?> goalId,
  Value<String?> accountId,
  Value<String?> amount,
  Value<String?> percentage,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalAccountsTableTableUpdateCompanionBuilder
    = GoalAccountsTableCompanion Function({
  Value<String?> goalId,
  Value<String?> accountId,
  Value<String?> amount,
  Value<String?> percentage,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalAccountsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalAccountsTableTable,
    GoalAccountsTableData,
    $$GoalAccountsTableTableFilterComposer,
    $$GoalAccountsTableTableOrderingComposer,
    $$GoalAccountsTableTableProcessedTableManager,
    $$GoalAccountsTableTableInsertCompanionBuilder,
    $$GoalAccountsTableTableUpdateCompanionBuilder> {
  $$GoalAccountsTableTableTableManager(
      _$AppDatabase db, $GoalAccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalAccountsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$GoalAccountsTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GoalAccountsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String?> goalId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> amount = const Value.absent(),
            Value<String?> percentage = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsTableCompanion(
            goalId: goalId,
            accountId: accountId,
            amount: amount,
            percentage: percentage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<String?> goalId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> amount = const Value.absent(),
            Value<String?> percentage = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsTableCompanion.insert(
            goalId: goalId,
            accountId: accountId,
            amount: amount,
            percentage: percentage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$GoalAccountsTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $GoalAccountsTableTable,
        GoalAccountsTableData,
        $$GoalAccountsTableTableFilterComposer,
        $$GoalAccountsTableTableOrderingComposer,
        $$GoalAccountsTableTableProcessedTableManager,
        $$GoalAccountsTableTableInsertCompanionBuilder,
        $$GoalAccountsTableTableUpdateCompanionBuilder> {
  $$GoalAccountsTableTableProcessedTableManager(super.$state);
}

class $$GoalAccountsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GoalAccountsTableTable> {
  $$GoalAccountsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get goalId => $state.composableBuilder(
      column: $state.table.goalId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get percentage => $state.composableBuilder(
      column: $state.table.percentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GoalAccountsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GoalAccountsTableTable> {
  $$GoalAccountsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get goalId => $state.composableBuilder(
      column: $state.table.goalId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountId => $state.composableBuilder(
      column: $state.table.accountId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get percentage => $state.composableBuilder(
      column: $state.table.percentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deletedAt => $state.composableBuilder(
      column: $state.table.deletedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$InvestmentHoldingsTableTableTableManager get investmentHoldingsTable =>
      $$InvestmentHoldingsTableTableTableManager(
          _db, _db.investmentHoldingsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$GoalAccountsTableTableTableManager get goalAccountsTable =>
      $$GoalAccountsTableTableTableManager(_db, _db.goalAccountsTable);
}
