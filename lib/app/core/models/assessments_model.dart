import 'package:cloud_firestore/cloud_firestore.dart';

class RatingsModel {
  String id;
  String patientId;
  String username;
  double avaliation;
  String text;
  String photo;
  String status;
  Timestamp createdAt;

  RatingsModel({
    this.id,
    this.username,
    this.createdAt,
    this.avaliation,
    this.photo,
    this.text,
    this.patientId,
    this.status,
  });

  factory RatingsModel.fromDocument(DocumentSnapshot doc) {
    return RatingsModel(
      id: doc['id'],
      username: doc['username'],
      createdAt: doc['created_at'],
      avaliation: doc['avaliation'],
      photo: doc['photo'],
      text: doc['text'],
      patientId: doc['patient_id'],
      status: doc['status'],
    );
  }
  Map<String, dynamic> convertRating(RatingsModel rating) {
    Map<String, dynamic> map = {};
    map['id'] = rating.id;
    map['username'] = rating.username;
    map['created_at'] = rating.createdAt;
    map['avaliation'] = rating.avaliation;
    map['photo'] = rating.photo;
    map['text'] = rating.text;
    map['patient_id'] = rating.patientId;
    map['status'] = rating.status;

    return map;
  }

  Map<String, dynamic> toJson(RatingsModel rating) => {
        'id': rating.id,
        'username': rating.username,
        'created_at': FieldValue.serverTimestamp(),
        'avaliation': rating.avaliation,
        'photo': rating.photo,
        'text': rating.text,
        'patient_id': rating.patientId,
        'status': rating.status,
      };
}
