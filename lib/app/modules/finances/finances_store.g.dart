// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finances_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FinancesStore on _FinancesStoreBase, Store {
  final _$mainStoreAtom = Atom(name: '_FinancesStoreBase.mainStore');

  @override
  MainStore get mainStore {
    _$mainStoreAtom.reportRead();
    return super.mainStore;
  }

  @override
  set mainStore(MainStore value) {
    _$mainStoreAtom.reportWrite(value, super.mainStore, () {
      super.mainStore = value;
    });
  }

  final _$avatarAtom = Atom(name: '_FinancesStoreBase.avatar');

  @override
  String get avatar {
    _$avatarAtom.reportRead();
    return super.avatar;
  }

  @override
  set avatar(String value) {
    _$avatarAtom.reportWrite(value, super.avatar, () {
      super.avatar = value;
    });
  }

  final _$transactionAtom = Atom(name: '_FinancesStoreBase.transaction');

  @override
  FinancialModel get transaction {
    _$transactionAtom.reportRead();
    return super.transaction;
  }

  @override
  set transaction(FinancialModel value) {
    _$transactionAtom.reportWrite(value, super.transaction, () {
      super.transaction = value;
    });
  }

  final _$approveReversalAsyncAction =
      AsyncAction('_FinancesStoreBase.approveReversal');

  @override
  Future<dynamic> approveReversal(
      {String transactionId, String patientId, String doctorId}) {
    return _$approveReversalAsyncAction.run(() => super.approveReversal(
        transactionId: transactionId,
        patientId: patientId,
        doctorId: doctorId));
  }

  final _$_FinancesStoreBaseActionController =
      ActionController(name: '_FinancesStoreBase');

  @override
  dynamic setTransaction(DocumentSnapshot<Object> trsc) {
    final _$actionInfo = _$_FinancesStoreBaseActionController.startAction(
        name: '_FinancesStoreBase.setTransaction');
    try {
      return super.setTransaction(trsc);
    } finally {
      _$_FinancesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mainStore: ${mainStore},
avatar: ${avatar},
transaction: ${transaction}
    ''';
  }
}
