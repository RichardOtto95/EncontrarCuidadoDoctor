import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:photo_manager/photo_manager.dart';
part 'feed_store.g.dart';

class FeedStore = _FeedStoreBase with _$FeedStore;

abstract class _FeedStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  ObservableList feed = [].asObservable();
  @observable
  bool circ = false;
  @observable
  int aux;
  @observable
  String postId;
  @observable
  QuerySnapshot userDocs;
  @observable
  DocumentSnapshot starAfter;
  @observable
  bool deleteDialog = false;
  @observable
  String editPost;
  @observable
  String imageString;
  @observable
  String postText;
  @observable
  File imageFile;
  @observable
  bool newPost = false;
  @observable
  bool galery = false;
  @observable
  bool isEmpty = false;
  @observable
  bool showMenu = false, loadCircular = false;
  @observable
  List<AssetEntity> assets = [];
  @observable
  bool allowed = false, addPosts = false;
  ////////////////////////////////////////////+
  @observable
  ObservableList feedList = [].asObservable();
  @observable
  List feedListComplete = [];
  @observable
  ObservableMap feedMapDelete = ObservableMap();
  @observable
  bool hasNext = false;
  @observable
  int feedLimit = 10, maxDocs = 0, initialValue = 0;
  @observable
  int newNotifications = 0,
      newRatings = 0,
      supportNotifications = 0,
      allNotifications = 0;
  @observable
  String feedIdReport;

  @action
  showGalery(bool gl) => galery = gl;
  @action
  setPostId(String id) => postId = id;
  @action
  setNewPost(bool nw) => newPost = nw;
  @action
  setDeleteDialog(bool dl) => deleteDialog = dl;
  @action
  setEditPost(String ed) => editPost = ed;
  @action
  setPostText(String txt) => postText = txt;
  @action
  setImageFile(File fil) => imageFile = fil;
  @action
  setImageString(String str) => imageString = str;

  int getTotalNotifications() {
    return newNotifications + newRatings + supportNotifications;
  }

  @action
  viewDrProfile(BuildContext context) async {
    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();

    DoctorModel doctorModel = DoctorModel.fromDocument(doctor);

    Modular.to.pushNamed('/feed/dr-profile', arguments: doctorModel);
  }

  @action
  String getTime(Timestamp time) {
    String since;

    if (time != null) {
      DateTime dateTimeNow = DateTime.now();
      DateTime dateTimePost = time.toDate();

      int differenceDays = dateTimeNow.difference(dateTimePost).inDays;
      int differenceHours = dateTimeNow.difference(dateTimePost).inHours;
      int differenceMinutes = dateTimeNow.difference(dateTimePost).inMinutes;

      if (differenceDays > 0) {
        if (differenceDays == 1) {
          since = 'ontem';
        } else {
          since = dateTimePost.day.toString().padLeft(2, '0') +
              '/' +
              dateTimePost.month.toString().padLeft(2, '0');
        }
      } else if (differenceHours > 0) {
        if (differenceHours == 1) {
          since = '1 hora';
        } else {
          since = '$differenceHours horas';
        }
      } else if (differenceMinutes > 4) {
        since = '$differenceMinutes minutos';
      } else {
        since = 'agora';
      }
    } else {
      since = 'agora';
    }
    return since;
  }

  @action
  toPost() async {
    String speciality = 'Médico';

    DocumentSnapshot drDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();

    if (drDoc.get('speciality_name') != null) {
      speciality = drDoc.get('speciality_name');
    }

    addPosts = false;

    DocumentReference drPostDoc = await drDoc.reference.collection('feed').add({
      'dr_avatar': drDoc.get('avatar'),
      'dr_id': drDoc.get('id'),
      'dr_name': drDoc.get('username'),
      'dr_speciality': speciality,
      'text': postText,
      'like_count': 0,
      'status': null,
      'created_at': FieldValue.serverTimestamp(),
      'city': drDoc['city'],
      'liked': false,
      'state': drDoc['state'],
    });

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts/${drPostDoc.id}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    imageString = await taskSnapshot.ref.getDownloadURL();

    await drPostDoc.update(
        {'id': drPostDoc.id, 'bgr_image': imageString, 'status': 'VISIBLE'});

    await FirebaseFirestore.instance.collection('posts').doc(drPostDoc.id).set({
      'dr_avatar': drDoc.get('avatar'),
      'dr_id': drDoc.get('id'),
      'dr_name': drDoc.get('username'),
      'dr_speciality': speciality,
      'bgr_image': imageString,
      'text': postText,
      'like_count': 0,
      'status': 'VISIBLE',
      'created_at': FieldValue.serverTimestamp(),
      'id': drPostDoc.id,
      'city': drDoc['city'],
      'state': drDoc['state'],
    });

    postText = null;
    imageString = null;
    imageFile = null;
  }

  @action
  postEditing(postId) async {
    print('xxxxxxxxxxx postEditing xxxxxxxxxxx');
    String text = postText;

    DocumentSnapshot postDoc =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();

    DocumentSnapshot drFeedDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(postDoc['dr_id'])
        .collection('feed')
        .doc(postDoc.id)
        .get();

    if (imageFile == null) {
      postDoc.reference.update({
        'text': text,
        'edited_at': FieldValue.serverTimestamp(),
      });
      await drFeedDoc.reference.update({
        'text': text,
        'edited_at': FieldValue.serverTimestamp(),
      });
    } else {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('posts/${postDoc.id}');

      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUpdate = await taskSnapshot.ref.getDownloadURL();

      postDoc.reference.update({
        'text': text,
        'bgr_image': imageUpdate,
        'edited_at': FieldValue.serverTimestamp(),
      });

      await drFeedDoc.reference.update({
        'text': text,
        'bgr_image': imageUpdate,
        'edited_at': FieldValue.serverTimestamp(),
      });
    }
    editPost = null;
    postText = null;
    imageFile = null;
    imageString = null;
    addPosts = false;
    getHasNext();
  }

  void deletePost(String postId) async {
    DocumentSnapshot postDoc =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();

    postDoc.reference.update({
      'status': 'DELETED',
      'deleted_at': FieldValue.serverTimestamp(),
      'user_id': mainStore.authStore.user.uid,
    });

    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(postDoc['dr_id'])
        .collection('feed')
        .doc(postId)
        .update({
      'status': 'DELETED',
    });
  }

  void deleting(String feedId) {
    Timer(Duration(seconds: 3), () {
      for (var i = 0; i < feedList.length; i++) {
        var feed = feedList[i];

        if (feed['id'] == feedId) {
          feedList.removeAt(i);
          break;
        }
      }

      deletePost(feedId);
      feedMapDelete.remove(feedId);
    });

    feedMapDelete[feedId] = true;
  }

  void getHasNext() async {
    QuerySnapshot feedsQuery = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .collection('feed')
        .where('status', isEqualTo: 'VISIBLE')
        .get();

    maxDocs = feedsQuery.docs.length;

    hasNext = maxDocs > feedLimit;
  }

  void clearFeed() {
    addPosts = false;
    feedList.clear();
    feedMapDelete.clear();
  }

  void getLimit() {
    print('xxxxxxxxxx getLimit xxxxxxxxxxxxx');
    addPosts = true;
    if (feedListComplete.isNotEmpty) {
      for (var i = 0; i < feedLimit; i++) {
        if (i < feedListComplete.length) {
          DocumentSnapshot feedDoc = feedListComplete[i];

          if (!feedMapDelete.containsKey(feedDoc['id'])) {
            feedList.add(feedDoc);
            feedMapDelete.putIfAbsent(feedDoc['id'], () => false);
          }
        }
      }
    }
  }

  void getFeed(QuerySnapshot feedQuery) {
    print(
        'xxxxxxxxxxx getFeed ${feedQuery.docs.length} $addPosts xxxxxxxxxxxxx');
    feedListComplete = feedQuery.docs.toList();

    if (!addPosts || feedListComplete.length < 4) {
      clearFeed();
      getLimit();
    }
  }

  fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;

      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0,
        end: 1000000,
      );

      assets = recentAssets;
    } else {
      assets = [];
    }
  }
}
