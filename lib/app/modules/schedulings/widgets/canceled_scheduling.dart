import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import '../scheduling_store.dart';

class CanceledScheduling extends StatelessWidget {
  final String status, patientId, patientName, appointmentId;
  final Timestamp date;
  final SchedulingStore store;
  final Function viewPatientProfile, viewConsulationDetail;
  final bool isDependent;

  const CanceledScheduling({
    Key key,
    this.date,
    this.status,
    this.patientId,
    this.store,
    this.patientName,
    this.viewPatientProfile,
    this.viewConsulationDetail,
    this.isDependent,
    this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(15, context),
        right: wXD(15, context),
        left: wXD(15, context),
      ),
      padding: EdgeInsets.symmetric(vertical: wXD(10, context)),
      height: wXD(160, context),
      width: wXD(334, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(3, 3),
            color: Color(0x30000000),
          ),
        ],
        color: Color(0xfffafafa),
      ),
      child: Column(
        children: [
          Text(
            store.getDate(date),
            style: TextStyle(
              color: Color(0xff707070).withOpacity(.7),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          InkWell(
            onTap: () {
              viewPatientProfile();
            },
            child: Container(
              margin: EdgeInsets.only(
                top: wXD(7, context),
              ),
              // height: wXD(88, context),
              width: wXD(300, context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patientId)
                          .snapshots(),
                      builder: (context, snapshotPatient) {
                        if (!snapshotPatient.hasData)
                          return Container(
                              height: wXD(60, context),
                              width: wXD(60, context),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                        DocumentSnapshot docDoctor = snapshotPatient.data;
                        return CircleAvatar(
                          radius: wXD(30, context),
                          backgroundImage: docDoctor['avatar'] == null
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(
                                  docDoctor['avatar'],
                                ),
                        );
                      }),
                  SizedBox(width: wXD(8, context)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: wXD(2, context),
                          left: wXD(3, context),
                          bottom: wXD(5, context),
                        ),
                        child: Text(
                          patientName.length >= 26
                              ? patientName.substring(0, 26) + '...'
                              : patientName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xff484D54),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: wXD(3, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID da consulta: ' + appointmentId,
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              isDependent ? 'Dependente' : 'Titular',
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () async {
              viewConsulationDetail();
              store.mainStore.patientId = patientId;
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        status == 'REFUSED'
                            ? 'Paciente recusou o encaixe'
                            : 'Agendamento cancelado',
                        style: TextStyle(
                          color: Color(0xff707070).withOpacity(.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.close,
                      color: Color(0xffDB2828),
                      size: wXD(23, context),
                    )
                  ],
                ),
                Text(
                  'Detalhes',
                  style: TextStyle(
                    color: Color(0xff2185D0),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
