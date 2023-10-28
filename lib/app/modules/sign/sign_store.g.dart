// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignStore on _SignStoreBase, Store {
  final _$valueUserAtom = Atom(name: '_SignStoreBase.valueUser');

  @override
  User get valueUser {
    _$valueUserAtom.reportRead();
    return super.valueUser;
  }

  @override
  set valueUser(User value) {
    _$valueUserAtom.reportWrite(value, super.valueUser, () {
      super.valueUser = value;
    });
  }

  final _$valueUser1Atom = Atom(name: '_SignStoreBase.valueUser1');

  @override
  User get valueUser1 {
    _$valueUser1Atom.reportRead();
    return super.valueUser1;
  }

  @override
  set valueUser1(User value) {
    _$valueUser1Atom.reportWrite(value, super.valueUser1, () {
      super.valueUser1 = value;
    });
  }

  final _$sadasdaAtom = Atom(name: '_SignStoreBase.sadasda');

  @override
  User get sadasda {
    _$sadasdaAtom.reportRead();
    return super.sadasda;
  }

  @override
  set sadasda(User value) {
    _$sadasdaAtom.reportWrite(value, super.sadasda, () {
      super.sadasda = value;
    });
  }

  final _$loadCircularPhoneAtom =
      Atom(name: '_SignStoreBase.loadCircularPhone');

  @override
  bool get loadCircularPhone {
    _$loadCircularPhoneAtom.reportRead();
    return super.loadCircularPhone;
  }

  @override
  set loadCircularPhone(bool value) {
    _$loadCircularPhoneAtom.reportWrite(value, super.loadCircularPhone, () {
      super.loadCircularPhone = value;
    });
  }

  final _$phoneAtom = Atom(name: '_SignStoreBase.phone');

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$codeAtom = Atom(name: '_SignStoreBase.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  final _$timerAtom = Atom(name: '_SignStoreBase.timer');

  @override
  Timer get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(Timer value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  final _$startAtom = Atom(name: '_SignStoreBase.start');

  @override
  int get start {
    _$startAtom.reportRead();
    return super.start;
  }

  @override
  set start(int value) {
    _$startAtom.reportWrite(value, super.start, () {
      super.start = value;
    });
  }

  final _$loadCircularVerifyAtom =
      Atom(name: '_SignStoreBase.loadCircularVerify');

  @override
  bool get loadCircularVerify {
    _$loadCircularVerifyAtom.reportRead();
    return super.loadCircularVerify;
  }

  @override
  set loadCircularVerify(bool value) {
    _$loadCircularVerifyAtom.reportWrite(value, super.loadCircularVerify, () {
      super.loadCircularVerify = value;
    });
  }

  final _$textEditingControllerAtom =
      Atom(name: '_SignStoreBase.textEditingController');

  @override
  TextEditingController get textEditingController {
    _$textEditingControllerAtom.reportRead();
    return super.textEditingController;
  }

  @override
  set textEditingController(TextEditingController value) {
    _$textEditingControllerAtom.reportWrite(value, super.textEditingController,
        () {
      super.textEditingController = value;
    });
  }

  final _$verifyNumberAsyncAction = AsyncAction('_SignStoreBase.verifyNumber');

  @override
  Future verifyNumber() {
    return _$verifyNumberAsyncAction.run(() => super.verifyNumber());
  }

  final _$signinPhoneAsyncAction = AsyncAction('_SignStoreBase.signinPhone');

  @override
  Future signinPhone(String _code, String verifyId, BuildContext context) {
    return _$signinPhoneAsyncAction
        .run(() => super.signinPhone(_code, verifyId, context));
  }

  final _$_SignStoreBaseActionController =
      ActionController(name: '_SignStoreBase');

  @override
  dynamic setUserPhone(String telephone) {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.setUserPhone');
    try {
      return super.setUserPhone(telephone);
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserCode(String _userd) {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.setUserCode');
    try {
      return super.setUserCode(_userd);
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valueUser: ${valueUser},
valueUser1: ${valueUser1},
sadasda: ${sadasda},
loadCircularPhone: ${loadCircularPhone},
phone: ${phone},
code: ${code},
timer: ${timer},
start: ${start},
loadCircularVerify: ${loadCircularVerify},
textEditingController: ${textEditingController}
    ''';
  }
}
