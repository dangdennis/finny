// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsDbTable extends AccountsDb
    with TableInfo<$AccountsDbTable, AccountsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
      'current_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _availableBalanceMeta =
      const VerificationMeta('availableBalance');
  @override
  late final GeneratedColumn<double> availableBalance = GeneratedColumn<double>(
      'available_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
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
  VerificationContext validateIntegrity(Insertable<AccountsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    } else if (isInserting) {
      context.missing(_currentBalanceMeta);
    }
    if (data.containsKey('available_balance')) {
      context.handle(
          _availableBalanceMeta,
          availableBalance.isAcceptableOrUnknown(
              data['available_balance']!, _availableBalanceMeta));
    } else if (isInserting) {
      context.missing(_availableBalanceMeta);
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  AccountsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mask: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mask']),
      officialName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_name']),
      currentBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_balance'])!,
      availableBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}available_balance'])!,
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
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $AccountsDbTable createAlias(String alias) {
    return $AccountsDbTable(attachedDatabase, alias);
  }
}

class AccountsDbData extends DataClass implements Insertable<AccountsDbData> {
  final String id;
  final String itemId;
  final String userId;
  final String name;
  final String? mask;
  final String? officialName;
  final double currentBalance;
  final double availableBalance;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String? type;
  final String? subtype;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const AccountsDbData(
      {required this.id,
      required this.itemId,
      required this.userId,
      required this.name,
      this.mask,
      this.officialName,
      required this.currentBalance,
      required this.availableBalance,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      this.type,
      this.subtype,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mask != null) {
      map['mask'] = Variable<String>(mask);
    }
    if (!nullToAbsent || officialName != null) {
      map['official_name'] = Variable<String>(officialName);
    }
    map['current_balance'] = Variable<double>(currentBalance);
    map['available_balance'] = Variable<double>(availableBalance);
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
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  AccountsDbCompanion toCompanion(bool nullToAbsent) {
    return AccountsDbCompanion(
      id: Value(id),
      itemId: Value(itemId),
      userId: Value(userId),
      name: Value(name),
      mask: mask == null && nullToAbsent ? const Value.absent() : Value(mask),
      officialName: officialName == null && nullToAbsent
          ? const Value.absent()
          : Value(officialName),
      currentBalance: Value(currentBalance),
      availableBalance: Value(availableBalance),
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
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AccountsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsDbData(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      mask: serializer.fromJson<String?>(json['mask']),
      officialName: serializer.fromJson<String?>(json['officialName']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      availableBalance: serializer.fromJson<double>(json['availableBalance']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      type: serializer.fromJson<String?>(json['type']),
      subtype: serializer.fromJson<String?>(json['subtype']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'mask': serializer.toJson<String?>(mask),
      'officialName': serializer.toJson<String?>(officialName),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'availableBalance': serializer.toJson<double>(availableBalance),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'type': serializer.toJson<String?>(type),
      'subtype': serializer.toJson<String?>(subtype),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  AccountsDbData copyWith(
          {String? id,
          String? itemId,
          String? userId,
          String? name,
          Value<String?> mask = const Value.absent(),
          Value<String?> officialName = const Value.absent(),
          double? currentBalance,
          double? availableBalance,
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> subtype = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      AccountsDbData(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        mask: mask.present ? mask.value : this.mask,
        officialName:
            officialName.present ? officialName.value : this.officialName,
        currentBalance: currentBalance ?? this.currentBalance,
        availableBalance: availableBalance ?? this.availableBalance,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        type: type.present ? type.value : this.type,
        subtype: subtype.present ? subtype.value : this.subtype,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('AccountsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is AccountsDbData &&
          other.id == this.id &&
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

class AccountsDbCompanion extends UpdateCompanion<AccountsDbData> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> mask;
  final Value<String?> officialName;
  final Value<double> currentBalance;
  final Value<double> availableBalance;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String?> type;
  final Value<String?> subtype;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const AccountsDbCompanion({
    this.id = const Value.absent(),
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
  AccountsDbCompanion.insert({
    required String id,
    required String itemId,
    required String userId,
    required String name,
    this.mask = const Value.absent(),
    this.officialName = const Value.absent(),
    required double currentBalance,
    required double availableBalance,
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        userId = Value(userId),
        name = Value(name),
        currentBalance = Value(currentBalance),
        availableBalance = Value(availableBalance),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AccountsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  AccountsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? mask,
      Value<String?>? officialName,
      Value<double>? currentBalance,
      Value<double>? availableBalance,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String?>? type,
      Value<String?>? subtype,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return AccountsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('AccountsDbCompanion(')
          ..write('id: $id, ')
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

class $TransactionsDbTable extends TransactionsDb
    with TableInfo<$TransactionsDbTable, TransactionsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pendingMeta =
      const VerificationMeta('pending');
  @override
  late final GeneratedColumn<int> pending = GeneratedColumn<int>(
      'pending', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
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
  VerificationContext validateIntegrity(Insertable<TransactionsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
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
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
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
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pending')) {
      context.handle(_pendingMeta,
          pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta));
    } else if (isInserting) {
      context.missing(_pendingMeta);
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  TransactionsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isoCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}iso_currency_code']),
      unofficialCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unofficial_currency_code']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      pending: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pending'])!,
      accountOwner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_owner']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $TransactionsDbTable createAlias(String alias) {
    return $TransactionsDbTable(attachedDatabase, alias);
  }
}

class TransactionsDbData extends DataClass
    implements Insertable<TransactionsDbData> {
  final String id;
  final String accountId;
  final String category;
  final String? subcategory;
  final String type;
  final String name;
  final double amount;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String date;
  final int pending;
  final String? accountOwner;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const TransactionsDbData(
      {required this.id,
      required this.accountId,
      required this.category,
      this.subcategory,
      required this.type,
      required this.name,
      required this.amount,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      required this.date,
      required this.pending,
      this.accountOwner,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || isoCurrencyCode != null) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode);
    }
    if (!nullToAbsent || unofficialCurrencyCode != null) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode);
    }
    map['date'] = Variable<String>(date);
    map['pending'] = Variable<int>(pending);
    if (!nullToAbsent || accountOwner != null) {
      map['account_owner'] = Variable<String>(accountOwner);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  TransactionsDbCompanion toCompanion(bool nullToAbsent) {
    return TransactionsDbCompanion(
      id: Value(id),
      accountId: Value(accountId),
      category: Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      type: Value(type),
      name: Value(name),
      amount: Value(amount),
      isoCurrencyCode: isoCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isoCurrencyCode),
      unofficialCurrencyCode: unofficialCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(unofficialCurrencyCode),
      date: Value(date),
      pending: Value(pending),
      accountOwner: accountOwner == null && nullToAbsent
          ? const Value.absent()
          : Value(accountOwner),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsDbData(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      date: serializer.fromJson<String>(json['date']),
      pending: serializer.fromJson<int>(json['pending']),
      accountOwner: serializer.fromJson<String?>(json['accountOwner']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'date': serializer.toJson<String>(date),
      'pending': serializer.toJson<int>(pending),
      'accountOwner': serializer.toJson<String?>(accountOwner),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  TransactionsDbData copyWith(
          {String? id,
          String? accountId,
          String? category,
          Value<String?> subcategory = const Value.absent(),
          String? type,
          String? name,
          double? amount,
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          String? date,
          int? pending,
          Value<String?> accountOwner = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      TransactionsDbData(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        category: category ?? this.category,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        type: type ?? this.type,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        date: date ?? this.date,
        pending: pending ?? this.pending,
        accountOwner:
            accountOwner.present ? accountOwner.value : this.accountOwner,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is TransactionsDbData &&
          other.id == this.id &&
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

class TransactionsDbCompanion extends UpdateCompanion<TransactionsDbData> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> category;
  final Value<String?> subcategory;
  final Value<String> type;
  final Value<String> name;
  final Value<double> amount;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String> date;
  final Value<int> pending;
  final Value<String?> accountOwner;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const TransactionsDbCompanion({
    this.id = const Value.absent(),
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
  TransactionsDbCompanion.insert({
    required String id,
    required String accountId,
    required String category,
    this.subcategory = const Value.absent(),
    required String type,
    required String name,
    required double amount,
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    required String date,
    required int pending,
    this.accountOwner = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        category = Value(category),
        type = Value(type),
        name = Value(name),
        amount = Value(amount),
        date = Value(date),
        pending = Value(pending),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TransactionsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  TransactionsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String>? category,
      Value<String?>? subcategory,
      Value<String>? type,
      Value<String>? name,
      Value<double>? amount,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String>? date,
      Value<int>? pending,
      Value<String?>? accountOwner,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return TransactionsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('TransactionsDbCompanion(')
          ..write('id: $id, ')
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

class $InvestmentHoldingsDbTable extends InvestmentHoldingsDb
    with TableInfo<$InvestmentHoldingsDbTable, InvestmentHoldingsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentHoldingsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
        id,
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
      Insertable<InvestmentHoldingsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
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
  InvestmentHoldingsDbData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentHoldingsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
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
  $InvestmentHoldingsDbTable createAlias(String alias) {
    return $InvestmentHoldingsDbTable(attachedDatabase, alias);
  }
}

class InvestmentHoldingsDbData extends DataClass
    implements Insertable<InvestmentHoldingsDbData> {
  final String id;
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
  const InvestmentHoldingsDbData(
      {required this.id,
      this.accountId,
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
    map['id'] = Variable<String>(id);
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

  InvestmentHoldingsDbCompanion toCompanion(bool nullToAbsent) {
    return InvestmentHoldingsDbCompanion(
      id: Value(id),
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

  factory InvestmentHoldingsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentHoldingsDbData(
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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

  InvestmentHoldingsDbData copyWith(
          {String? id,
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
          Value<String?> deletedAt = const Value.absent()}) =>
      InvestmentHoldingsDbData(
        id: id ?? this.id,
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
    return (StringBuffer('InvestmentHoldingsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is InvestmentHoldingsDbData &&
          other.id == this.id &&
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

class InvestmentHoldingsDbCompanion
    extends UpdateCompanion<InvestmentHoldingsDbData> {
  final Value<String> id;
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
  const InvestmentHoldingsDbCompanion({
    this.id = const Value.absent(),
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
  InvestmentHoldingsDbCompanion.insert({
    required String id,
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
  }) : id = Value(id);
  static Insertable<InvestmentHoldingsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  InvestmentHoldingsDbCompanion copyWith(
      {Value<String>? id,
      Value<String?>? accountId,
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
    return InvestmentHoldingsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('InvestmentHoldingsDbCompanion(')
          ..write('id: $id, ')
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

class $GoalsDbTable extends GoalsDb with TableInfo<$GoalsDbTable, GoalsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
      'target_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _goalTypeMeta =
      const VerificationMeta('goalType');
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
      'goal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amount,
        targetDate,
        userId,
        progress,
        goalType,
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
  VerificationContext validateIntegrity(Insertable<GoalsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('goal_type')) {
      context.handle(_goalTypeMeta,
          goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta));
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  GoalsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_date'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress']),
      goalType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalsDbTable createAlias(String alias) {
    return $GoalsDbTable(attachedDatabase, alias);
  }
}

class GoalsDbData extends DataClass implements Insertable<GoalsDbData> {
  final String id;
  final String name;
  final double amount;
  final String targetDate;
  final String userId;
  final double? progress;
  final String goalType;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const GoalsDbData(
      {required this.id,
      required this.name,
      required this.amount,
      required this.targetDate,
      required this.userId,
      this.progress,
      required this.goalType,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['target_date'] = Variable<String>(targetDate);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<double>(progress);
    }
    map['goal_type'] = Variable<String>(goalType);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalsDbCompanion toCompanion(bool nullToAbsent) {
    return GoalsDbCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      targetDate: Value(targetDate),
      userId: Value(userId),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      goalType: Value(goalType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsDbData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      targetDate: serializer.fromJson<String>(json['targetDate']),
      userId: serializer.fromJson<String>(json['userId']),
      progress: serializer.fromJson<double?>(json['progress']),
      goalType: serializer.fromJson<String>(json['goalType']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'targetDate': serializer.toJson<String>(targetDate),
      'userId': serializer.toJson<String>(userId),
      'progress': serializer.toJson<double?>(progress),
      'goalType': serializer.toJson<String>(goalType),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalsDbData copyWith(
          {String? id,
          String? name,
          double? amount,
          String? targetDate,
          String? userId,
          Value<double?> progress = const Value.absent(),
          String? goalType,
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalsDbData(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        targetDate: targetDate ?? this.targetDate,
        userId: userId ?? this.userId,
        progress: progress.present ? progress.value : this.progress,
        goalType: goalType ?? this.goalType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalsDbData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, targetDate, userId,
      progress, goalType, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsDbData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.targetDate == this.targetDate &&
          other.userId == this.userId &&
          other.progress == this.progress &&
          other.goalType == this.goalType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalsDbCompanion extends UpdateCompanion<GoalsDbData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> targetDate;
  final Value<String> userId;
  final Value<double?> progress;
  final Value<String> goalType;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalsDbCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.progress = const Value.absent(),
    this.goalType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsDbCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required String targetDate,
    required String userId,
    this.progress = const Value.absent(),
    required String goalType,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        targetDate = Value(targetDate),
        userId = Value(userId),
        goalType = Value(goalType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GoalsDbData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? targetDate,
    Expression<String>? userId,
    Expression<double>? progress,
    Expression<String>? goalType,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (targetDate != null) 'target_date': targetDate,
      if (userId != null) 'user_id': userId,
      if (progress != null) 'progress': progress,
      if (goalType != null) 'goal_type': goalType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? targetDate,
      Value<String>? userId,
      Value<double?>? progress,
      Value<String>? goalType,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalsDbCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      targetDate: targetDate ?? this.targetDate,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
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
    return (StringBuffer('GoalsDbCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalAccountsDbTable extends GoalAccountsDb
    with TableInfo<$GoalAccountsDbTable, GoalAccountsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalAccountsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<String> percentage = GeneratedColumn<String>(
      'percentage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalId,
        accountId,
        amount,
        percentage,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<GoalAccountsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  GoalAccountsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalAccountsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}percentage'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalAccountsDbTable createAlias(String alias) {
    return $GoalAccountsDbTable(attachedDatabase, alias);
  }
}

class GoalAccountsDbData extends DataClass
    implements Insertable<GoalAccountsDbData> {
  final String id;
  final String goalId;
  final String accountId;
  final String amount;
  final String percentage;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const GoalAccountsDbData(
      {required this.id,
      required this.goalId,
      required this.accountId,
      required this.amount,
      required this.percentage,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['account_id'] = Variable<String>(accountId);
    map['amount'] = Variable<String>(amount);
    map['percentage'] = Variable<String>(percentage);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalAccountsDbCompanion toCompanion(bool nullToAbsent) {
    return GoalAccountsDbCompanion(
      id: Value(id),
      goalId: Value(goalId),
      accountId: Value(accountId),
      amount: Value(amount),
      percentage: Value(percentage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalAccountsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalAccountsDbData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      amount: serializer.fromJson<String>(json['amount']),
      percentage: serializer.fromJson<String>(json['percentage']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'accountId': serializer.toJson<String>(accountId),
      'amount': serializer.toJson<String>(amount),
      'percentage': serializer.toJson<String>(percentage),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalAccountsDbData copyWith(
          {String? id,
          String? goalId,
          String? accountId,
          String? amount,
          String? percentage,
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalAccountsDbData(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        accountId: accountId ?? this.accountId,
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalAccountsDbData(')
          ..write('id: $id, ')
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
  int get hashCode => Object.hash(id, goalId, accountId, amount, percentage,
      createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalAccountsDbData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.amount == this.amount &&
          other.percentage == this.percentage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalAccountsDbCompanion extends UpdateCompanion<GoalAccountsDbData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> accountId;
  final Value<String> amount;
  final Value<String> percentage;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalAccountsDbCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.percentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalAccountsDbCompanion.insert({
    required String id,
    required String goalId,
    required String accountId,
    required String amount,
    required String percentage,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        accountId = Value(accountId),
        amount = Value(amount),
        percentage = Value(percentage),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GoalAccountsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  GoalAccountsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<String>? accountId,
      Value<String>? amount,
      Value<String>? percentage,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalAccountsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('GoalAccountsDbCompanion(')
          ..write('id: $id, ')
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

class $ProfilesDbTable extends ProfilesDb
    with TableInfo<$ProfilesDbTable, ProfilesDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _retirementAgeMeta =
      const VerificationMeta('retirementAge');
  @override
  late final GeneratedColumn<int> retirementAge = GeneratedColumn<int>(
      'retirement_age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _riskProfileMeta =
      const VerificationMeta('riskProfile');
  @override
  late final GeneratedColumn<String> riskProfile = GeneratedColumn<String>(
      'risk_profile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fireProfileMeta =
      const VerificationMeta('fireProfile');
  @override
  late final GeneratedColumn<String> fireProfile = GeneratedColumn<String>(
      'fire_profile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dateOfBirth, retirementAge, riskProfile, fireProfile];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<ProfilesDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('retirement_age')) {
      context.handle(
          _retirementAgeMeta,
          retirementAge.isAcceptableOrUnknown(
              data['retirement_age']!, _retirementAgeMeta));
    }
    if (data.containsKey('risk_profile')) {
      context.handle(
          _riskProfileMeta,
          riskProfile.isAcceptableOrUnknown(
              data['risk_profile']!, _riskProfileMeta));
    }
    if (data.containsKey('fire_profile')) {
      context.handle(
          _fireProfileMeta,
          fireProfile.isAcceptableOrUnknown(
              data['fire_profile']!, _fireProfileMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ProfilesDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilesDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_of_birth']),
      retirementAge: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retirement_age']),
      riskProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_profile']),
      fireProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fire_profile']),
    );
  }

  @override
  $ProfilesDbTable createAlias(String alias) {
    return $ProfilesDbTable(attachedDatabase, alias);
  }
}

class ProfilesDbData extends DataClass implements Insertable<ProfilesDbData> {
  final String id;
  final String? dateOfBirth;
  final int? retirementAge;
  final String? riskProfile;
  final String? fireProfile;
  const ProfilesDbData(
      {required this.id,
      this.dateOfBirth,
      this.retirementAge,
      this.riskProfile,
      this.fireProfile});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || retirementAge != null) {
      map['retirement_age'] = Variable<int>(retirementAge);
    }
    if (!nullToAbsent || riskProfile != null) {
      map['risk_profile'] = Variable<String>(riskProfile);
    }
    if (!nullToAbsent || fireProfile != null) {
      map['fire_profile'] = Variable<String>(fireProfile);
    }
    return map;
  }

  ProfilesDbCompanion toCompanion(bool nullToAbsent) {
    return ProfilesDbCompanion(
      id: Value(id),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      retirementAge: retirementAge == null && nullToAbsent
          ? const Value.absent()
          : Value(retirementAge),
      riskProfile: riskProfile == null && nullToAbsent
          ? const Value.absent()
          : Value(riskProfile),
      fireProfile: fireProfile == null && nullToAbsent
          ? const Value.absent()
          : Value(fireProfile),
    );
  }

  factory ProfilesDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilesDbData(
      id: serializer.fromJson<String>(json['id']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      retirementAge: serializer.fromJson<int?>(json['retirementAge']),
      riskProfile: serializer.fromJson<String?>(json['riskProfile']),
      fireProfile: serializer.fromJson<String?>(json['fireProfile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'retirementAge': serializer.toJson<int?>(retirementAge),
      'riskProfile': serializer.toJson<String?>(riskProfile),
      'fireProfile': serializer.toJson<String?>(fireProfile),
    };
  }

  ProfilesDbData copyWith(
          {String? id,
          Value<String?> dateOfBirth = const Value.absent(),
          Value<int?> retirementAge = const Value.absent(),
          Value<String?> riskProfile = const Value.absent(),
          Value<String?> fireProfile = const Value.absent()}) =>
      ProfilesDbData(
        id: id ?? this.id,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        retirementAge:
            retirementAge.present ? retirementAge.value : this.retirementAge,
        riskProfile: riskProfile.present ? riskProfile.value : this.riskProfile,
        fireProfile: fireProfile.present ? fireProfile.value : this.fireProfile,
      );
  @override
  String toString() {
    return (StringBuffer('ProfilesDbData(')
          ..write('id: $id, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('retirementAge: $retirementAge, ')
          ..write('riskProfile: $riskProfile, ')
          ..write('fireProfile: $fireProfile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dateOfBirth, retirementAge, riskProfile, fireProfile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilesDbData &&
          other.id == this.id &&
          other.dateOfBirth == this.dateOfBirth &&
          other.retirementAge == this.retirementAge &&
          other.riskProfile == this.riskProfile &&
          other.fireProfile == this.fireProfile);
}

class ProfilesDbCompanion extends UpdateCompanion<ProfilesDbData> {
  final Value<String> id;
  final Value<String?> dateOfBirth;
  final Value<int?> retirementAge;
  final Value<String?> riskProfile;
  final Value<String?> fireProfile;
  final Value<int> rowid;
  const ProfilesDbCompanion({
    this.id = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.retirementAge = const Value.absent(),
    this.riskProfile = const Value.absent(),
    this.fireProfile = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesDbCompanion.insert({
    required String id,
    this.dateOfBirth = const Value.absent(),
    this.retirementAge = const Value.absent(),
    this.riskProfile = const Value.absent(),
    this.fireProfile = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ProfilesDbData> custom({
    Expression<String>? id,
    Expression<String>? dateOfBirth,
    Expression<int>? retirementAge,
    Expression<String>? riskProfile,
    Expression<String>? fireProfile,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (retirementAge != null) 'retirement_age': retirementAge,
      if (riskProfile != null) 'risk_profile': riskProfile,
      if (fireProfile != null) 'fire_profile': fireProfile,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesDbCompanion copyWith(
      {Value<String>? id,
      Value<String?>? dateOfBirth,
      Value<int?>? retirementAge,
      Value<String?>? riskProfile,
      Value<String?>? fireProfile,
      Value<int>? rowid}) {
    return ProfilesDbCompanion(
      id: id ?? this.id,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      retirementAge: retirementAge ?? this.retirementAge,
      riskProfile: riskProfile ?? this.riskProfile,
      fireProfile: fireProfile ?? this.fireProfile,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (retirementAge.present) {
      map['retirement_age'] = Variable<int>(retirementAge.value);
    }
    if (riskProfile.present) {
      map['risk_profile'] = Variable<String>(riskProfile.value);
    }
    if (fireProfile.present) {
      map['fire_profile'] = Variable<String>(fireProfile.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesDbCompanion(')
          ..write('id: $id, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('retirementAge: $retirementAge, ')
          ..write('riskProfile: $riskProfile, ')
          ..write('fireProfile: $fireProfile, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $AccountsDbTable accountsDb = $AccountsDbTable(this);
  late final $TransactionsDbTable transactionsDb = $TransactionsDbTable(this);
  late final $InvestmentHoldingsDbTable investmentHoldingsDb =
      $InvestmentHoldingsDbTable(this);
  late final $GoalsDbTable goalsDb = $GoalsDbTable(this);
  late final $GoalAccountsDbTable goalAccountsDb = $GoalAccountsDbTable(this);
  late final $ProfilesDbTable profilesDb = $ProfilesDbTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accountsDb,
        transactionsDb,
        investmentHoldingsDb,
        goalsDb,
        goalAccountsDb,
        profilesDb
      ];
}

typedef $$AccountsDbTableInsertCompanionBuilder = AccountsDbCompanion Function({
  required String id,
  required String itemId,
  required String userId,
  required String name,
  Value<String?> mask,
  Value<String?> officialName,
  required double currentBalance,
  required double availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$AccountsDbTableUpdateCompanionBuilder = AccountsDbCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> userId,
  Value<String> name,
  Value<String?> mask,
  Value<String?> officialName,
  Value<double> currentBalance,
  Value<double> availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$AccountsDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsDbTable,
    AccountsDbData,
    $$AccountsDbTableFilterComposer,
    $$AccountsDbTableOrderingComposer,
    $$AccountsDbTableProcessedTableManager,
    $$AccountsDbTableInsertCompanionBuilder,
    $$AccountsDbTableUpdateCompanionBuilder> {
  $$AccountsDbTableTableManager(_$AppDatabase db, $AccountsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AccountsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AccountsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AccountsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<double> availableBalance = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsDbCompanion(
            id: id,
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
            required String id,
            required String itemId,
            required String userId,
            required String name,
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            required double currentBalance,
            required double availableBalance,
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsDbCompanion.insert(
            id: id,
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

class $$AccountsDbTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $AccountsDbTable,
    AccountsDbData,
    $$AccountsDbTableFilterComposer,
    $$AccountsDbTableOrderingComposer,
    $$AccountsDbTableProcessedTableManager,
    $$AccountsDbTableInsertCompanionBuilder,
    $$AccountsDbTableUpdateCompanionBuilder> {
  $$AccountsDbTableProcessedTableManager(super.$state);
}

class $$AccountsDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AccountsDbTable> {
  $$AccountsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$AccountsDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AccountsDbTable> {
  $$AccountsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$TransactionsDbTableInsertCompanionBuilder = TransactionsDbCompanion
    Function({
  required String id,
  required String accountId,
  required String category,
  Value<String?> subcategory,
  required String type,
  required String name,
  required double amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  required String date,
  required int pending,
  Value<String?> accountOwner,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$TransactionsDbTableUpdateCompanionBuilder = TransactionsDbCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> category,
  Value<String?> subcategory,
  Value<String> type,
  Value<String> name,
  Value<double> amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String> date,
  Value<int> pending,
  Value<String?> accountOwner,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$TransactionsDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsDbTable,
    TransactionsDbData,
    $$TransactionsDbTableFilterComposer,
    $$TransactionsDbTableOrderingComposer,
    $$TransactionsDbTableProcessedTableManager,
    $$TransactionsDbTableInsertCompanionBuilder,
    $$TransactionsDbTableUpdateCompanionBuilder> {
  $$TransactionsDbTableTableManager(
      _$AppDatabase db, $TransactionsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransactionsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TransactionsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> pending = const Value.absent(),
            Value<String?> accountOwner = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsDbCompanion(
            id: id,
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
            required String id,
            required String accountId,
            required String category,
            Value<String?> subcategory = const Value.absent(),
            required String type,
            required String name,
            required double amount,
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            required String date,
            required int pending,
            Value<String?> accountOwner = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsDbCompanion.insert(
            id: id,
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

class $$TransactionsDbTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $TransactionsDbTable,
    TransactionsDbData,
    $$TransactionsDbTableFilterComposer,
    $$TransactionsDbTableOrderingComposer,
    $$TransactionsDbTableProcessedTableManager,
    $$TransactionsDbTableInsertCompanionBuilder,
    $$TransactionsDbTableUpdateCompanionBuilder> {
  $$TransactionsDbTableProcessedTableManager(super.$state);
}

class $$TransactionsDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionsDbTable> {
  $$TransactionsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$TransactionsDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionsDbTable> {
  $$TransactionsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$InvestmentHoldingsDbTableInsertCompanionBuilder
    = InvestmentHoldingsDbCompanion Function({
  required String id,
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
typedef $$InvestmentHoldingsDbTableUpdateCompanionBuilder
    = InvestmentHoldingsDbCompanion Function({
  Value<String> id,
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

class $$InvestmentHoldingsDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentHoldingsDbTable,
    InvestmentHoldingsDbData,
    $$InvestmentHoldingsDbTableFilterComposer,
    $$InvestmentHoldingsDbTableOrderingComposer,
    $$InvestmentHoldingsDbTableProcessedTableManager,
    $$InvestmentHoldingsDbTableInsertCompanionBuilder,
    $$InvestmentHoldingsDbTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsDbTableTableManager(
      _$AppDatabase db, $InvestmentHoldingsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$InvestmentHoldingsDbTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$InvestmentHoldingsDbTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$InvestmentHoldingsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
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
              InvestmentHoldingsDbCompanion(
            id: id,
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
            required String id,
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
              InvestmentHoldingsDbCompanion.insert(
            id: id,
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

class $$InvestmentHoldingsDbTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $InvestmentHoldingsDbTable,
        InvestmentHoldingsDbData,
        $$InvestmentHoldingsDbTableFilterComposer,
        $$InvestmentHoldingsDbTableOrderingComposer,
        $$InvestmentHoldingsDbTableProcessedTableManager,
        $$InvestmentHoldingsDbTableInsertCompanionBuilder,
        $$InvestmentHoldingsDbTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsDbTableProcessedTableManager(super.$state);
}

class $$InvestmentHoldingsDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvestmentHoldingsDbTable> {
  $$InvestmentHoldingsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$InvestmentHoldingsDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvestmentHoldingsDbTable> {
  $$InvestmentHoldingsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$GoalsDbTableInsertCompanionBuilder = GoalsDbCompanion Function({
  required String id,
  required String name,
  required double amount,
  required String targetDate,
  required String userId,
  Value<double?> progress,
  required String goalType,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalsDbTableUpdateCompanionBuilder = GoalsDbCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<String> targetDate,
  Value<String> userId,
  Value<double?> progress,
  Value<String> goalType,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalsDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsDbTable,
    GoalsDbData,
    $$GoalsDbTableFilterComposer,
    $$GoalsDbTableOrderingComposer,
    $$GoalsDbTableProcessedTableManager,
    $$GoalsDbTableInsertCompanionBuilder,
    $$GoalsDbTableUpdateCompanionBuilder> {
  $$GoalsDbTableTableManager(_$AppDatabase db, $GoalsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$GoalsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> targetDate = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<double?> progress = const Value.absent(),
            Value<String> goalType = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsDbCompanion(
            id: id,
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            goalType: goalType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            required String name,
            required double amount,
            required String targetDate,
            required String userId,
            Value<double?> progress = const Value.absent(),
            required String goalType,
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsDbCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            goalType: goalType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$GoalsDbTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $GoalsDbTable,
    GoalsDbData,
    $$GoalsDbTableFilterComposer,
    $$GoalsDbTableOrderingComposer,
    $$GoalsDbTableProcessedTableManager,
    $$GoalsDbTableInsertCompanionBuilder,
    $$GoalsDbTableUpdateCompanionBuilder> {
  $$GoalsDbTableProcessedTableManager(super.$state);
}

class $$GoalsDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GoalsDbTable> {
  $$GoalsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
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

  ColumnFilters<String> get goalType => $state.composableBuilder(
      column: $state.table.goalType,
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

class $$GoalsDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GoalsDbTable> {
  $$GoalsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
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

  ColumnOrderings<String> get goalType => $state.composableBuilder(
      column: $state.table.goalType,
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

typedef $$GoalAccountsDbTableInsertCompanionBuilder = GoalAccountsDbCompanion
    Function({
  required String id,
  required String goalId,
  required String accountId,
  required String amount,
  required String percentage,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalAccountsDbTableUpdateCompanionBuilder = GoalAccountsDbCompanion
    Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> accountId,
  Value<String> amount,
  Value<String> percentage,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalAccountsDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalAccountsDbTable,
    GoalAccountsDbData,
    $$GoalAccountsDbTableFilterComposer,
    $$GoalAccountsDbTableOrderingComposer,
    $$GoalAccountsDbTableProcessedTableManager,
    $$GoalAccountsDbTableInsertCompanionBuilder,
    $$GoalAccountsDbTableUpdateCompanionBuilder> {
  $$GoalAccountsDbTableTableManager(
      _$AppDatabase db, $GoalAccountsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalAccountsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalAccountsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GoalAccountsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> amount = const Value.absent(),
            Value<String> percentage = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsDbCompanion(
            id: id,
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
            required String id,
            required String goalId,
            required String accountId,
            required String amount,
            required String percentage,
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsDbCompanion.insert(
            id: id,
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

class $$GoalAccountsDbTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $GoalAccountsDbTable,
    GoalAccountsDbData,
    $$GoalAccountsDbTableFilterComposer,
    $$GoalAccountsDbTableOrderingComposer,
    $$GoalAccountsDbTableProcessedTableManager,
    $$GoalAccountsDbTableInsertCompanionBuilder,
    $$GoalAccountsDbTableUpdateCompanionBuilder> {
  $$GoalAccountsDbTableProcessedTableManager(super.$state);
}

class $$GoalAccountsDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GoalAccountsDbTable> {
  $$GoalAccountsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$GoalAccountsDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GoalAccountsDbTable> {
  $$GoalAccountsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$ProfilesDbTableInsertCompanionBuilder = ProfilesDbCompanion Function({
  required String id,
  Value<String?> dateOfBirth,
  Value<int?> retirementAge,
  Value<String?> riskProfile,
  Value<String?> fireProfile,
  Value<int> rowid,
});
typedef $$ProfilesDbTableUpdateCompanionBuilder = ProfilesDbCompanion Function({
  Value<String> id,
  Value<String?> dateOfBirth,
  Value<int?> retirementAge,
  Value<String?> riskProfile,
  Value<String?> fireProfile,
  Value<int> rowid,
});

class $$ProfilesDbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesDbTable,
    ProfilesDbData,
    $$ProfilesDbTableFilterComposer,
    $$ProfilesDbTableOrderingComposer,
    $$ProfilesDbTableProcessedTableManager,
    $$ProfilesDbTableInsertCompanionBuilder,
    $$ProfilesDbTableUpdateCompanionBuilder> {
  $$ProfilesDbTableTableManager(_$AppDatabase db, $ProfilesDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProfilesDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProfilesDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ProfilesDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String?> dateOfBirth = const Value.absent(),
            Value<int?> retirementAge = const Value.absent(),
            Value<String?> riskProfile = const Value.absent(),
            Value<String?> fireProfile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesDbCompanion(
            id: id,
            dateOfBirth: dateOfBirth,
            retirementAge: retirementAge,
            riskProfile: riskProfile,
            fireProfile: fireProfile,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            Value<String?> dateOfBirth = const Value.absent(),
            Value<int?> retirementAge = const Value.absent(),
            Value<String?> riskProfile = const Value.absent(),
            Value<String?> fireProfile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesDbCompanion.insert(
            id: id,
            dateOfBirth: dateOfBirth,
            retirementAge: retirementAge,
            riskProfile: riskProfile,
            fireProfile: fireProfile,
            rowid: rowid,
          ),
        ));
}

class $$ProfilesDbTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $ProfilesDbTable,
    ProfilesDbData,
    $$ProfilesDbTableFilterComposer,
    $$ProfilesDbTableOrderingComposer,
    $$ProfilesDbTableProcessedTableManager,
    $$ProfilesDbTableInsertCompanionBuilder,
    $$ProfilesDbTableUpdateCompanionBuilder> {
  $$ProfilesDbTableProcessedTableManager(super.$state);
}

class $$ProfilesDbTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProfilesDbTable> {
  $$ProfilesDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retirementAge => $state.composableBuilder(
      column: $state.table.retirementAge,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get riskProfile => $state.composableBuilder(
      column: $state.table.riskProfile,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fireProfile => $state.composableBuilder(
      column: $state.table.fireProfile,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProfilesDbTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProfilesDbTable> {
  $$ProfilesDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retirementAge => $state.composableBuilder(
      column: $state.table.retirementAge,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get riskProfile => $state.composableBuilder(
      column: $state.table.riskProfile,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fireProfile => $state.composableBuilder(
      column: $state.table.fireProfile,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$AccountsDbTableTableManager get accountsDb =>
      $$AccountsDbTableTableManager(_db, _db.accountsDb);
  $$TransactionsDbTableTableManager get transactionsDb =>
      $$TransactionsDbTableTableManager(_db, _db.transactionsDb);
  $$InvestmentHoldingsDbTableTableManager get investmentHoldingsDb =>
      $$InvestmentHoldingsDbTableTableManager(_db, _db.investmentHoldingsDb);
  $$GoalsDbTableTableManager get goalsDb =>
      $$GoalsDbTableTableManager(_db, _db.goalsDb);
  $$GoalAccountsDbTableTableManager get goalAccountsDb =>
      $$GoalAccountsDbTableTableManager(_db, _db.goalAccountsDb);
  $$ProfilesDbTableTableManager get profilesDb =>
      $$ProfilesDbTableTableManager(_db, _db.profilesDb);
}

class $AccountsDbTable extends AccountsDb
    with TableInfo<$AccountsDbTable, AccountsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
      'current_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _availableBalanceMeta =
      const VerificationMeta('availableBalance');
  @override
  late final GeneratedColumn<double> availableBalance = GeneratedColumn<double>(
      'available_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
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
  VerificationContext validateIntegrity(Insertable<AccountsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    } else if (isInserting) {
      context.missing(_currentBalanceMeta);
    }
    if (data.containsKey('available_balance')) {
      context.handle(
          _availableBalanceMeta,
          availableBalance.isAcceptableOrUnknown(
              data['available_balance']!, _availableBalanceMeta));
    } else if (isInserting) {
      context.missing(_availableBalanceMeta);
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  AccountsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mask: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mask']),
      officialName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_name']),
      currentBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_balance'])!,
      availableBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}available_balance'])!,
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
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $AccountsDbTable createAlias(String alias) {
    return $AccountsDbTable(attachedDatabase, alias);
  }
}

class AccountsDbData extends DataClass implements Insertable<AccountsDbData> {
  final String id;
  final String itemId;
  final String userId;
  final String name;
  final String? mask;
  final String? officialName;
  final double currentBalance;
  final double availableBalance;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String? type;
  final String? subtype;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const AccountsDbData(
      {required this.id,
      required this.itemId,
      required this.userId,
      required this.name,
      this.mask,
      this.officialName,
      required this.currentBalance,
      required this.availableBalance,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      this.type,
      this.subtype,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mask != null) {
      map['mask'] = Variable<String>(mask);
    }
    if (!nullToAbsent || officialName != null) {
      map['official_name'] = Variable<String>(officialName);
    }
    map['current_balance'] = Variable<double>(currentBalance);
    map['available_balance'] = Variable<double>(availableBalance);
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
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  AccountsDbCompanion toCompanion(bool nullToAbsent) {
    return AccountsDbCompanion(
      id: Value(id),
      itemId: Value(itemId),
      userId: Value(userId),
      name: Value(name),
      mask: mask == null && nullToAbsent ? const Value.absent() : Value(mask),
      officialName: officialName == null && nullToAbsent
          ? const Value.absent()
          : Value(officialName),
      currentBalance: Value(currentBalance),
      availableBalance: Value(availableBalance),
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
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AccountsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsDbData(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      mask: serializer.fromJson<String?>(json['mask']),
      officialName: serializer.fromJson<String?>(json['officialName']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      availableBalance: serializer.fromJson<double>(json['availableBalance']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      type: serializer.fromJson<String?>(json['type']),
      subtype: serializer.fromJson<String?>(json['subtype']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'mask': serializer.toJson<String?>(mask),
      'officialName': serializer.toJson<String?>(officialName),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'availableBalance': serializer.toJson<double>(availableBalance),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'type': serializer.toJson<String?>(type),
      'subtype': serializer.toJson<String?>(subtype),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  AccountsDbData copyWith(
          {String? id,
          String? itemId,
          String? userId,
          String? name,
          Value<String?> mask = const Value.absent(),
          Value<String?> officialName = const Value.absent(),
          double? currentBalance,
          double? availableBalance,
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> subtype = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      AccountsDbData(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        mask: mask.present ? mask.value : this.mask,
        officialName:
            officialName.present ? officialName.value : this.officialName,
        currentBalance: currentBalance ?? this.currentBalance,
        availableBalance: availableBalance ?? this.availableBalance,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        type: type.present ? type.value : this.type,
        subtype: subtype.present ? subtype.value : this.subtype,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('AccountsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is AccountsDbData &&
          other.id == this.id &&
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

class AccountsDbCompanion extends UpdateCompanion<AccountsDbData> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> mask;
  final Value<String?> officialName;
  final Value<double> currentBalance;
  final Value<double> availableBalance;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String?> type;
  final Value<String?> subtype;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const AccountsDbCompanion({
    this.id = const Value.absent(),
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
  AccountsDbCompanion.insert({
    required String id,
    required String itemId,
    required String userId,
    required String name,
    this.mask = const Value.absent(),
    this.officialName = const Value.absent(),
    required double currentBalance,
    required double availableBalance,
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        userId = Value(userId),
        name = Value(name),
        currentBalance = Value(currentBalance),
        availableBalance = Value(availableBalance),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AccountsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  AccountsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? mask,
      Value<String?>? officialName,
      Value<double>? currentBalance,
      Value<double>? availableBalance,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String?>? type,
      Value<String?>? subtype,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return AccountsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('AccountsDbCompanion(')
          ..write('id: $id, ')
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

class $TransactionsDbTable extends TransactionsDb
    with TableInfo<$TransactionsDbTable, TransactionsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pendingMeta =
      const VerificationMeta('pending');
  @override
  late final GeneratedColumn<int> pending = GeneratedColumn<int>(
      'pending', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
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
  VerificationContext validateIntegrity(Insertable<TransactionsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
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
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
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
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pending')) {
      context.handle(_pendingMeta,
          pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta));
    } else if (isInserting) {
      context.missing(_pendingMeta);
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  TransactionsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isoCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}iso_currency_code']),
      unofficialCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unofficial_currency_code']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      pending: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pending'])!,
      accountOwner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_owner']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $TransactionsDbTable createAlias(String alias) {
    return $TransactionsDbTable(attachedDatabase, alias);
  }
}

class TransactionsDbData extends DataClass
    implements Insertable<TransactionsDbData> {
  final String id;
  final String accountId;
  final String category;
  final String? subcategory;
  final String type;
  final String name;
  final double amount;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String date;
  final int pending;
  final String? accountOwner;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const TransactionsDbData(
      {required this.id,
      required this.accountId,
      required this.category,
      this.subcategory,
      required this.type,
      required this.name,
      required this.amount,
      this.isoCurrencyCode,
      this.unofficialCurrencyCode,
      required this.date,
      required this.pending,
      this.accountOwner,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || isoCurrencyCode != null) {
      map['iso_currency_code'] = Variable<String>(isoCurrencyCode);
    }
    if (!nullToAbsent || unofficialCurrencyCode != null) {
      map['unofficial_currency_code'] =
          Variable<String>(unofficialCurrencyCode);
    }
    map['date'] = Variable<String>(date);
    map['pending'] = Variable<int>(pending);
    if (!nullToAbsent || accountOwner != null) {
      map['account_owner'] = Variable<String>(accountOwner);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  TransactionsDbCompanion toCompanion(bool nullToAbsent) {
    return TransactionsDbCompanion(
      id: Value(id),
      accountId: Value(accountId),
      category: Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      type: Value(type),
      name: Value(name),
      amount: Value(amount),
      isoCurrencyCode: isoCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isoCurrencyCode),
      unofficialCurrencyCode: unofficialCurrencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(unofficialCurrencyCode),
      date: Value(date),
      pending: Value(pending),
      accountOwner: accountOwner == null && nullToAbsent
          ? const Value.absent()
          : Value(accountOwner),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsDbData(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      isoCurrencyCode: serializer.fromJson<String?>(json['isoCurrencyCode']),
      unofficialCurrencyCode:
          serializer.fromJson<String?>(json['unofficialCurrencyCode']),
      date: serializer.fromJson<String>(json['date']),
      pending: serializer.fromJson<int>(json['pending']),
      accountOwner: serializer.fromJson<String?>(json['accountOwner']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'isoCurrencyCode': serializer.toJson<String?>(isoCurrencyCode),
      'unofficialCurrencyCode':
          serializer.toJson<String?>(unofficialCurrencyCode),
      'date': serializer.toJson<String>(date),
      'pending': serializer.toJson<int>(pending),
      'accountOwner': serializer.toJson<String?>(accountOwner),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  TransactionsDbData copyWith(
          {String? id,
          String? accountId,
          String? category,
          Value<String?> subcategory = const Value.absent(),
          String? type,
          String? name,
          double? amount,
          Value<String?> isoCurrencyCode = const Value.absent(),
          Value<String?> unofficialCurrencyCode = const Value.absent(),
          String? date,
          int? pending,
          Value<String?> accountOwner = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      TransactionsDbData(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        category: category ?? this.category,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        type: type ?? this.type,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        isoCurrencyCode: isoCurrencyCode.present
            ? isoCurrencyCode.value
            : this.isoCurrencyCode,
        unofficialCurrencyCode: unofficialCurrencyCode.present
            ? unofficialCurrencyCode.value
            : this.unofficialCurrencyCode,
        date: date ?? this.date,
        pending: pending ?? this.pending,
        accountOwner:
            accountOwner.present ? accountOwner.value : this.accountOwner,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is TransactionsDbData &&
          other.id == this.id &&
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

class TransactionsDbCompanion extends UpdateCompanion<TransactionsDbData> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> category;
  final Value<String?> subcategory;
  final Value<String> type;
  final Value<String> name;
  final Value<double> amount;
  final Value<String?> isoCurrencyCode;
  final Value<String?> unofficialCurrencyCode;
  final Value<String> date;
  final Value<int> pending;
  final Value<String?> accountOwner;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const TransactionsDbCompanion({
    this.id = const Value.absent(),
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
  TransactionsDbCompanion.insert({
    required String id,
    required String accountId,
    required String category,
    this.subcategory = const Value.absent(),
    required String type,
    required String name,
    required double amount,
    this.isoCurrencyCode = const Value.absent(),
    this.unofficialCurrencyCode = const Value.absent(),
    required String date,
    required int pending,
    this.accountOwner = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        category = Value(category),
        type = Value(type),
        name = Value(name),
        amount = Value(amount),
        date = Value(date),
        pending = Value(pending),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TransactionsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  TransactionsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String>? category,
      Value<String?>? subcategory,
      Value<String>? type,
      Value<String>? name,
      Value<double>? amount,
      Value<String?>? isoCurrencyCode,
      Value<String?>? unofficialCurrencyCode,
      Value<String>? date,
      Value<int>? pending,
      Value<String?>? accountOwner,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return TransactionsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('TransactionsDbCompanion(')
          ..write('id: $id, ')
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

class $InvestmentHoldingsDbTable extends InvestmentHoldingsDb
    with TableInfo<$InvestmentHoldingsDbTable, InvestmentHoldingsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentHoldingsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
        id,
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
      Insertable<InvestmentHoldingsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
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
  InvestmentHoldingsDbData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentHoldingsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
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
  $InvestmentHoldingsDbTable createAlias(String alias) {
    return $InvestmentHoldingsDbTable(attachedDatabase, alias);
  }
}

class InvestmentHoldingsDbData extends DataClass
    implements Insertable<InvestmentHoldingsDbData> {
  final String id;
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
  const InvestmentHoldingsDbData(
      {required this.id,
      this.accountId,
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
    map['id'] = Variable<String>(id);
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

  InvestmentHoldingsDbCompanion toCompanion(bool nullToAbsent) {
    return InvestmentHoldingsDbCompanion(
      id: Value(id),
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

  factory InvestmentHoldingsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentHoldingsDbData(
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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

  InvestmentHoldingsDbData copyWith(
          {String? id,
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
          Value<String?> deletedAt = const Value.absent()}) =>
      InvestmentHoldingsDbData(
        id: id ?? this.id,
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
    return (StringBuffer('InvestmentHoldingsDbData(')
          ..write('id: $id, ')
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
      id,
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
      (other is InvestmentHoldingsDbData &&
          other.id == this.id &&
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

class InvestmentHoldingsDbCompanion
    extends UpdateCompanion<InvestmentHoldingsDbData> {
  final Value<String> id;
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
  const InvestmentHoldingsDbCompanion({
    this.id = const Value.absent(),
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
  InvestmentHoldingsDbCompanion.insert({
    required String id,
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
  }) : id = Value(id);
  static Insertable<InvestmentHoldingsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  InvestmentHoldingsDbCompanion copyWith(
      {Value<String>? id,
      Value<String?>? accountId,
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
    return InvestmentHoldingsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('InvestmentHoldingsDbCompanion(')
          ..write('id: $id, ')
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

class $GoalsDbTable extends GoalsDb with TableInfo<$GoalsDbTable, GoalsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
      'target_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _goalTypeMeta =
      const VerificationMeta('goalType');
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
      'goal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amount,
        targetDate,
        userId,
        progress,
        goalType,
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
  VerificationContext validateIntegrity(Insertable<GoalsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('goal_type')) {
      context.handle(_goalTypeMeta,
          goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta));
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  GoalsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_date'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress']),
      goalType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalsDbTable createAlias(String alias) {
    return $GoalsDbTable(attachedDatabase, alias);
  }
}

class GoalsDbData extends DataClass implements Insertable<GoalsDbData> {
  final String id;
  final String name;
  final double amount;
  final String targetDate;
  final String userId;
  final double? progress;
  final String goalType;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const GoalsDbData(
      {required this.id,
      required this.name,
      required this.amount,
      required this.targetDate,
      required this.userId,
      this.progress,
      required this.goalType,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['target_date'] = Variable<String>(targetDate);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<double>(progress);
    }
    map['goal_type'] = Variable<String>(goalType);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalsDbCompanion toCompanion(bool nullToAbsent) {
    return GoalsDbCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      targetDate: Value(targetDate),
      userId: Value(userId),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      goalType: Value(goalType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsDbData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      targetDate: serializer.fromJson<String>(json['targetDate']),
      userId: serializer.fromJson<String>(json['userId']),
      progress: serializer.fromJson<double?>(json['progress']),
      goalType: serializer.fromJson<String>(json['goalType']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'targetDate': serializer.toJson<String>(targetDate),
      'userId': serializer.toJson<String>(userId),
      'progress': serializer.toJson<double?>(progress),
      'goalType': serializer.toJson<String>(goalType),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalsDbData copyWith(
          {String? id,
          String? name,
          double? amount,
          String? targetDate,
          String? userId,
          Value<double?> progress = const Value.absent(),
          String? goalType,
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalsDbData(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        targetDate: targetDate ?? this.targetDate,
        userId: userId ?? this.userId,
        progress: progress.present ? progress.value : this.progress,
        goalType: goalType ?? this.goalType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalsDbData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, targetDate, userId,
      progress, goalType, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsDbData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.targetDate == this.targetDate &&
          other.userId == this.userId &&
          other.progress == this.progress &&
          other.goalType == this.goalType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalsDbCompanion extends UpdateCompanion<GoalsDbData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> targetDate;
  final Value<String> userId;
  final Value<double?> progress;
  final Value<String> goalType;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalsDbCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.progress = const Value.absent(),
    this.goalType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsDbCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required String targetDate,
    required String userId,
    this.progress = const Value.absent(),
    required String goalType,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        targetDate = Value(targetDate),
        userId = Value(userId),
        goalType = Value(goalType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GoalsDbData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? targetDate,
    Expression<String>? userId,
    Expression<double>? progress,
    Expression<String>? goalType,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (targetDate != null) 'target_date': targetDate,
      if (userId != null) 'user_id': userId,
      if (progress != null) 'progress': progress,
      if (goalType != null) 'goal_type': goalType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? targetDate,
      Value<String>? userId,
      Value<double?>? progress,
      Value<String>? goalType,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalsDbCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      targetDate: targetDate ?? this.targetDate,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
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
    return (StringBuffer('GoalsDbCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('targetDate: $targetDate, ')
          ..write('userId: $userId, ')
          ..write('progress: $progress, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalAccountsDbTable extends GoalAccountsDb
    with TableInfo<$GoalAccountsDbTable, GoalAccountsDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalAccountsDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<String> percentage = GeneratedColumn<String>(
      'percentage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalId,
        accountId,
        amount,
        percentage,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<GoalAccountsDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  GoalAccountsDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalAccountsDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}percentage'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoalAccountsDbTable createAlias(String alias) {
    return $GoalAccountsDbTable(attachedDatabase, alias);
  }
}

class GoalAccountsDbData extends DataClass
    implements Insertable<GoalAccountsDbData> {
  final String id;
  final String goalId;
  final String accountId;
  final String amount;
  final String percentage;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const GoalAccountsDbData(
      {required this.id,
      required this.goalId,
      required this.accountId,
      required this.amount,
      required this.percentage,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['account_id'] = Variable<String>(accountId);
    map['amount'] = Variable<String>(amount);
    map['percentage'] = Variable<String>(percentage);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  GoalAccountsDbCompanion toCompanion(bool nullToAbsent) {
    return GoalAccountsDbCompanion(
      id: Value(id),
      goalId: Value(goalId),
      accountId: Value(accountId),
      amount: Value(amount),
      percentage: Value(percentage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalAccountsDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalAccountsDbData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      amount: serializer.fromJson<String>(json['amount']),
      percentage: serializer.fromJson<String>(json['percentage']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'accountId': serializer.toJson<String>(accountId),
      'amount': serializer.toJson<String>(amount),
      'percentage': serializer.toJson<String>(percentage),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  GoalAccountsDbData copyWith(
          {String? id,
          String? goalId,
          String? accountId,
          String? amount,
          String? percentage,
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent()}) =>
      GoalAccountsDbData(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        accountId: accountId ?? this.accountId,
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GoalAccountsDbData(')
          ..write('id: $id, ')
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
  int get hashCode => Object.hash(id, goalId, accountId, amount, percentage,
      createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalAccountsDbData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.amount == this.amount &&
          other.percentage == this.percentage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoalAccountsDbCompanion extends UpdateCompanion<GoalAccountsDbData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> accountId;
  final Value<String> amount;
  final Value<String> percentage;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const GoalAccountsDbCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.percentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalAccountsDbCompanion.insert({
    required String id,
    required String goalId,
    required String accountId,
    required String amount,
    required String percentage,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        accountId = Value(accountId),
        amount = Value(amount),
        percentage = Value(percentage),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GoalAccountsDbData> custom({
    Expression<String>? id,
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
      if (id != null) 'id': id,
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

  GoalAccountsDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<String>? accountId,
      Value<String>? amount,
      Value<String>? percentage,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<int>? rowid}) {
    return GoalAccountsDbCompanion(
      id: id ?? this.id,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
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
    return (StringBuffer('GoalAccountsDbCompanion(')
          ..write('id: $id, ')
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

class $ProfilesDbTable extends ProfilesDb
    with TableInfo<$ProfilesDbTable, ProfilesDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesDbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _retirementAgeMeta =
      const VerificationMeta('retirementAge');
  @override
  late final GeneratedColumn<int> retirementAge = GeneratedColumn<int>(
      'retirement_age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _riskProfileMeta =
      const VerificationMeta('riskProfile');
  @override
  late final GeneratedColumn<String> riskProfile = GeneratedColumn<String>(
      'risk_profile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fireProfileMeta =
      const VerificationMeta('fireProfile');
  @override
  late final GeneratedColumn<String> fireProfile = GeneratedColumn<String>(
      'fire_profile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dateOfBirth, retirementAge, riskProfile, fireProfile];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<ProfilesDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('retirement_age')) {
      context.handle(
          _retirementAgeMeta,
          retirementAge.isAcceptableOrUnknown(
              data['retirement_age']!, _retirementAgeMeta));
    }
    if (data.containsKey('risk_profile')) {
      context.handle(
          _riskProfileMeta,
          riskProfile.isAcceptableOrUnknown(
              data['risk_profile']!, _riskProfileMeta));
    }
    if (data.containsKey('fire_profile')) {
      context.handle(
          _fireProfileMeta,
          fireProfile.isAcceptableOrUnknown(
              data['fire_profile']!, _fireProfileMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ProfilesDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilesDbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_of_birth']),
      retirementAge: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retirement_age']),
      riskProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_profile']),
      fireProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fire_profile']),
    );
  }

  @override
  $ProfilesDbTable createAlias(String alias) {
    return $ProfilesDbTable(attachedDatabase, alias);
  }
}

class ProfilesDbData extends DataClass implements Insertable<ProfilesDbData> {
  final String id;
  final String? dateOfBirth;
  final int? retirementAge;
  final String? riskProfile;
  final String? fireProfile;
  const ProfilesDbData(
      {required this.id,
      this.dateOfBirth,
      this.retirementAge,
      this.riskProfile,
      this.fireProfile});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || retirementAge != null) {
      map['retirement_age'] = Variable<int>(retirementAge);
    }
    if (!nullToAbsent || riskProfile != null) {
      map['risk_profile'] = Variable<String>(riskProfile);
    }
    if (!nullToAbsent || fireProfile != null) {
      map['fire_profile'] = Variable<String>(fireProfile);
    }
    return map;
  }

  ProfilesDbCompanion toCompanion(bool nullToAbsent) {
    return ProfilesDbCompanion(
      id: Value(id),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      retirementAge: retirementAge == null && nullToAbsent
          ? const Value.absent()
          : Value(retirementAge),
      riskProfile: riskProfile == null && nullToAbsent
          ? const Value.absent()
          : Value(riskProfile),
      fireProfile: fireProfile == null && nullToAbsent
          ? const Value.absent()
          : Value(fireProfile),
    );
  }

  factory ProfilesDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilesDbData(
      id: serializer.fromJson<String>(json['id']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      retirementAge: serializer.fromJson<int?>(json['retirementAge']),
      riskProfile: serializer.fromJson<String?>(json['riskProfile']),
      fireProfile: serializer.fromJson<String?>(json['fireProfile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'retirementAge': serializer.toJson<int?>(retirementAge),
      'riskProfile': serializer.toJson<String?>(riskProfile),
      'fireProfile': serializer.toJson<String?>(fireProfile),
    };
  }

  ProfilesDbData copyWith(
          {String? id,
          Value<String?> dateOfBirth = const Value.absent(),
          Value<int?> retirementAge = const Value.absent(),
          Value<String?> riskProfile = const Value.absent(),
          Value<String?> fireProfile = const Value.absent()}) =>
      ProfilesDbData(
        id: id ?? this.id,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        retirementAge:
            retirementAge.present ? retirementAge.value : this.retirementAge,
        riskProfile: riskProfile.present ? riskProfile.value : this.riskProfile,
        fireProfile: fireProfile.present ? fireProfile.value : this.fireProfile,
      );
  @override
  String toString() {
    return (StringBuffer('ProfilesDbData(')
          ..write('id: $id, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('retirementAge: $retirementAge, ')
          ..write('riskProfile: $riskProfile, ')
          ..write('fireProfile: $fireProfile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dateOfBirth, retirementAge, riskProfile, fireProfile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilesDbData &&
          other.id == this.id &&
          other.dateOfBirth == this.dateOfBirth &&
          other.retirementAge == this.retirementAge &&
          other.riskProfile == this.riskProfile &&
          other.fireProfile == this.fireProfile);
}

class ProfilesDbCompanion extends UpdateCompanion<ProfilesDbData> {
  final Value<String> id;
  final Value<String?> dateOfBirth;
  final Value<int?> retirementAge;
  final Value<String?> riskProfile;
  final Value<String?> fireProfile;
  final Value<int> rowid;
  const ProfilesDbCompanion({
    this.id = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.retirementAge = const Value.absent(),
    this.riskProfile = const Value.absent(),
    this.fireProfile = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesDbCompanion.insert({
    required String id,
    this.dateOfBirth = const Value.absent(),
    this.retirementAge = const Value.absent(),
    this.riskProfile = const Value.absent(),
    this.fireProfile = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ProfilesDbData> custom({
    Expression<String>? id,
    Expression<String>? dateOfBirth,
    Expression<int>? retirementAge,
    Expression<String>? riskProfile,
    Expression<String>? fireProfile,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (retirementAge != null) 'retirement_age': retirementAge,
      if (riskProfile != null) 'risk_profile': riskProfile,
      if (fireProfile != null) 'fire_profile': fireProfile,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesDbCompanion copyWith(
      {Value<String>? id,
      Value<String?>? dateOfBirth,
      Value<int?>? retirementAge,
      Value<String?>? riskProfile,
      Value<String?>? fireProfile,
      Value<int>? rowid}) {
    return ProfilesDbCompanion(
      id: id ?? this.id,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      retirementAge: retirementAge ?? this.retirementAge,
      riskProfile: riskProfile ?? this.riskProfile,
      fireProfile: fireProfile ?? this.fireProfile,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (retirementAge.present) {
      map['retirement_age'] = Variable<int>(retirementAge.value);
    }
    if (riskProfile.present) {
      map['risk_profile'] = Variable<String>(riskProfile.value);
    }
    if (fireProfile.present) {
      map['fire_profile'] = Variable<String>(fireProfile.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesDbCompanion(')
          ..write('id: $id, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('retirementAge: $retirementAge, ')
          ..write('riskProfile: $riskProfile, ')
          ..write('fireProfile: $fireProfile, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DemoAppDatabase extends GeneratedDatabase {
  _$DemoAppDatabase(QueryExecutor e) : super(e);
  _$DemoAppDatabaseManager get managers => _$DemoAppDatabaseManager(this);
  late final $AccountsDbTable accountsDb = $AccountsDbTable(this);
  late final $TransactionsDbTable transactionsDb = $TransactionsDbTable(this);
  late final $InvestmentHoldingsDbTable investmentHoldingsDb =
      $InvestmentHoldingsDbTable(this);
  late final $GoalsDbTable goalsDb = $GoalsDbTable(this);
  late final $GoalAccountsDbTable goalAccountsDb = $GoalAccountsDbTable(this);
  late final $ProfilesDbTable profilesDb = $ProfilesDbTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accountsDb,
        transactionsDb,
        investmentHoldingsDb,
        goalsDb,
        goalAccountsDb,
        profilesDb
      ];
}

typedef $$AccountsDbTableInsertCompanionBuilder = AccountsDbCompanion Function({
  required String id,
  required String itemId,
  required String userId,
  required String name,
  Value<String?> mask,
  Value<String?> officialName,
  required double currentBalance,
  required double availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$AccountsDbTableUpdateCompanionBuilder = AccountsDbCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> userId,
  Value<String> name,
  Value<String?> mask,
  Value<String?> officialName,
  Value<double> currentBalance,
  Value<double> availableBalance,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String?> type,
  Value<String?> subtype,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$AccountsDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $AccountsDbTable,
    AccountsDbData,
    $$AccountsDbTableFilterComposer,
    $$AccountsDbTableOrderingComposer,
    $$AccountsDbTableProcessedTableManager,
    $$AccountsDbTableInsertCompanionBuilder,
    $$AccountsDbTableUpdateCompanionBuilder> {
  $$AccountsDbTableTableManager(_$DemoAppDatabase db, $AccountsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AccountsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AccountsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AccountsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<double> availableBalance = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsDbCompanion(
            id: id,
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
            required String id,
            required String itemId,
            required String userId,
            required String name,
            Value<String?> mask = const Value.absent(),
            Value<String?> officialName = const Value.absent(),
            required double currentBalance,
            required double availableBalance,
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> subtype = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsDbCompanion.insert(
            id: id,
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

class $$AccountsDbTableProcessedTableManager extends ProcessedTableManager<
    _$DemoAppDatabase,
    $AccountsDbTable,
    AccountsDbData,
    $$AccountsDbTableFilterComposer,
    $$AccountsDbTableOrderingComposer,
    $$AccountsDbTableProcessedTableManager,
    $$AccountsDbTableInsertCompanionBuilder,
    $$AccountsDbTableUpdateCompanionBuilder> {
  $$AccountsDbTableProcessedTableManager(super.$state);
}

class $$AccountsDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $AccountsDbTable> {
  $$AccountsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$AccountsDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $AccountsDbTable> {
  $$AccountsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$TransactionsDbTableInsertCompanionBuilder = TransactionsDbCompanion
    Function({
  required String id,
  required String accountId,
  required String category,
  Value<String?> subcategory,
  required String type,
  required String name,
  required double amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  required String date,
  required int pending,
  Value<String?> accountOwner,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$TransactionsDbTableUpdateCompanionBuilder = TransactionsDbCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> category,
  Value<String?> subcategory,
  Value<String> type,
  Value<String> name,
  Value<double> amount,
  Value<String?> isoCurrencyCode,
  Value<String?> unofficialCurrencyCode,
  Value<String> date,
  Value<int> pending,
  Value<String?> accountOwner,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$TransactionsDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $TransactionsDbTable,
    TransactionsDbData,
    $$TransactionsDbTableFilterComposer,
    $$TransactionsDbTableOrderingComposer,
    $$TransactionsDbTableProcessedTableManager,
    $$TransactionsDbTableInsertCompanionBuilder,
    $$TransactionsDbTableUpdateCompanionBuilder> {
  $$TransactionsDbTableTableManager(
      _$DemoAppDatabase db, $TransactionsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransactionsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TransactionsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> pending = const Value.absent(),
            Value<String?> accountOwner = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsDbCompanion(
            id: id,
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
            required String id,
            required String accountId,
            required String category,
            Value<String?> subcategory = const Value.absent(),
            required String type,
            required String name,
            required double amount,
            Value<String?> isoCurrencyCode = const Value.absent(),
            Value<String?> unofficialCurrencyCode = const Value.absent(),
            required String date,
            required int pending,
            Value<String?> accountOwner = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsDbCompanion.insert(
            id: id,
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

class $$TransactionsDbTableProcessedTableManager extends ProcessedTableManager<
    _$DemoAppDatabase,
    $TransactionsDbTable,
    TransactionsDbData,
    $$TransactionsDbTableFilterComposer,
    $$TransactionsDbTableOrderingComposer,
    $$TransactionsDbTableProcessedTableManager,
    $$TransactionsDbTableInsertCompanionBuilder,
    $$TransactionsDbTableUpdateCompanionBuilder> {
  $$TransactionsDbTableProcessedTableManager(super.$state);
}

class $$TransactionsDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $TransactionsDbTable> {
  $$TransactionsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$TransactionsDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $TransactionsDbTable> {
  $$TransactionsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$InvestmentHoldingsDbTableInsertCompanionBuilder
    = InvestmentHoldingsDbCompanion Function({
  required String id,
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
typedef $$InvestmentHoldingsDbTableUpdateCompanionBuilder
    = InvestmentHoldingsDbCompanion Function({
  Value<String> id,
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

class $$InvestmentHoldingsDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $InvestmentHoldingsDbTable,
    InvestmentHoldingsDbData,
    $$InvestmentHoldingsDbTableFilterComposer,
    $$InvestmentHoldingsDbTableOrderingComposer,
    $$InvestmentHoldingsDbTableProcessedTableManager,
    $$InvestmentHoldingsDbTableInsertCompanionBuilder,
    $$InvestmentHoldingsDbTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsDbTableTableManager(
      _$DemoAppDatabase db, $InvestmentHoldingsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$InvestmentHoldingsDbTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$InvestmentHoldingsDbTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$InvestmentHoldingsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
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
              InvestmentHoldingsDbCompanion(
            id: id,
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
            required String id,
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
              InvestmentHoldingsDbCompanion.insert(
            id: id,
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

class $$InvestmentHoldingsDbTableProcessedTableManager
    extends ProcessedTableManager<
        _$DemoAppDatabase,
        $InvestmentHoldingsDbTable,
        InvestmentHoldingsDbData,
        $$InvestmentHoldingsDbTableFilterComposer,
        $$InvestmentHoldingsDbTableOrderingComposer,
        $$InvestmentHoldingsDbTableProcessedTableManager,
        $$InvestmentHoldingsDbTableInsertCompanionBuilder,
        $$InvestmentHoldingsDbTableUpdateCompanionBuilder> {
  $$InvestmentHoldingsDbTableProcessedTableManager(super.$state);
}

class $$InvestmentHoldingsDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $InvestmentHoldingsDbTable> {
  $$InvestmentHoldingsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$InvestmentHoldingsDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $InvestmentHoldingsDbTable> {
  $$InvestmentHoldingsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$GoalsDbTableInsertCompanionBuilder = GoalsDbCompanion Function({
  required String id,
  required String name,
  required double amount,
  required String targetDate,
  required String userId,
  Value<double?> progress,
  required String goalType,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalsDbTableUpdateCompanionBuilder = GoalsDbCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<String> targetDate,
  Value<String> userId,
  Value<double?> progress,
  Value<String> goalType,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalsDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $GoalsDbTable,
    GoalsDbData,
    $$GoalsDbTableFilterComposer,
    $$GoalsDbTableOrderingComposer,
    $$GoalsDbTableProcessedTableManager,
    $$GoalsDbTableInsertCompanionBuilder,
    $$GoalsDbTableUpdateCompanionBuilder> {
  $$GoalsDbTableTableManager(_$DemoAppDatabase db, $GoalsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$GoalsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> targetDate = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<double?> progress = const Value.absent(),
            Value<String> goalType = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsDbCompanion(
            id: id,
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            goalType: goalType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            required String name,
            required double amount,
            required String targetDate,
            required String userId,
            Value<double?> progress = const Value.absent(),
            required String goalType,
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsDbCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            targetDate: targetDate,
            userId: userId,
            progress: progress,
            goalType: goalType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
        ));
}

class $$GoalsDbTableProcessedTableManager extends ProcessedTableManager<
    _$DemoAppDatabase,
    $GoalsDbTable,
    GoalsDbData,
    $$GoalsDbTableFilterComposer,
    $$GoalsDbTableOrderingComposer,
    $$GoalsDbTableProcessedTableManager,
    $$GoalsDbTableInsertCompanionBuilder,
    $$GoalsDbTableUpdateCompanionBuilder> {
  $$GoalsDbTableProcessedTableManager(super.$state);
}

class $$GoalsDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $GoalsDbTable> {
  $$GoalsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
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

  ColumnFilters<String> get goalType => $state.composableBuilder(
      column: $state.table.goalType,
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

class $$GoalsDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $GoalsDbTable> {
  $$GoalsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
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

  ColumnOrderings<String> get goalType => $state.composableBuilder(
      column: $state.table.goalType,
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

typedef $$GoalAccountsDbTableInsertCompanionBuilder = GoalAccountsDbCompanion
    Function({
  required String id,
  required String goalId,
  required String accountId,
  required String amount,
  required String percentage,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$GoalAccountsDbTableUpdateCompanionBuilder = GoalAccountsDbCompanion
    Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> accountId,
  Value<String> amount,
  Value<String> percentage,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$GoalAccountsDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $GoalAccountsDbTable,
    GoalAccountsDbData,
    $$GoalAccountsDbTableFilterComposer,
    $$GoalAccountsDbTableOrderingComposer,
    $$GoalAccountsDbTableProcessedTableManager,
    $$GoalAccountsDbTableInsertCompanionBuilder,
    $$GoalAccountsDbTableUpdateCompanionBuilder> {
  $$GoalAccountsDbTableTableManager(
      _$DemoAppDatabase db, $GoalAccountsDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalAccountsDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalAccountsDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GoalAccountsDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> amount = const Value.absent(),
            Value<String> percentage = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsDbCompanion(
            id: id,
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
            required String id,
            required String goalId,
            required String accountId,
            required String amount,
            required String percentage,
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAccountsDbCompanion.insert(
            id: id,
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

class $$GoalAccountsDbTableProcessedTableManager extends ProcessedTableManager<
    _$DemoAppDatabase,
    $GoalAccountsDbTable,
    GoalAccountsDbData,
    $$GoalAccountsDbTableFilterComposer,
    $$GoalAccountsDbTableOrderingComposer,
    $$GoalAccountsDbTableProcessedTableManager,
    $$GoalAccountsDbTableInsertCompanionBuilder,
    $$GoalAccountsDbTableUpdateCompanionBuilder> {
  $$GoalAccountsDbTableProcessedTableManager(super.$state);
}

class $$GoalAccountsDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $GoalAccountsDbTable> {
  $$GoalAccountsDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

class $$GoalAccountsDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $GoalAccountsDbTable> {
  $$GoalAccountsDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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

typedef $$ProfilesDbTableInsertCompanionBuilder = ProfilesDbCompanion Function({
  required String id,
  Value<String?> dateOfBirth,
  Value<int?> retirementAge,
  Value<String?> riskProfile,
  Value<String?> fireProfile,
  Value<int> rowid,
});
typedef $$ProfilesDbTableUpdateCompanionBuilder = ProfilesDbCompanion Function({
  Value<String> id,
  Value<String?> dateOfBirth,
  Value<int?> retirementAge,
  Value<String?> riskProfile,
  Value<String?> fireProfile,
  Value<int> rowid,
});

class $$ProfilesDbTableTableManager extends RootTableManager<
    _$DemoAppDatabase,
    $ProfilesDbTable,
    ProfilesDbData,
    $$ProfilesDbTableFilterComposer,
    $$ProfilesDbTableOrderingComposer,
    $$ProfilesDbTableProcessedTableManager,
    $$ProfilesDbTableInsertCompanionBuilder,
    $$ProfilesDbTableUpdateCompanionBuilder> {
  $$ProfilesDbTableTableManager(_$DemoAppDatabase db, $ProfilesDbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProfilesDbTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProfilesDbTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ProfilesDbTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String?> dateOfBirth = const Value.absent(),
            Value<int?> retirementAge = const Value.absent(),
            Value<String?> riskProfile = const Value.absent(),
            Value<String?> fireProfile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesDbCompanion(
            id: id,
            dateOfBirth: dateOfBirth,
            retirementAge: retirementAge,
            riskProfile: riskProfile,
            fireProfile: fireProfile,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            Value<String?> dateOfBirth = const Value.absent(),
            Value<int?> retirementAge = const Value.absent(),
            Value<String?> riskProfile = const Value.absent(),
            Value<String?> fireProfile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesDbCompanion.insert(
            id: id,
            dateOfBirth: dateOfBirth,
            retirementAge: retirementAge,
            riskProfile: riskProfile,
            fireProfile: fireProfile,
            rowid: rowid,
          ),
        ));
}

class $$ProfilesDbTableProcessedTableManager extends ProcessedTableManager<
    _$DemoAppDatabase,
    $ProfilesDbTable,
    ProfilesDbData,
    $$ProfilesDbTableFilterComposer,
    $$ProfilesDbTableOrderingComposer,
    $$ProfilesDbTableProcessedTableManager,
    $$ProfilesDbTableInsertCompanionBuilder,
    $$ProfilesDbTableUpdateCompanionBuilder> {
  $$ProfilesDbTableProcessedTableManager(super.$state);
}

class $$ProfilesDbTableFilterComposer
    extends FilterComposer<_$DemoAppDatabase, $ProfilesDbTable> {
  $$ProfilesDbTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retirementAge => $state.composableBuilder(
      column: $state.table.retirementAge,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get riskProfile => $state.composableBuilder(
      column: $state.table.riskProfile,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fireProfile => $state.composableBuilder(
      column: $state.table.fireProfile,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProfilesDbTableOrderingComposer
    extends OrderingComposer<_$DemoAppDatabase, $ProfilesDbTable> {
  $$ProfilesDbTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retirementAge => $state.composableBuilder(
      column: $state.table.retirementAge,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get riskProfile => $state.composableBuilder(
      column: $state.table.riskProfile,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fireProfile => $state.composableBuilder(
      column: $state.table.fireProfile,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$DemoAppDatabaseManager {
  final _$DemoAppDatabase _db;
  _$DemoAppDatabaseManager(this._db);
  $$AccountsDbTableTableManager get accountsDb =>
      $$AccountsDbTableTableManager(_db, _db.accountsDb);
  $$TransactionsDbTableTableManager get transactionsDb =>
      $$TransactionsDbTableTableManager(_db, _db.transactionsDb);
  $$InvestmentHoldingsDbTableTableManager get investmentHoldingsDb =>
      $$InvestmentHoldingsDbTableTableManager(_db, _db.investmentHoldingsDb);
  $$GoalsDbTableTableManager get goalsDb =>
      $$GoalsDbTableTableManager(_db, _db.goalsDb);
  $$GoalAccountsDbTableTableManager get goalAccountsDb =>
      $$GoalAccountsDbTableTableManager(_db, _db.goalAccountsDb);
  $$ProfilesDbTableTableManager get profilesDb =>
      $$ProfilesDbTableTableManager(_db, _db.profilesDb);
}
