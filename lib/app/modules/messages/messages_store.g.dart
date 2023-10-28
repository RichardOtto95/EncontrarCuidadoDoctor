// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessagesStore on _MessagesStoreBase, Store {
  final _$mainStoreAtom = Atom(name: '_MessagesStoreBase.mainStore');

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

  final _$userChatsAtom = Atom(name: '_MessagesStoreBase.userChats');

  @override
  ObservableList<dynamic> get userChats {
    _$userChatsAtom.reportRead();
    return super.userChats;
  }

  @override
  set userChats(ObservableList<dynamic> value) {
    _$userChatsAtom.reportWrite(value, super.userChats, () {
      super.userChats = value;
    });
  }

  final _$patientAtom = Atom(name: '_MessagesStoreBase.patient');

  @override
  Map<dynamic, dynamic> get patient {
    _$patientAtom.reportRead();
    return super.patient;
  }

  @override
  set patient(Map<dynamic, dynamic> value) {
    _$patientAtom.reportWrite(value, super.patient, () {
      super.patient = value;
    });
  }

  final _$chatIdAtom = Atom(name: '_MessagesStoreBase.chatId');

  @override
  String get chatId {
    _$chatIdAtom.reportRead();
    return super.chatId;
  }

  @override
  set chatId(String value) {
    _$chatIdAtom.reportWrite(value, super.chatId, () {
      super.chatId = value;
    });
  }

  final _$chatAtom = Atom(name: '_MessagesStoreBase.chat');

  @override
  ObservableList<dynamic> get chat {
    _$chatAtom.reportRead();
    return super.chat;
  }

  @override
  set chat(ObservableList<dynamic> value) {
    _$chatAtom.reportWrite(value, super.chat, () {
      super.chat = value;
    });
  }

  final _$srchAtom = Atom(name: '_MessagesStoreBase.srch');

  @override
  TextEditingController get srch {
    _$srchAtom.reportRead();
    return super.srch;
  }

  @override
  set srch(TextEditingController value) {
    _$srchAtom.reportWrite(value, super.srch, () {
      super.srch = value;
    });
  }

  final _$chatScrollAtom = Atom(name: '_MessagesStoreBase.chatScroll');

  @override
  ItemScrollController get chatScroll {
    _$chatScrollAtom.reportRead();
    return super.chatScroll;
  }

  @override
  set chatScroll(ItemScrollController value) {
    _$chatScrollAtom.reportWrite(value, super.chatScroll, () {
      super.chatScroll = value;
    });
  }

  final _$textAtom = Atom(name: '_MessagesStoreBase.text');

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

  final _$fileAtom = Atom(name: '_MessagesStoreBase.file');

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

  final _$chatTitleAtom = Atom(name: '_MessagesStoreBase.chatTitle');

  @override
  String get chatTitle {
    _$chatTitleAtom.reportRead();
    return super.chatTitle;
  }

  @override
  set chatTitle(String value) {
    _$chatTitleAtom.reportWrite(value, super.chatTitle, () {
      super.chatTitle = value;
    });
  }

  final _$uploadSpinAtom = Atom(name: '_MessagesStoreBase.uploadSpin');

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

  final _$photoAtom = Atom(name: '_MessagesStoreBase.photo');

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

  final _$emptyChatAtom = Atom(name: '_MessagesStoreBase.emptyChat');

  @override
  bool get emptyChat {
    _$emptyChatAtom.reportRead();
    return super.emptyChat;
  }

  @override
  set emptyChat(bool value) {
    _$emptyChatAtom.reportWrite(value, super.emptyChat, () {
      super.emptyChat = value;
    });
  }

  final _$appDirAtom = Atom(name: '_MessagesStoreBase.appDir');

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

  final _$localPathAtom = Atom(name: '_MessagesStoreBase.localPath');

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

  final _$bytesAtom = Atom(name: '_MessagesStoreBase.bytes');

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

  final _$fileBytesAtom = Atom(name: '_MessagesStoreBase.fileBytes');

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

  final _$fileNameAtom = Atom(name: '_MessagesStoreBase.fileName');

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

  final _$resultAtom = Atom(name: '_MessagesStoreBase.result');

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

  final _$chatDocAtom = Atom(name: '_MessagesStoreBase.chatDoc');

  @override
  DocumentSnapshot<Object> get chatDoc {
    _$chatDocAtom.reportRead();
    return super.chatDoc;
  }

  @override
  set chatDoc(DocumentSnapshot<Object> value) {
    _$chatDocAtom.reportWrite(value, super.chatDoc, () {
      super.chatDoc = value;
    });
  }

  final _$messagesDocsAtom = Atom(name: '_MessagesStoreBase.messagesDocs');

  @override
  QuerySnapshot<Object> get messagesDocs {
    _$messagesDocsAtom.reportRead();
    return super.messagesDocs;
  }

  @override
  set messagesDocs(QuerySnapshot<Object> value) {
    _$messagesDocsAtom.reportWrite(value, super.messagesDocs, () {
      super.messagesDocs = value;
    });
  }

  final _$searchResultAtom = Atom(name: '_MessagesStoreBase.searchResult');

  @override
  ObservableList<dynamic> get searchResult {
    _$searchResultAtom.reportRead();
    return super.searchResult;
  }

  @override
  set searchResult(ObservableList<dynamic> value) {
    _$searchResultAtom.reportWrite(value, super.searchResult, () {
      super.searchResult = value;
    });
  }

  final _$scrollJumpAtom = Atom(name: '_MessagesStoreBase.scrollJump');

  @override
  bool get scrollJump {
    _$scrollJumpAtom.reportRead();
    return super.scrollJump;
  }

  @override
  set scrollJump(bool value) {
    _$scrollJumpAtom.reportWrite(value, super.scrollJump, () {
      super.scrollJump = value;
    });
  }

  final _$searchedQueryAtom = Atom(name: '_MessagesStoreBase.searchedQuery');

  @override
  QuerySnapshot<Object> get searchedQuery {
    _$searchedQueryAtom.reportRead();
    return super.searchedQuery;
  }

  @override
  set searchedQuery(QuerySnapshot<Object> value) {
    _$searchedQueryAtom.reportWrite(value, super.searchedQuery, () {
      super.searchedQuery = value;
    });
  }

  final _$searchedTextAtom = Atom(name: '_MessagesStoreBase.searchedText');

  @override
  String get searchedText {
    _$searchedTextAtom.reportRead();
    return super.searchedText;
  }

  @override
  set searchedText(String value) {
    _$searchedTextAtom.reportWrite(value, super.searchedText, () {
      super.searchedText = value;
    });
  }

  final _$searchPosAtom = Atom(name: '_MessagesStoreBase.searchPos');

  @override
  int get searchPos {
    _$searchPosAtom.reportRead();
    return super.searchPos;
  }

  @override
  set searchPos(int value) {
    _$searchPosAtom.reportWrite(value, super.searchPos, () {
      super.searchPos = value;
    });
  }

  final _$userAvatarAtom = Atom(name: '_MessagesStoreBase.userAvatar');

  @override
  String get userAvatar {
    _$userAvatarAtom.reportRead();
    return super.userAvatar;
  }

  @override
  set userAvatar(String value) {
    _$userAvatarAtom.reportWrite(value, super.userAvatar, () {
      super.userAvatar = value;
    });
  }

  final _$patAvatarAtom = Atom(name: '_MessagesStoreBase.patAvatar');

  @override
  String get patAvatar {
    _$patAvatarAtom.reportRead();
    return super.patAvatar;
  }

  @override
  set patAvatar(String value) {
    _$patAvatarAtom.reportWrite(value, super.patAvatar, () {
      super.patAvatar = value;
    });
  }

  final _$allowedAtom = Atom(name: '_MessagesStoreBase.allowed');

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

  final _$searchEmptyAtom = Atom(name: '_MessagesStoreBase.searchEmpty');

  @override
  bool get searchEmpty {
    _$searchEmptyAtom.reportRead();
    return super.searchEmpty;
  }

  @override
  set searchEmpty(bool value) {
    _$searchEmptyAtom.reportWrite(value, super.searchEmpty, () {
      super.searchEmpty = value;
    });
  }

  final _$chatStreamAtom = Atom(name: '_MessagesStoreBase.chatStream');

  @override
  Stream<QuerySnapshot<Object>> get chatStream {
    _$chatStreamAtom.reportRead();
    return super.chatStream;
  }

  @override
  set chatStream(Stream<QuerySnapshot<Object>> value) {
    _$chatStreamAtom.reportWrite(value, super.chatStream, () {
      super.chatStream = value;
    });
  }

  final _$emojisShowMAtom = Atom(name: '_MessagesStoreBase.emojisShowM');

  @override
  bool get emojisShowM {
    _$emojisShowMAtom.reportRead();
    return super.emojisShowM;
  }

  @override
  set emojisShowM(bool value) {
    _$emojisShowMAtom.reportWrite(value, super.emojisShowM, () {
      super.emojisShowM = value;
    });
  }

  final _$downloadFilesAsyncAction =
      AsyncAction('_MessagesStoreBase.downloadFiles');

  @override
  Future downloadFiles(String url, String name, String chatId, String message) {
    return _$downloadFilesAsyncAction
        .run(() => super.downloadFiles(url, name, chatId, message));
  }

  final _$uploadFilesAsyncAction =
      AsyncAction('_MessagesStoreBase.uploadFiles');

  @override
  Future uploadFiles() {
    return _$uploadFilesAsyncAction.run(() => super.uploadFiles());
  }

  final _$getMessagesAsyncAction =
      AsyncAction('_MessagesStoreBase.getMessages');

  @override
  Future getMessages(String id, dynamic name) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(id, name));
  }

  final _$pickImageAsyncAction = AsyncAction('_MessagesStoreBase.pickImage');

  @override
  Future pickImage(String chtId) {
    return _$pickImageAsyncAction.run(() => super.pickImage(chtId));
  }

  final _$_MessagesStoreBaseActionController =
      ActionController(name: '_MessagesStoreBase');

  @override
  dynamic setPAvatar(String a) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setPAvatar');
    try {
      return super.setPAvatar(a);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPos(int p) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setPos');
    try {
      return super.setPos(p);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setJump(bool j) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setJump');
    try {
      return super.setJump(j);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setText(String tx) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setText');
    try {
      return super.setText(tx);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmptyChat(bool ec) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setEmptyChat');
    try {
      return super.setEmptyChat(ec);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setChatId(String id) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setChatId');
    try {
      return super.setChatId(id);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUploadSpin(bool sh) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.setUploadSpin');
    try {
      return super.setUploadSpin(sh);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic handleNotifications(String chatId, bool increase) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.handleNotifications');
    try {
      return super.handleNotifications(chatId, increase);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getChats() {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.getChats');
    try {
      return super.getChats();
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic chatsDispose() {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.chatsDispose');
    try {
      return super.chatsDispose();
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String messageTimer(Timestamp timer) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.messageTimer');
    try {
      return super.messageTimer(timer);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mainStore: ${mainStore},
userChats: ${userChats},
patient: ${patient},
chatId: ${chatId},
chat: ${chat},
srch: ${srch},
chatScroll: ${chatScroll},
text: ${text},
file: ${file},
chatTitle: ${chatTitle},
uploadSpin: ${uploadSpin},
photo: ${photo},
emptyChat: ${emptyChat},
appDir: ${appDir},
localPath: ${localPath},
bytes: ${bytes},
fileBytes: ${fileBytes},
fileName: ${fileName},
result: ${result},
chatDoc: ${chatDoc},
messagesDocs: ${messagesDocs},
searchResult: ${searchResult},
scrollJump: ${scrollJump},
searchedQuery: ${searchedQuery},
searchedText: ${searchedText},
searchPos: ${searchPos},
userAvatar: ${userAvatar},
patAvatar: ${patAvatar},
allowed: ${allowed},
searchEmpty: ${searchEmpty},
chatStream: ${chatStream},
emojisShowM: ${emojisShowM}
    ''';
  }
}
