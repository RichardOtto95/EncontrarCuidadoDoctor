import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String id;
  String avatar;
  Timestamp createdAt;
  String email;
  String fullname;
  String phone;
  String username;
  Timestamp birthday;
  String gender;
  String cep;
  String cpf;
  String address;
  String numberAddress;
  String complementAddress;
  String neighborhood;
  String city;
  String state;
  String status;
  String type;
  String country;
  bool notificationDisabled;
  String responsibleId;
  bool connected;
  List addressKeys;

  PatientModel(
      {this.state,
      this.country,
      this.connected,
      this.type,
      this.responsibleId,
      this.id,
      this.avatar,
      this.createdAt,
      this.email,
      this.fullname,
      this.phone,
      this.username,
      this.birthday,
      this.gender,
      this.cep,
      this.address,
      this.numberAddress,
      this.complementAddress,
      this.neighborhood,
      this.city,
      this.status,
      this.notificationDisabled,
      this.cpf,
      this.addressKeys});

  factory PatientModel.fromDocument(DocumentSnapshot doc) {
    return PatientModel(
      responsibleId: doc['responsible_id'],
      type: doc['type'],
      cpf: doc['cpf'],
      id: doc['id'],
      avatar: doc['avatar'],
      createdAt: doc['created_at'],
      email: doc['email'],
      fullname: doc['fullname'],
      phone: doc['phone'],
      username: doc['username'],
      birthday: doc['birthday'],
      gender: doc['gender'],
      cep: doc['cep'],
      address: doc['address'],
      numberAddress: doc['number_address'],
      complementAddress: doc['complement_address'],
      neighborhood: doc['neighborhood'],
      city: doc['city'],
      status: doc['state'],
      notificationDisabled: doc['notification_disabled'],
      addressKeys: doc['address_keys'],
      connected: doc['connected'],
      country: doc['country'],
      state: doc['state'],
    );
  }

  Map<String, dynamic> convertUser(PatientModel patient) {
    Map<String, dynamic> map = {};
    map['cpf'] = patient.cpf;
    map['notification_disabled'] = patient.notificationDisabled;
    map['complement_address'] = patient.complementAddress;
    map['responsible_id'] = patient.responsibleId;
    map['number_address'] = patient.numberAddress;
    map['neighborhood'] = patient.neighborhood;
    map['address_keys'] = patient.addressKeys;
    map['connected'] = patient.connected;
    map['created_at'] = patient.createdAt;
    map['username'] = patient.username;
    map['fullname'] = patient.fullname;
    map['birthday'] = patient.birthday;
    map['address'] = patient.address;
    map['country'] = patient.country;
    map['avatar'] = patient.avatar;
    map['gender'] = patient.gender;
    map['status'] = patient.status;
    map['state'] = patient.state;
    map['phone'] = patient.phone;
    map['email'] = patient.email;
    map['type'] = patient.type;
    map['city'] = patient.city;
    map['cep'] = patient.cep;
    map['id'] = patient.id;

    return map;
  }

  Map<String, dynamic> toJson(PatientModel patient) => {
        'responsible_id': patient.responsibleId,
        'cpf': patient.cpf,
        'type': patient.type,
        'id': patient.id,
        'avatar': patient.avatar,
        'created_at': FieldValue.serverTimestamp(),
        'email': patient.email,
        'fullname': patient.fullname,
        'phone': patient.phone,
        'username': patient.username,
        'birthday': patient.birthday,
        'gender': patient.gender,
        'cep': patient.cep,
        'address': patient.address,
        'number_address': patient.numberAddress,
        'complement_address': patient.complementAddress,
        'neighborhood': patient.neighborhood,
        'city': patient.city,
        'status': patient.status,
        'notification_disabled': patient.notificationDisabled,
        'address_keys': patient.addressKeys,
        'connected': patient.connected,
        'country': patient.country,
        'state': patient.state,
      };
}
