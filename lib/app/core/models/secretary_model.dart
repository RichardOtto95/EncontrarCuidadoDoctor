import 'package:cloud_firestore/cloud_firestore.dart';

class SecretaryModel {
  String id;
  String avatar;
  String phone;
  String username;
  String fullname;
  Timestamp birthday;
  String cpf;
  String gender;
  String email;
  bool notificationDisabled;
  Timestamp createdAt;
  String type;
  String doctorId;
  num newRatings;
  String landline;
  String invitationToPosition;

  SecretaryModel({
    this.id,
    this.avatar,
    this.phone,
    this.username,
    this.fullname,
    this.birthday,
    this.cpf,
    this.gender,
    this.email,
    this.notificationDisabled,
    this.createdAt,
    this.type,
    this.doctorId,
    this.newRatings,
    this.landline,
    this.invitationToPosition,
  });

  factory SecretaryModel.fromDocument(DocumentSnapshot doc) {
    return SecretaryModel(
      id: doc['id'],
      avatar: doc['avatar'],
      phone: doc['phone'],
      username: doc['username'],
      fullname: doc['fullname'],
      birthday: doc['birthday'],
      cpf: doc['cpf'],
      gender: doc['gender'],
      email: doc['email'],
      notificationDisabled: doc['notification_disabled'],
      createdAt: doc['created_at'],
      type: doc['type'],
      doctorId: doc['doctor_id'],
      newRatings: doc['new_ratings'],
      landline: doc['landline'],
      invitationToPosition: doc['invitation_to_position'],
    );
  }
  Map<String, dynamic> convertUser(SecretaryModel doctor) {
    Map<String, dynamic> map = {};
    map['id'] = doctor.id;
    map['avatar'] = doctor.avatar;
    map['phone'] = doctor.phone;
    map['username'] = doctor.username;
    map['fullname'] = doctor.fullname;
    map['birthday'] = doctor.birthday;
    map['cpf'] = doctor.cpf;
    map['gender'] = doctor.gender;
    map['email'] = doctor.email;
    map['notification_disabled'] = doctor.notificationDisabled;
    map['created_at'] = doctor.createdAt;
    map['type'] = doctor.type;
    map['doctor_id'] = doctor.doctorId;
    map['new_ratings'] = doctor.newRatings;
    map['landline'] = doctor.landline;
    map['invitation_to_position'] = doctor.invitationToPosition;
    return map;
  }

  Map<String, dynamic> toJson(SecretaryModel doctor) => {
        'id': doctor.id,
        'avatar': doctor.avatar,
        'phone': doctor.phone,
        'username': doctor.username,
        'fullname': doctor.fullname,
        'birthday': doctor.birthday,
        'cpf': doctor.cpf,
        'gender': doctor.gender,
        'email': doctor.email,
        'notification_disabled': doctor.notificationDisabled,
        'created_at': FieldValue.serverTimestamp(),
        'type': doctor.type,
        'doctor_id': doctor.doctorId,
        'new_ratings': doctor.newRatings,
        'landline': doctor.landline,
        'invitation_to_position': doctor.invitationToPosition,
      };
}
