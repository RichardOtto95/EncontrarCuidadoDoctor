import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'ratings_store.g.dart';

class RatingsStore = _RatingsStoreBase with _$RatingsStore;

abstract class _RatingsStoreBase with Store {
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  @observable
  bool moreReviews = true;
  @observable
  int limit = 5;
  @observable
  int maxDocs = 0;
  @observable
  ObservableList listRatings;

  void reportRating(String ratingId) {
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .collection('ratings')
        .doc(ratingId)
        .get()
        .then((DocumentSnapshot rating) =>
            rating.reference.update({'status': 'REPORTED'}));

    FirebaseFirestore.instance.collection('ratings').doc(ratingId).get().then(
        (DocumentSnapshot rating) =>
            rating.reference.update({'status': 'REPORTED'}));
  }

  void back() async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    if (_user['type'] == 'DOCTOR') {
      _user.reference.update({'new_ratings': 0});
    } else {
      DocumentSnapshot _doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_user['doctor_id'])
          .get();

      _user.reference.update({'new_ratings': 0});

      _doctor.reference.update({'new_ratings': 0});
    }
  }

  void getOpinions({int index, QuerySnapshot querySnapshot}) async {
    print(
        'xxxxxxxxxxxx getOpinions $index ${querySnapshot.docs.isNotEmpty} xxxxxxxxxxxx');
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
  getMoreOpinion() async {
    limit += 5;

    if (limit >= maxDocs) {
      moreReviews = false;
    }
  }

  @action
  String converterDateToString(Timestamp date) {
    return date.toDate().day.toString().padLeft(2, '0') +
        '/' +
        date.toDate().month.toString().padLeft(2, '0') +
        '/' +
        date.toDate().year.toString();
  }
}
