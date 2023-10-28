import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String doctorId;
  final String status;
  final String type;
  String id;

  final int totalVacancies;
  final int avaliableVacancies;
  final int occupiedVacancies;

  final Timestamp createdAt;
  final Timestamp date;
  final Timestamp endHour;
  final Timestamp startHour;

  ScheduleModel({
    this.doctorId,
    this.status,
    this.type,
    this.id,
    this.totalVacancies,
    this.avaliableVacancies,
    this.occupiedVacancies,
    this.createdAt,
    this.date,
    this.endHour,
    this.startHour,
  });

  factory ScheduleModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ScheduleModel(
      createdAt: doc['created_at'],
      date: doc['date'],
      doctorId: doc['doctor_id'],
      endHour: doc['end_hour'],
      startHour: doc['start_hour'],
      id: doc['id'],
      status: doc['status'],
      type: doc['type'],
      totalVacancies: doc['total_vacancies'],
      avaliableVacancies: doc['available_vacancies'],
      occupiedVacancies: doc['occupied_vacancies'],
    );
  }

  Map<String, dynamic> toJson(ScheduleModel schedule) {
    return {
      'created_at': schedule.createdAt,
      'date': schedule.date,
      'doctor_id': schedule.doctorId,
      'end_hour': schedule.endHour,
      'start_hour': schedule.startHour,
      'id': schedule.id,
      'status': schedule.status,
      'type': schedule.type,
      'total_vacancies': schedule.totalVacancies,
      'available_vacancies': schedule.avaliableVacancies,
      'occupied_vacancies': schedule.occupiedVacancies,
    };
  }
}
