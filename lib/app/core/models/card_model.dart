import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String id;
  String billingCep;
  String billingAddress;
  String billingDistrict;
  String billingState;
  String finalNumber;
  String city;
  List colors;
  String cpf;
  String dueDate;
  bool main;
  Timestamp createdAt;
  String status;

  CardModel({
    this.id,
    this.billingCep,
    this.billingAddress,
    this.billingDistrict,
    this.billingState,
    this.finalNumber,
    this.city,
    this.colors,
    this.cpf,
    this.createdAt,
    this.dueDate,
    this.main,
    this.status,
  });

  factory CardModel.fromDocument(DocumentSnapshot doc) {
    return CardModel(
      billingCep: doc['billing_cep'],
      billingAddress: doc['billing_address'],
      billingDistrict: doc['billing_district'],
      billingState: doc['billing_state'],
      finalNumber: doc['final_number'],
      city: doc['city'],
      colors: doc['colors'],
      cpf: doc['cpf'],
      dueDate: doc['due_date'],
      main: doc['main'],
      id: doc['id'],
      createdAt: doc['created_at'],
      status: doc['status'],
    );
  }
  Map<String, dynamic> convertRating(CardModel card) {
    Map<String, dynamic> map = {};
    map['id'] = card.id;
    map['billing_cep'] = card.billingCep;
    map['billing_address'] = card.billingAddress;
    map['billing_district'] = card.billingDistrict;
    map['billing_state'] = card.billingState;
    map['final_number'] = card.finalNumber;
    map['created_at'] = card.createdAt;
    map['city'] = card.city;
    map['colors'] = card.colors;
    map['cpf'] = card.cpf;
    map['due_date'] = card.dueDate;
    map['main'] = card.main;
    map['status'] = card.status;

    return map;
  }

  Map<String, dynamic> toJson(CardModel card) => {
        'billing_cep': card.billingCep,
        'billing_address': card.billingAddress,
        'billing_district': card.billingDistrict,
        'billing_state': card.billingState,
        'final_number': card.finalNumber,
        'city': card.city,
        'colors': card.colors,
        'cpf': card.cpf,
        'due_date': card.dueDate,
        'main': card.main,
        'id': card.id,
        'created_at': FieldValue.serverTimestamp(),
        'status': card.status,
      };
}
