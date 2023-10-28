import 'package:cloud_firestore/cloud_firestore.dart';

class DependentModel {
  String id;
  Timestamp createdAt;
  String email;
  String fullname;
  String phone;
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
  String avatar;
  String type;

  DependentModel({
    this.id,
    this.createdAt,
    this.email,
    this.fullname,
    this.phone,
    this.birthday,
    this.gender,
    this.cep,
    this.cpf,
    this.address,
    this.numberAddress,
    this.complementAddress,
    this.neighborhood,
    this.city,
    this.state,
    this.avatar,
    this.type,
  });

  factory DependentModel.fromDocument(DocumentSnapshot doc) {
    return DependentModel(
      id: doc['id'],
      createdAt: doc['created_at'],
      email: doc['email'],
      fullname: doc['fullname'],
      phone: doc['phone'],
      birthday: doc['birthday'],
      gender: doc['gender'],
      cep: doc['cep'],
      cpf: doc['cpf'],
      address: doc['address'],
      numberAddress: doc['number_address'],
      complementAddress: doc['complement_address'],
      neighborhood: doc['neighborhood'],
      city: doc['city'],
      state: doc['state'],
      avatar: doc['avatar'],
      type: doc['type'],
    );
  }
  Map<String, dynamic> convertUser(DependentModel dependent) {
    Map<String, dynamic> map = {};
    map['id'] = dependent.id;
    map['createdAt'] = dependent.createdAt;
    map['email'] = dependent.email;
    map['fullname'] = dependent.fullname;
    map['phone'] = dependent.phone;
    map['birthday'] = dependent.birthday;
    map['gender'] = dependent.gender;
    map['cep'] = dependent.cep;
    map['cpf'] = dependent.cpf;
    map['address'] = dependent.address;
    map['numberAddress'] = dependent.numberAddress;
    map['complementAddress'] = dependent.complementAddress;
    map['neighborhood'] = dependent.neighborhood;
    map['city'] = dependent.city;
    map['state'] = dependent.state;
    map['avatar'] = dependent.avatar;
    map['type'] = dependent.type;

    return map;
  }

  Map<String, dynamic> toJson(DependentModel dependent) => {
        'id': dependent.id,
        'createdAt': FieldValue.serverTimestamp(),
        'email': dependent.email,
        'fullname': dependent.fullname,
        'phone': dependent.phone,
        'birthday': dependent.birthday,
        'gender': dependent.gender,
        'cep': dependent.cep,
        'cpf': dependent.cpf,
        'address': dependent.address,
        'numberAddress': dependent.numberAddress,
        'complementAddress': dependent.complementAddress,
        'neighborhood': dependent.neighborhood,
        'city': dependent.city,
        'state': dependent.state,
        'avatar': dependent.avatar,
        'type': dependent.type,
      };
}
