import 'package:cached_network_image/cached_network_image.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../schedule_store.dart';

class CardPatient extends StatelessWidget {
  final PatientModel patient;
  final Function onTap;

  const CardPatient({
    Key key,
    this.onTap,
    this.patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = patient.username ?? patient.fullname;
    final ScheduleStore store = Modular.get();

    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          wXD(8, context),
          wXD(9, context),
          wXD(17, context),
          wXD(13, context),
        ),
        height: wXD(94, context),
        width: wXD(290, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(17),
          ),
          border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: patient.avatar == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: wXD(33, context),
                          width: wXD(33, context),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: patient.avatar,
                          width: wXD(33, context),
                          height: wXD(33, context),
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: wXD(8, context)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username.length >= 20
                          ? '${username.substring(0, 20)}...'
                          : '$username',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff484D54),
                        // fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wXD(3, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.type == 'DEPENDENT'
                                ? 'Dependente'
                                : 'Titular',
                            style: TextStyle(
                              color: Color(0xff484D54),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'CPF: ${cpfMasked(patient.cpf)}',
                            style: TextStyle(
                              color: Color(0xff707070).withOpacity(.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Telefone:  ${patient.phone}',
                            style: TextStyle(
                              color: Color(0xff707070).withOpacity(.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  child: InkWell(
                    onTap: () {
                      store.patientSelected = null;
                    },
                    child: Icon(
                      Icons.close,
                      size: wXD(23, context),
                      color: Color(0xffDB2828),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
