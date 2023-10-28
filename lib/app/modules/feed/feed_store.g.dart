// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedStore on _FeedStoreBase, Store {
  final _$feedAtom = Atom(name: '_FeedStoreBase.feed');

  @override
  ObservableList<dynamic> get feed {
    _$feedAtom.reportRead();
    return super.feed;
  }

  @override
  set feed(ObservableList<dynamic> value) {
    _$feedAtom.reportWrite(value, super.feed, () {
      super.feed = value;
    });
  }

  final _$circAtom = Atom(name: '_FeedStoreBase.circ');

  @override
  bool get circ {
    _$circAtom.reportRead();
    return super.circ;
  }

  @override
  set circ(bool value) {
    _$circAtom.reportWrite(value, super.circ, () {
      super.circ = value;
    });
  }

  final _$auxAtom = Atom(name: '_FeedStoreBase.aux');

  @override
  int get aux {
    _$auxAtom.reportRead();
    return super.aux;
  }

  @override
  set aux(int value) {
    _$auxAtom.reportWrite(value, super.aux, () {
      super.aux = value;
    });
  }

  final _$postIdAtom = Atom(name: '_FeedStoreBase.postId');

  @override
  String get postId {
    _$postIdAtom.reportRead();
    return super.postId;
  }

  @override
  set postId(String value) {
    _$postIdAtom.reportWrite(value, super.postId, () {
      super.postId = value;
    });
  }

  final _$userDocsAtom = Atom(name: '_FeedStoreBase.userDocs');

  @override
  QuerySnapshot<Object> get userDocs {
    _$userDocsAtom.reportRead();
    return super.userDocs;
  }

  @override
  set userDocs(QuerySnapshot<Object> value) {
    _$userDocsAtom.reportWrite(value, super.userDocs, () {
      super.userDocs = value;
    });
  }

  final _$starAfterAtom = Atom(name: '_FeedStoreBase.starAfter');

  @override
  DocumentSnapshot<Object> get starAfter {
    _$starAfterAtom.reportRead();
    return super.starAfter;
  }

  @override
  set starAfter(DocumentSnapshot<Object> value) {
    _$starAfterAtom.reportWrite(value, super.starAfter, () {
      super.starAfter = value;
    });
  }

  final _$deleteDialogAtom = Atom(name: '_FeedStoreBase.deleteDialog');

  @override
  bool get deleteDialog {
    _$deleteDialogAtom.reportRead();
    return super.deleteDialog;
  }

  @override
  set deleteDialog(bool value) {
    _$deleteDialogAtom.reportWrite(value, super.deleteDialog, () {
      super.deleteDialog = value;
    });
  }

  final _$editPostAtom = Atom(name: '_FeedStoreBase.editPost');

  @override
  String get editPost {
    _$editPostAtom.reportRead();
    return super.editPost;
  }

  @override
  set editPost(String value) {
    _$editPostAtom.reportWrite(value, super.editPost, () {
      super.editPost = value;
    });
  }

  final _$imageStringAtom = Atom(name: '_FeedStoreBase.imageString');

  @override
  String get imageString {
    _$imageStringAtom.reportRead();
    return super.imageString;
  }

  @override
  set imageString(String value) {
    _$imageStringAtom.reportWrite(value, super.imageString, () {
      super.imageString = value;
    });
  }

  final _$postTextAtom = Atom(name: '_FeedStoreBase.postText');

  @override
  String get postText {
    _$postTextAtom.reportRead();
    return super.postText;
  }

  @override
  set postText(String value) {
    _$postTextAtom.reportWrite(value, super.postText, () {
      super.postText = value;
    });
  }

  final _$imageFileAtom = Atom(name: '_FeedStoreBase.imageFile');

  @override
  File get imageFile {
    _$imageFileAtom.reportRead();
    return super.imageFile;
  }

  @override
  set imageFile(File value) {
    _$imageFileAtom.reportWrite(value, super.imageFile, () {
      super.imageFile = value;
    });
  }

  final _$newPostAtom = Atom(name: '_FeedStoreBase.newPost');

  @override
  bool get newPost {
    _$newPostAtom.reportRead();
    return super.newPost;
  }

  @override
  set newPost(bool value) {
    _$newPostAtom.reportWrite(value, super.newPost, () {
      super.newPost = value;
    });
  }

  final _$galeryAtom = Atom(name: '_FeedStoreBase.galery');

  @override
  bool get galery {
    _$galeryAtom.reportRead();
    return super.galery;
  }

  @override
  set galery(bool value) {
    _$galeryAtom.reportWrite(value, super.galery, () {
      super.galery = value;
    });
  }

  final _$isEmptyAtom = Atom(name: '_FeedStoreBase.isEmpty');

  @override
  bool get isEmpty {
    _$isEmptyAtom.reportRead();
    return super.isEmpty;
  }

  @override
  set isEmpty(bool value) {
    _$isEmptyAtom.reportWrite(value, super.isEmpty, () {
      super.isEmpty = value;
    });
  }

  final _$showMenuAtom = Atom(name: '_FeedStoreBase.showMenu');

  @override
  bool get showMenu {
    _$showMenuAtom.reportRead();
    return super.showMenu;
  }

  @override
  set showMenu(bool value) {
    _$showMenuAtom.reportWrite(value, super.showMenu, () {
      super.showMenu = value;
    });
  }

  final _$loadCircularAtom = Atom(name: '_FeedStoreBase.loadCircular');

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

  final _$assetsAtom = Atom(name: '_FeedStoreBase.assets');

  @override
  List<AssetEntity> get assets {
    _$assetsAtom.reportRead();
    return super.assets;
  }

  @override
  set assets(List<AssetEntity> value) {
    _$assetsAtom.reportWrite(value, super.assets, () {
      super.assets = value;
    });
  }

  final _$allowedAtom = Atom(name: '_FeedStoreBase.allowed');

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

  final _$addPostsAtom = Atom(name: '_FeedStoreBase.addPosts');

  @override
  bool get addPosts {
    _$addPostsAtom.reportRead();
    return super.addPosts;
  }

  @override
  set addPosts(bool value) {
    _$addPostsAtom.reportWrite(value, super.addPosts, () {
      super.addPosts = value;
    });
  }

  final _$feedListAtom = Atom(name: '_FeedStoreBase.feedList');

  @override
  ObservableList<dynamic> get feedList {
    _$feedListAtom.reportRead();
    return super.feedList;
  }

  @override
  set feedList(ObservableList<dynamic> value) {
    _$feedListAtom.reportWrite(value, super.feedList, () {
      super.feedList = value;
    });
  }

  final _$feedListCompleteAtom = Atom(name: '_FeedStoreBase.feedListComplete');

  @override
  List<dynamic> get feedListComplete {
    _$feedListCompleteAtom.reportRead();
    return super.feedListComplete;
  }

  @override
  set feedListComplete(List<dynamic> value) {
    _$feedListCompleteAtom.reportWrite(value, super.feedListComplete, () {
      super.feedListComplete = value;
    });
  }

  final _$feedMapDeleteAtom = Atom(name: '_FeedStoreBase.feedMapDelete');

  @override
  ObservableMap<dynamic, dynamic> get feedMapDelete {
    _$feedMapDeleteAtom.reportRead();
    return super.feedMapDelete;
  }

  @override
  set feedMapDelete(ObservableMap<dynamic, dynamic> value) {
    _$feedMapDeleteAtom.reportWrite(value, super.feedMapDelete, () {
      super.feedMapDelete = value;
    });
  }

  final _$hasNextAtom = Atom(name: '_FeedStoreBase.hasNext');

  @override
  bool get hasNext {
    _$hasNextAtom.reportRead();
    return super.hasNext;
  }

  @override
  set hasNext(bool value) {
    _$hasNextAtom.reportWrite(value, super.hasNext, () {
      super.hasNext = value;
    });
  }

  final _$feedLimitAtom = Atom(name: '_FeedStoreBase.feedLimit');

  @override
  int get feedLimit {
    _$feedLimitAtom.reportRead();
    return super.feedLimit;
  }

  @override
  set feedLimit(int value) {
    _$feedLimitAtom.reportWrite(value, super.feedLimit, () {
      super.feedLimit = value;
    });
  }

  final _$maxDocsAtom = Atom(name: '_FeedStoreBase.maxDocs');

  @override
  int get maxDocs {
    _$maxDocsAtom.reportRead();
    return super.maxDocs;
  }

  @override
  set maxDocs(int value) {
    _$maxDocsAtom.reportWrite(value, super.maxDocs, () {
      super.maxDocs = value;
    });
  }

  final _$initialValueAtom = Atom(name: '_FeedStoreBase.initialValue');

  @override
  int get initialValue {
    _$initialValueAtom.reportRead();
    return super.initialValue;
  }

  @override
  set initialValue(int value) {
    _$initialValueAtom.reportWrite(value, super.initialValue, () {
      super.initialValue = value;
    });
  }

  final _$newNotificationsAtom = Atom(name: '_FeedStoreBase.newNotifications');

  @override
  int get newNotifications {
    _$newNotificationsAtom.reportRead();
    return super.newNotifications;
  }

  @override
  set newNotifications(int value) {
    _$newNotificationsAtom.reportWrite(value, super.newNotifications, () {
      super.newNotifications = value;
    });
  }

  final _$newRatingsAtom = Atom(name: '_FeedStoreBase.newRatings');

  @override
  int get newRatings {
    _$newRatingsAtom.reportRead();
    return super.newRatings;
  }

  @override
  set newRatings(int value) {
    _$newRatingsAtom.reportWrite(value, super.newRatings, () {
      super.newRatings = value;
    });
  }

  final _$supportNotificationsAtom =
      Atom(name: '_FeedStoreBase.supportNotifications');

  @override
  int get supportNotifications {
    _$supportNotificationsAtom.reportRead();
    return super.supportNotifications;
  }

  @override
  set supportNotifications(int value) {
    _$supportNotificationsAtom.reportWrite(value, super.supportNotifications,
        () {
      super.supportNotifications = value;
    });
  }

  final _$allNotificationsAtom = Atom(name: '_FeedStoreBase.allNotifications');

  @override
  int get allNotifications {
    _$allNotificationsAtom.reportRead();
    return super.allNotifications;
  }

  @override
  set allNotifications(int value) {
    _$allNotificationsAtom.reportWrite(value, super.allNotifications, () {
      super.allNotifications = value;
    });
  }

  final _$feedIdReportAtom = Atom(name: '_FeedStoreBase.feedIdReport');

  @override
  String get feedIdReport {
    _$feedIdReportAtom.reportRead();
    return super.feedIdReport;
  }

  @override
  set feedIdReport(String value) {
    _$feedIdReportAtom.reportWrite(value, super.feedIdReport, () {
      super.feedIdReport = value;
    });
  }

  final _$viewDrProfileAsyncAction =
      AsyncAction('_FeedStoreBase.viewDrProfile');

  @override
  Future viewDrProfile(BuildContext context) {
    return _$viewDrProfileAsyncAction.run(() => super.viewDrProfile(context));
  }

  final _$toPostAsyncAction = AsyncAction('_FeedStoreBase.toPost');

  @override
  Future toPost() {
    return _$toPostAsyncAction.run(() => super.toPost());
  }

  final _$postEditingAsyncAction = AsyncAction('_FeedStoreBase.postEditing');

  @override
  Future postEditing(dynamic postId) {
    return _$postEditingAsyncAction.run(() => super.postEditing(postId));
  }

  final _$_FeedStoreBaseActionController =
      ActionController(name: '_FeedStoreBase');

  @override
  dynamic showGalery(bool gl) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.showGalery');
    try {
      return super.showGalery(gl);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPostId(String id) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setPostId');
    try {
      return super.setPostId(id);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNewPost(bool nw) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setNewPost');
    try {
      return super.setNewPost(nw);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDeleteDialog(bool dl) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setDeleteDialog');
    try {
      return super.setDeleteDialog(dl);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditPost(String ed) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setEditPost');
    try {
      return super.setEditPost(ed);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPostText(String txt) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setPostText');
    try {
      return super.setPostText(txt);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setImageFile(File fil) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setImageFile');
    try {
      return super.setImageFile(fil);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setImageString(String str) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setImageString');
    try {
      return super.setImageString(str);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getTime(Timestamp time) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.getTime');
    try {
      return super.getTime(time);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feed: ${feed},
circ: ${circ},
aux: ${aux},
postId: ${postId},
userDocs: ${userDocs},
starAfter: ${starAfter},
deleteDialog: ${deleteDialog},
editPost: ${editPost},
imageString: ${imageString},
postText: ${postText},
imageFile: ${imageFile},
newPost: ${newPost},
galery: ${galery},
isEmpty: ${isEmpty},
showMenu: ${showMenu},
loadCircular: ${loadCircular},
assets: ${assets},
allowed: ${allowed},
addPosts: ${addPosts},
feedList: ${feedList},
feedListComplete: ${feedListComplete},
feedMapDelete: ${feedMapDelete},
hasNext: ${hasNext},
feedLimit: ${feedLimit},
maxDocs: ${maxDocs},
initialValue: ${initialValue},
newNotifications: ${newNotifications},
newRatings: ${newRatings},
supportNotifications: ${supportNotifications},
allNotifications: ${allNotifications},
feedIdReport: ${feedIdReport}
    ''';
  }
}
