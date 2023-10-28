// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on _SettingsStoreBase, Store {
  final _$returnPeriodAtom = Atom(name: '_SettingsStoreBase.returnPeriod');

  @override
  num get returnPeriod {
    _$returnPeriodAtom.reportRead();
    return super.returnPeriod;
  }

  @override
  set returnPeriod(num value) {
    _$returnPeriodAtom.reportWrite(value, super.returnPeriod, () {
      super.returnPeriod = value;
    });
  }

  final _$priceAtom = Atom(name: '_SettingsStoreBase.price');

  @override
  num get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(num value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  final _$allowedAtom = Atom(name: '_SettingsStoreBase.allowed');

  @override
  bool get allowed {
    _$allowedAtom.reportRead();
    return super.allowed;
  }

  @override
  set allowed(bool value) {
    _$allowedAtom.reportWrite(value, super.allowed, () {
      super.allowed = value;
    });
  }

  final _$loadCircularAtom = Atom(name: '_SettingsStoreBase.loadCircular');

  @override
  bool get loadCircular {
    _$loadCircularAtom.reportRead();
    return super.loadCircular;
  }

  @override
  set loadCircular(bool value) {
    _$loadCircularAtom.reportWrite(value, super.loadCircular, () {
      super.loadCircular = value;
    });
  }

  final _$swiftNotAsyncAction = AsyncAction('_SettingsStoreBase.swiftNot');

  @override
  Future swiftNot(DocumentSnapshot<Object> user, bool value) {
    return _$swiftNotAsyncAction.run(() => super.swiftNot(user, value));
  }

  @override
  String toString() {
    return '''
returnPeriod: ${returnPeriod},
price: ${price},
allowed: ${allowed},
loadCircular: ${loadCircular}
    ''';
  }
}
