import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/feed/feed_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/finances_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/messages/messages_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/scheduling_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key key, this.title = 'MainPage'}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ModularState<MainPage, MainStore>
    with WidgetsBindingObserver {
  final AuthStore authStore = Modular.get();
  RootStore rootStore = Modular.get();
  ScrollController scrollController = ScrollController();
  bool _isInForeground = true;

  @override
  void initState() {
    // authStore.signout();
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    store.userConnected(true);
    WidgetsBinding.instance.addObserver(this);
    store.authStore.getUserType();
    store.hasSupport = store.getSupport();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      BotToast.showSimpleNotification(
        title: '${notification.title}',
        subTitle: '${notification.body}',
        borderRadius: 25,
        backgroundColor: Color(0xff21BCCE),
        subTitleStyle: TextStyle(
          color: Colors.white,
        ),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        // subtitle:'' ,
        duration: Duration(seconds: 7),
      );
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    store.userConnected(_isInForeground);
    switch (state) {
      case AppLifecycleState.resumed:
        // Modular.to.pushNamed('/');
        setState(() {
          print(
              "%%%%%%%%%%%%% Modular.to.path ${Modular.to.path} %%%%%%%%%%%%%");
        });
        print("%%%%%%%%%%%%% app in resumed %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.inactive:
        print("%%%%%%%%%%%%% app in inactive %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.paused:
        print("%%%%%%%%%%%%% app in paused %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.detached:
        print("%%%%%%%%%%%%% app in detached %%%%%%%%%%%%%");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> trunkModule = [
    FeedModule(),
    ScheduleModule(),
    SchedulingModule(),
    MessagesModule(),
    FinancesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Observer(
        builder: (context) {
          return store.authStore.user == null
              ? Container()
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(store.authStore.user.uid)
                      .snapshots(),
                  builder: (context, userSnap) {
                    if (userSnap.hasData) {
                      DocumentSnapshot _user = userSnap.data;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        print('WidgetsBinding.instance.addPostFrameCallback');
                        store.getPopUps(_user);
                      });
                      print(
                          "####### _user['status']: ${_user['status']} #######");
                      if (_user['status'] == "BLOCKED") {
                        store.logout("Você foi bloqueado(a)");
                      }
                    }

                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(store.authStore.user.uid)
                          .collection('permissions')
                          .where('label', isEqualTo: 'PAYMENTS')
                          .snapshots(),
                      builder: (context, snapermissions) {
                        QuerySnapshot permissions;

                        if (store.authStore.type == 'SECRETARY') {
                          if (snapermissions.hasData) {
                            permissions = snapermissions.data;
                            if (permissions.docs.isNotEmpty) {
                              store.allowed =
                                  permissions.docs.first.get('value');
                            }
                          }
                        }
                        return Observer(
                          builder: (_) {
                            return Scaffold(
                              backgroundColor: Color(0xfffafafa),
                              body: SafeArea(
                                child: PageStorage(
                                  bucket: rootStore.bucketGlobal,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: maxHeight(context),
                                        width: maxWidth(context),
                                        key: PageStorageKey<String>('mainKey'),
                                        child: Observer(builder: (_) {
                                          return trunkModule[
                                              controller.selectedTrunk];
                                        }),
                                      ),
                                      AnimatedPositioned(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.decelerate,
                                        bottom: !store.showNavigator
                                            ? -(maxWidth(context) * 66 / 375)
                                            : 0,
                                        child: Container(
                                          height:
                                              (maxWidth(context) * 66 / 375),
                                          width: maxWidth(context),
                                          decoration: BoxDecoration(
                                            color: Color(0xfffafafa),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x29000000),
                                                offset: Offset.zero,
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              EncontrarCuidadoTile(
                                                ontap: () {
                                                  if (store.selectedTrunk !=
                                                      0) {
                                                    store.setSelectedTrunk(0);
                                                  }
                                                },
                                                icon: Icons.home_outlined,
                                                title: 'Início',
                                                thisPage:
                                                    store.selectedTrunk == 0
                                                        ? true
                                                        : false,
                                              ),
                                              EncontrarCuidadoTile(
                                                ontap: () {
                                                  if (store.selectedTrunk !=
                                                      1) {
                                                    store.setSelectedTrunk(1);
                                                  }
                                                },
                                                icon: Icons
                                                    .calendar_today_outlined,
                                                title: 'Agenda',
                                                thisPage:
                                                    store.selectedTrunk == 1
                                                        ? true
                                                        : false,
                                              ),
                                              Spacer(),
                                              EncontrarCuidadoTile(
                                                ontap: () {
                                                  if (store.selectedTrunk !=
                                                      3) {
                                                    store.setSelectedTrunk(3);
                                                  }
                                                },
                                                icon: Icons.messenger_outline,
                                                title: 'Mensagens',
                                                thisPage:
                                                    store.selectedTrunk == 3
                                                        ? true
                                                        : false,
                                              ),
                                              EncontrarCuidadoTile(
                                                ontap: () {
                                                  if (store.authStore.type ==
                                                      null) {
                                                    /////////////    'DONT REMOVE THIS VALIDATION'
                                                  } else {
                                                    if (store.authStore.type ==
                                                            'DOCTOR' ||
                                                        (store.authStore.type ==
                                                                'SECRETARY' &&
                                                            store.allowed ==
                                                                true)) {
                                                      if (store.selectedTrunk !=
                                                          4) {
                                                        store.setSelectedTrunk(
                                                            4);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: "Acesso negado",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Color(0xff21BCCE),
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  }
                                                },
                                                icon: Icons
                                                    .monetization_on_outlined,
                                                title: 'Financeiro',
                                                thisPage:
                                                    store.selectedTrunk == 4
                                                        ? true
                                                        : false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: maxWidth(context) * 30 / 375,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            if (store.selectedTrunk != 2) {
                                              setState(() {
                                                store.setSelectedTrunk(2);
                                              });
                                            }
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.decelerate,
                                            height: store.showNavigator
                                                ? maxWidth(context) * 70 / 375
                                                : 0,
                                            width: store.showNavigator
                                                ? maxWidth(context) * 70 / 375
                                                : 0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                  color: Color(0x30000000),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xff41C3B3),
                                                    Color(0xff21BCCE),
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              border: Border.all(
                                                width: 3,
                                                color: store.selectedTrunk == 2
                                                    ? Color(0xff2185D0)
                                                    : Color(0xfffafafa),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Color(0xfffafafa),
                                              size: store.showNavigator
                                                  ? maxWidth(context) * .08
                                                  : 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example

    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.viewDoctorId)
        .update({
      'token_id': FieldValue.arrayUnion([token]),
    });
  }
}
