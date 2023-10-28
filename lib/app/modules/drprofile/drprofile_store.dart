import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'drprofile_store.g.dart';

class DrProfileStore = _DrprofileStoreBase with _$DrProfileStore;

abstract class _DrprofileStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  String ratingsAverage = '0.0';
  @observable
  int ratingsLength = 0;
  @observable
  bool moreReviews = true;
  @observable
  int limit = 5;
  @observable
  int maxDocs = 0;
  @observable
  bool postEditor = false;
  @observable
  bool galery = false;
  @observable
  String editPost;
  @observable
  String postText;
  @observable
  String imageString;
  @observable
  File imageFile;
  @observable
  String postId;
  @observable
  bool deleteDialog = false;
  @observable
  ObservableList listRatings;
  @observable
  bool allowed = false;
  @observable
  ObservableMap mapDeletedPost = ObservableMap();

  @action
  setImageString(String str) => imageString = str;
  @action
  setPostId(String id) => postId = id;
  @action
  setDeleteDialog(bool dl) => deleteDialog = dl;
  @action
  showPostEditor(bool ed) => postEditor = ed;
  @action
  setEditPost(String ed) => editPost = ed;
  @action
  showGalery(bool gl) => galery = gl;
  @action
  setPostText(String txt) => postText = txt;
  @action
  setImageFile(File fil) => imageFile = fil;

  @action
  getMoreOpinion() async {
    limit += 5;

    if (limit >= maxDocs) {
      moreReviews = false;
    }
  }

  @action
  postEditing(post) async {
    DocumentSnapshot postSnap =
        await FirebaseFirestore.instance.collection('posts').doc(post).get();

    print('xxxxxxxx editing ${postSnap['dr_id']} ${postSnap.id} xxxxxxx');

    DocumentSnapshot drFeedDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(postSnap['dr_id'])
        .collection('feed')
        .doc(postSnap.id)
        .get();

    if (editPost == 'edited') {
      if (imageFile == null) {
        String text = postText;

        postSnap.reference.update({
          'text': text,
          'edited_at': FieldValue.serverTimestamp(),
        });

        await drFeedDoc.reference.update({
          'text': text,
          'edited_at': FieldValue.serverTimestamp(),
        });

        await feedDispose();
      } else {
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('posts/${postSnap.id}');
        UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUpdate = await taskSnapshot.ref.getDownloadURL();

        String text = postText;

        postSnap.reference.update({
          'text': text,
          'bgr_image': imageUpdate,
          'edited_at': FieldValue.serverTimestamp(),
        });

        await drFeedDoc.reference.update({
          'text': text,
          'bgr_image': imageUpdate,
          'edited_at': FieldValue.serverTimestamp(),
        });

        editPost = null;
        postText = null;
        imageString = null;
        await feedDispose();
      }
    }
  }

  @action
  deletePost(post) async {
    mapDeletedPost[post] = true;

    Timer(Duration(seconds: 3), () async {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post)
          .get()
          .then((value2) async {
        await value2.reference.update({
          'status': 'DELETED',
          'deleted_at': FieldValue.serverTimestamp(),
          'user_id': mainStore.authStore.user.uid,
        });

        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(value2['dr_id'])
            .collection('feed')
            .doc(value2.id)
            .update({
          'status': 'DELETED',
        });
      });

      // mapDeletedPost.remove(post);
    });
  }

  feedDispose() {
    postText = null;
    imageString = null;
    imageFile = null;
    editPost = null;
    postId = null;
  }

  @action
  String converterDateToString(Timestamp date) {
    return date.toDate().day.toString().padLeft(2, '0') +
        '/' +
        date.toDate().month.toString().padLeft(2, '0') +
        '/' +
        date.toDate().year.toString();
  }

  void getOpinions({QuerySnapshot querySnapshot, int index}) async {
    if (querySnapshot.docs.isNotEmpty) {
      ObservableList newList = [].asObservable();
      int _maxDocs = 0;

      querySnapshot.docs.forEach((DocumentSnapshot docRating) {
        if (docRating['status'] != 'INACTIVE') {
          switch (index) {
            case 0:
              _maxDocs += 1;
              if (newList.length <= limit) {
                newList.add(docRating);
              }
              break;

            case 1:
              if (docRating['avaliation'] > 3) {
                _maxDocs += 1;
                if (newList.length <= limit) {
                  newList.add(docRating);
                }
              }
              break;

            case 2:
              if (docRating['avaliation'] == 3) {
                _maxDocs += 1;
                if (newList.length <= limit) {
                  newList.add(docRating);
                }
              }
              break;

            case 3:
              if (docRating['avaliation'] < 3) {
                _maxDocs += 1;
                if (newList.length <= limit) {
                  newList.add(docRating);
                }
              }
              break;

            default:
              break;
          }
        }
      });
      maxDocs = _maxDocs;
      moreReviews = limit < maxDocs;
      listRatings = newList;
    } else {
      listRatings = [].asObservable();
    }
  }

  @action
  getRatings(String doctorId) async {
    ratingsLength = 0;
    QuerySnapshot ratings = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('ratings')
        .get();

    if (ratings.docs.isNotEmpty) {
      double average = 0.0;
      ratings.docs.forEach((rating) {
        if (rating['status'] != 'INACTIVE') {
          ratingsLength += 1;

          average += rating['avaliation'];
        }
      });

      average = average / ratings.docs.length;

      ratingsAverage = average.toStringAsFixed(1);
    }
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

    //   String since;
    //   int now = Timestamp.now().millisecondsSinceEpoch;
    //   int sinceMillis = now - time.millisecondsSinceEpoch;

    //   if (sinceMillis <= 120000) {
    //     since = "agora";
    //   }
    //   if (sinceMillis > 120000 && sinceMillis <= 3600000) {
    //     since = DateFormat("${'mm'} '\min'")
    //         .format(DateTime.fromMillisecondsSinceEpoch(sinceMillis));
    //   }
    //   if (sinceMillis > 3600000 && sinceMillis <= 7200000) {
    //     since = DateFormat("${'hh'} '\hora'")
    //         .format(DateTime.fromMillisecondsSinceEpoch(sinceMillis));
    //   }
    //   if (sinceMillis > 3600000 && sinceMillis <= 86400000) {
    //     since = DateFormat("${'hh'} '\horas'")
    //         .format(DateTime.fromMillisecondsSinceEpoch(sinceMillis));
    //   }
    //   if (sinceMillis > 86400000) {
    //     since = DateFormat('dd MMM', "pt_BR").format(time.toDate());
    //   }
    //   return since;
  }
}
