import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
    this.viewed,
    this.createdAt,
    this.receiverId,
    this.type,
    this.id,
    this.dispatched_at,
    this.text,
    this.status,
  });
  String id;
  final String receiverId;
  final String text;
  final Timestamp createdAt;
  final Timestamp dispatched_at;
  bool viewed;
  String status;
  String type;

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
        createdAt: doc['created_at'],
        receiverId: doc['receiver_id'],
        type: doc['type'],
        id: doc['id'],
        dispatched_at: doc['dispatched_at'],
        text: doc['text'],
        status: doc['status'],
        viewed: doc['viewed']);
  }

  Map<String, dynamic> toJson(NotificationModel notificationModel) => {
        'created_at': notificationModel.createdAt,
        'receiver_id': notificationModel.receiverId,
        'type': notificationModel.type,
        'id': notificationModel.id,
        'dispatched_at': notificationModel.dispatched_at,
        'text': notificationModel.text,
        'status': notificationModel.status,
        'viewed': notificationModel.viewed,
      };
}
