import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialModel {
  FinancialModel({
    this.createdAt,
    this.type,
    this.receiverId,
    this.id,
    this.sender,
    this.senderId,
    this.receiver,
    this.value,
    this.date,
    this.note,
    this.status,
  });

  final Timestamp createdAt;
  final String id;
  final String sender;
  final String senderId;
  final String receiver;
  final String receiverId;
  final num value;
  final Timestamp date;
  final String note;
  final String status;
  final String type;

  factory FinancialModel.fromDocument(Map<String, dynamic> doc) {
    return FinancialModel(
      createdAt: doc['created_at'],
      date: doc['date'],
      id: doc['id'],
      note: doc['note'],
      receiver: doc['receiver'],
      receiverId: doc['receiver_id'],
      sender: doc['sender'],
      senderId: doc['sender_id'],
      status: doc['status'],
      type: doc['type'],
      value: doc['value'],
    );
  }
  Map<String, dynamic> toJson(FinancialModel financialModel) => {
        'created_at': FieldValue.serverTimestamp(),
        'date': financialModel.date,
        'id': financialModel.id,
        'note': financialModel.note,
        'receiver': financialModel.receiver,
        'receiver_id': financialModel.receiverId,
        'sender': financialModel.sender,
        'sender_id': financialModel.senderId,
        'value': financialModel.value,
        'status': financialModel.status,
        'type': financialModel.type,
      };
}

class FinancialGridModel {
  final bool selected;
  final FinancialModel financialModel;
  FinancialGridModel(this.selected, this.financialModel);
}
