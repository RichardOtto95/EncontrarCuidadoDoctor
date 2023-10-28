// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suport_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SuportStore on _SuportStoreBase, Store {
  final _$emojisShowAtom = Atom(name: '_SuportStoreBase.emojisShow');

  @override
  bool get emojisShow {
    _$emojisShowAtom.reportRead();
    return super.emojisShow;
  }

  @override
  set emojisShow(bool value) {
    _$emojisShowAtom.reportWrite(value, super.emojisShow, () {
      super.emojisShow = value;
    });
  }

  final _$txtcontrolAtom = Atom(name: '_SuportStoreBase.txtcontrol');

  @override
  TextEditingController get txtcontrol {
    _$txtcontrolAtom.reportRead();
    return super.txtcontrol;
  }

  @override
  set txtcontrol(TextEditingController value) {
    _$txtcontrolAtom.reportWrite(value, super.txtcontrol, () {
      super.txtcontrol = value;
    });
  }

  final _$textAtom = Atom(name: '_SuportStoreBase.text');

  @override
  String get text {
    _$textAtom.reportRead();
    return super.text;
  }

  @override
  set text(String value) {
    _$textAtom.reportWrite(value, super.text, () {
      super.text = value;
    });
  }

  final _$uploadSpinAtom = Atom(name: '_SuportStoreBase.uploadSpin');

  @override
  bool get uploadSpin {
    _$uploadSpinAtom.reportRead();
    return super.uploadSpin;
  }

  @override
  set uploadSpin(bool value) {
    _$uploadSpinAtom.reportWrite(value, super.uploadSpin, () {
      super.uploadSpin = value;
    });
  }

  final _$downloadSpinAtom = Atom(name: '_SuportStoreBase.downloadSpin');

  @override
  bool get downloadSpin {
    _$downloadSpinAtom.reportRead();
    return super.downloadSpin;
  }

  @override
  set downloadSpin(bool value) {
    _$downloadSpinAtom.reportWrite(value, super.downloadSpin, () {
      super.downloadSpin = value;
    });
  }

  final _$photoAtom = Atom(name: '_SuportStoreBase.photo');

  @override
  String get photo {
    _$photoAtom.reportRead();
    return super.photo;
  }

  @override
  set photo(String value) {
    _$photoAtom.reportWrite(value, super.photo, () {
      super.photo = value;
    });
  }

  final _$resultAtom = Atom(name: '_SuportStoreBase.result');

  @override
  FilePickerResult get result {
    _$resultAtom.reportRead();
    return super.result;
  }

  @override
  set result(FilePickerResult value) {
    _$resultAtom.reportWrite(value, super.result, () {
      super.result = value;
    });
  }

  final _$fileBytesAtom = Atom(name: '_SuportStoreBase.fileBytes');

  @override
  File get fileBytes {
    _$fileBytesAtom.reportRead();
    return super.fileBytes;
  }

  @override
  set fileBytes(File value) {
    _$fileBytesAtom.reportWrite(value, super.fileBytes, () {
      super.fileBytes = value;
    });
  }

  final _$fileNameAtom = Atom(name: '_SuportStoreBase.fileName');

  @override
  String get fileName {
    _$fileNameAtom.reportRead();
    return super.fileName;
  }

  @override
  set fileName(String value) {
    _$fileNameAtom.reportWrite(value, super.fileName, () {
      super.fileName = value;
    });
  }

  final _$supportTitleAtom = Atom(name: '_SuportStoreBase.supportTitle');

  @override
  String get supportTitle {
    _$supportTitleAtom.reportRead();
    return super.supportTitle;
  }

  @override
  set supportTitle(String value) {
    _$supportTitleAtom.reportWrite(value, super.supportTitle, () {
      super.supportTitle = value;
    });
  }

  final _$localPathAtom = Atom(name: '_SuportStoreBase.localPath');

  @override
  String get localPath {
    _$localPathAtom.reportRead();
    return super.localPath;
  }

  @override
  set localPath(String value) {
    _$localPathAtom.reportWrite(value, super.localPath, () {
      super.localPath = value;
    });
  }

  final _$appDirAtom = Atom(name: '_SuportStoreBase.appDir');

  @override
  Directory get appDir {
    _$appDirAtom.reportRead();
    return super.appDir;
  }

  @override
  set appDir(Directory value) {
    _$appDirAtom.reportWrite(value, super.appDir, () {
      super.appDir = value;
    });
  }

  final _$bytesAtom = Atom(name: '_SuportStoreBase.bytes');

  @override
  Future<Uint8List> get bytes {
    _$bytesAtom.reportRead();
    return super.bytes;
  }

  @override
  set bytes(Future<Uint8List> value) {
    _$bytesAtom.reportWrite(value, super.bytes, () {
      super.bytes = value;
    });
  }

  final _$fileAtom = Atom(name: '_SuportStoreBase.file');

  @override
  File get file {
    _$fileAtom.reportRead();
    return super.file;
  }

  @override
  set file(File value) {
    _$fileAtom.reportWrite(value, super.file, () {
      super.file = value;
    });
  }

  final _$getDownloadedAsyncAction =
      AsyncAction('_SuportStoreBase.getDownloaded');

  @override
  Future getDownloaded(String name) {
    return _$getDownloadedAsyncAction.run(() => super.getDownloaded(name));
  }

  final _$downloadFilesAsyncAction =
      AsyncAction('_SuportStoreBase.downloadFiles');

  @override
  Future downloadFiles(String url, String name, String id, String message) {
    return _$downloadFilesAsyncAction
        .run(() => super.downloadFiles(url, name, id, message));
  }

  final _$pickImageAsyncAction = AsyncAction('_SuportStoreBase.pickImage');

  @override
  Future pickImage(String id) {
    return _$pickImageAsyncAction.run(() => super.pickImage(id));
  }

  final _$uploadFilesAsyncAction = AsyncAction('_SuportStoreBase.uploadFiles');

  @override
  Future uploadFiles(String id) {
    return _$uploadFilesAsyncAction.run(() => super.uploadFiles(id));
  }

  final _$_SuportStoreBaseActionController =
      ActionController(name: '_SuportStoreBase');

  @override
  dynamic supportDispose() {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.supportDispose');
    try {
      return super.supportDispose();
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setText(String tx) {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.setText');
    try {
      return super.setText(tx);
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmojisShow(bool sh) {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.setEmojisShow');
    try {
      return super.setEmojisShow(sh);
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUploadSpin(bool sh) {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.setUploadSpin');
    try {
      return super.setUploadSpin(sh);
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onBackspacePressed() {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.onBackspacePressed');
    try {
      return super.onBackspacePressed();
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic handleNotifications(String id, bool increase) {
    final _$actionInfo = _$_SuportStoreBaseActionController.startAction(
        name: '_SuportStoreBase.handleNotifications');
    try {
      return super.handleNotifications(id, increase);
    } finally {
      _$_SuportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
emojisShow: ${emojisShow},
txtcontrol: ${txtcontrol},
text: ${text},
uploadSpin: ${uploadSpin},
downloadSpin: ${downloadSpin},
photo: ${photo},
result: ${result},
fileBytes: ${fileBytes},
fileName: ${fileName},
supportTitle: ${supportTitle},
localPath: ${localPath},
appDir: ${appDir},
bytes: ${bytes},
file: ${file}
    ''';
  }
}
