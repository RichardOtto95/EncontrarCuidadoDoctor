import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/time_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final MainStore mainStore = Modular.get();
  final ProfileStore store = Modular.get();
  bool emptyState = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mainStore.clearNotifications();
        store.viewedNotifications();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EncontrarCuidadoAppBar(
                  title: 'Notificações',
                  onTap: () async {
                    mainStore.clearNotifications();
                    store.viewedNotifications();
                    Modular.to.pop();
                  },
                ),
                Observer(
                  builder: (context) {
                    print(
                        'xxxxxx notification Observer ${mainStore.authStore.viewDoctorId} xxxxxxx');
                    return mainStore.authStore.viewDoctorId != null
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(mainStore.authStore.viewDoctorId)
                                .collection('notifications')
                                .where('status', isEqualTo: 'SENDED')
                                .snapshots(),
                            builder: (context, snapshotDoctor) {
                              return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('notifications')
                                    .where('receiver_id',
                                        isEqualTo: mainStore.authStore.user.uid)
                                    .snapshots(),
                                builder: (context, snapshotSecretary) {
                                  if (snapshotSecretary.hasData &&
                                      snapshotDoctor.hasData) {
                                    QuerySnapshot secretaryNotifications =
                                        snapshotSecretary.data;
                                    QuerySnapshot doctorNotifications =
                                        snapshotDoctor.data;
                                    store.getNotifications(
                                        secretaryNotifications,
                                        doctorNotifications);

                                    if (secretaryNotifications.docs.isEmpty &&
                                        doctorNotifications.docs.isEmpty) {
                                      return EmptyStateList(
                                        image: 'assets/img/work_on2.png',
                                        description:
                                            'Sem notificações para serem listadas',
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          store.notificationNotVisualized
                                                  .isNotEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                    wXD(21, context),
                                                    wXD(7, context),
                                                    0,
                                                    wXD(10, context),
                                                  ),
                                                  child: Text(
                                                    'Novas',
                                                    style: TextStyle(
                                                      color: Color(0xff4C4C4C),
                                                      fontSize:
                                                          wXD(20, context),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          ...List.generate(
                                              store.notificationNotVisualized
                                                  .length, (index) {
                                            return Notification(
                                              senderId: store
                                                      .notificationNotVisualized[
                                                  index]['sender_id'],
                                              text: store
                                                      .notificationNotVisualized[
                                                  index]['text'],
                                              date: store
                                                  .notificationNotVisualized[
                                                      index]['dispatched_at']
                                                  .toDate(),
                                            );
                                          }),
                                          store.notificationVisualized
                                                  .isNotEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                    wXD(21, context),
                                                    wXD(7, context),
                                                    0,
                                                    wXD(10, context),
                                                  ),
                                                  child: Text(
                                                    'Anteriores',
                                                    style: TextStyle(
                                                      color: Color(0xff4C4C4C),
                                                      fontSize:
                                                          wXD(20, context),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          ...List.generate(
                                              store.notificationVisualized
                                                  .length, (index) {
                                            return Notification(
                                                senderId: store
                                                        .notificationVisualized[
                                                    index]['sender_id'],
                                                text: store
                                                        .notificationVisualized[
                                                    index]['text'],
                                                viewed: true,
                                                date: store
                                                    .notificationVisualized[
                                                        index]['dispatched_at']
                                                    .toDate());
                                          }),
                                        ],
                                      );
                                    }
                                  } else {
                                    return LinearProgressIndicator();
                                  }
                                },
                              );
                            },
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('notifications')
                                .where('receiver_id',
                                    isEqualTo: mainStore.authStore.user.uid)
                                .orderBy('dispatched_at', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return EmptyStateList(
                                  image: 'assets/img/work_on2.png',
                                  description:
                                      'Sem notificações para serem listadas',
                                );
                              } else {
                                QuerySnapshot _qs = snapshot.data;
                                if (_qs.docs.isEmpty) {
                                  return EmptyStateList(
                                    image: 'assets/img/work_on2.png',
                                    description:
                                        'Sem notificações para serem listadas',
                                  );
                                } else {
                                  store.getNotificationsSecretary(_qs);

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      store.notificationNotVisualized.isNotEmpty
                                          ? Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                wXD(21, context),
                                                wXD(7, context),
                                                0,
                                                wXD(10, context),
                                              ),
                                              child: Text(
                                                'Novas',
                                                style: TextStyle(
                                                  color: Color(0xff4C4C4C),
                                                  fontSize: wXD(20, context),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      ...List.generate(
                                          store.notificationNotVisualized
                                              .length, (index) {
                                        return Notification(
                                          senderId:
                                              store.notificationNotVisualized[
                                                  index]['sender_id'],
                                          text: store.notificationNotVisualized[
                                              index]['text'],
                                          date: store
                                              .notificationNotVisualized[index]
                                                  ['dispatched_at']
                                              .toDate(),
                                        );
                                      }),
                                      store.notificationVisualized.isNotEmpty
                                          ? Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                wXD(21, context),
                                                wXD(7, context),
                                                0,
                                                wXD(10, context),
                                              ),
                                              child: Text(
                                                'Anteriores',
                                                style: TextStyle(
                                                  color: Color(0xff4C4C4C),
                                                  fontSize: wXD(20, context),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      ...List.generate(
                                          store.notificationVisualized.length,
                                          (index) {
                                        return Notification(
                                            senderId:
                                                store.notificationVisualized[
                                                    index]['sender_id'],
                                            text: store.notificationVisualized[
                                                index]['text'],
                                            viewed: true,
                                            date: store
                                                .notificationVisualized[index]
                                                    ['dispatched_at']
                                                .toDate());
                                      }),
                                    ],
                                  );
                                }
                              }
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Notification extends StatelessWidget {
  final bool viewed;
  final String text;
  final String title;
  final String senderId;
  final DateTime date;

  const Notification({
    Key key,
    this.viewed = false,
    this.text,
    this.title = '',
    this.date,
    this.senderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('xxxxxxxxxx build $senderId xxxxxxxxxx');
    double maxWidth = MediaQuery.of(context).size.width;
    String avatar;
    return Container(
      height: wXD(85, context),
      decoration: BoxDecoration(
        color: viewed ? Colors.transparent : Color(0x3541C3B3),
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              wXD(15, context),
              wXD(0, context),
              wXD(13, context),
              wXD(0, context),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: senderId != null
                  ? FutureBuilder(
                      future: getStream(senderId),
                      builder: (context, snapshotDoctor) {
                        if (snapshotDoctor.hasData) {
                          DocumentSnapshot doctorDoc = snapshotDoctor.data;
                          avatar = doctorDoc['avatar'];
                        }
                        return CircleAvatar(
                          backgroundImage: avatar == null
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(avatar),
                          radius: wXD(32, context),
                        );
                      })
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('info')
                          .snapshots(),
                      builder: (context, snapshotInfo) {
                        if (snapshotInfo.hasData) {
                          QuerySnapshot qs = snapshotInfo.data;
                          DocumentSnapshot infoDoc = qs.docs.first;
                          avatar = infoDoc['support_avatar'];
                        }
                        return CircleAvatar(
                          backgroundImage: avatar == null
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(avatar),
                          radius: wXD(32, context),
                        );
                      },
                    ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title == ''
                  ? Container()
                  : Container(
                      width: maxWidth * .74,
                      child: Text(
                        '$title',
                        strutStyle: StrutStyle(),
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: wXD(13, context),
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
              Container(
                width: maxWidth * .74,
                child: Text(
                  '$text',
                  strutStyle: StrutStyle(),
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: wXD(13, context),
                    color: Color(0xff707070),
                  ),
                ),
              ),
              Text(
                getDate(),
                style: TextStyle(
                  fontSize: wXD(12, context),
                  color: Color(0x72707070),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future getStream(String senderId) async {
    DocumentSnapshot _patient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(senderId)
        .get();
    if (_patient.exists) {
      return _patient;
    } else {
      return await FirebaseFirestore.instance
          .collection('doctors')
          .doc(senderId)
          .get();
    }
  }

  String getDate() {
    DateTime now = DateTime.now();
    Duration dur;
    if (date != null) {
      dur = now.difference(date);
      String day = dur.inDays == 0
          ? 'Hoje'
          : dur.inDays == 1
              ? 'Ontem'
              : DateFormat("EEEE", "pt_BR").format(date);
      return day + ', ${TimeModel().hour(Timestamp.fromDate(date))}';
    } else {
      return 'agora';
    }
  }
}
