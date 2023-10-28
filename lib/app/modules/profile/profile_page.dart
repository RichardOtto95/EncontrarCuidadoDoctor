import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/card_profile.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/widgets/profile_manager.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/utilities.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ModularState<ProfilePage, ProfileStore> {
  final ProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  final RootStore rootStore = Modular.get();
  String username = 'Nome do usuário';
  String avatar;
  bool back = false;
  bool doctorDel = false;

  @override
  void initState() {
    store.getDeleteProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getChooseDoctor(
        secretaryId: authStore.user.uid,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('xxxxxxxxxxxxxx router profile ${Modular.to.path} zzzzzzzzzzzzzzz');
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    bool loadCircularLogout = false;

    return WillPopScope(
      onWillPop: () async {
        if (mainStore.authStore.viewDoctorId != null) {
          mainStore.showNavigator = true;
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(mainStore.authStore.user.uid)
                    .collection('permissions')
                    .snapshots(),
                builder: (context, snapermissions) {
                  if (mainStore.authStore.type == 'SECRETARY') {
                    store.getPermissions(snapermissions);
                  }
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: maxHeight,
                        width: maxWidth,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: wXD(20, context),
                            left: wXD(19, context),
                          ),
                          alignment: Alignment.topLeft,
                          height: maxHeight * .3,
                          width: maxWidth,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Color(0x30000000),
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff41C3B3),
                                Color(0xff21BCCE),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Observer(builder: (context) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: wXD(20, context),
                                      left: wXD(12, context),
                                      bottom: wXD(15, context),
                                    ),
                                    child: Row(
                                      children: [
                                        mainStore.authStore.viewDoctorId == null
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  mainStore.showNavigator =
                                                      true;

                                                  Modular.to.pop();
                                                },
                                                child: Icon(
                                                  Icons.arrow_back_ios_outlined,
                                                  size: maxWidth * 28 / 375,
                                                  color: Color(0xfffafafa),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          'Meu perfil',
                                          style: TextStyle(
                                              color: Color(0xfffafafa),
                                              fontSize: wXD(20, context),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: maxWidth * .9,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: wXD(50, context),
                                        ),
                                        Observer(
                                          builder: (context) {
                                            if (authStore.user == null) {
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            wXD(30, context),
                                                        horizontal:
                                                            wXD(30, context),
                                                      ),
                                                      child: Text(
                                                        username,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xff707070),
                                                          fontSize:
                                                              wXD(25, context),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )),
                                                  Positioned(
                                                    top: wXD(0, context),
                                                    right: wXD(0, context),
                                                    child: Icon(
                                                      Icons.create,
                                                      size: 25,
                                                      color: Color(0xff707070),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('doctors')
                                                    .doc(authStore.user.uid)
                                                    .snapshots(),
                                                builder: (context,
                                                    snapshotUsername) {
                                                  if (!snapshotUsername
                                                      .hasData) {
                                                    return Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: wXD(
                                                                30, context),
                                                            horizontal: wXD(
                                                                30, context),
                                                          ),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        Positioned(
                                                          top: wXD(0, context),
                                                          right:
                                                              wXD(0, context),
                                                          child: IconButton(
                                                            onPressed: null,
                                                            icon: Icon(
                                                              Icons.create,
                                                              size: 25,
                                                              color: Color(
                                                                  0xff707070),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  DocumentSnapshot ds;

                                                  if (snapshotUsername
                                                      .hasData) {
                                                    ds = snapshotUsername.data;
                                                    username = ds['username'];
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      store
                                                          .setUserNotifications(
                                                              ds);
                                                    });
                                                  }

                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: wXD(
                                                                30, context),
                                                            horizontal: wXD(
                                                                30, context),
                                                          ),
                                                          child: Text(
                                                            ds['username'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff707070),
                                                              fontSize: wXD(
                                                                  25, context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          )),
                                                      Positioned(
                                                        top: wXD(0, context),
                                                        right: wXD(0, context),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            DoctorModel
                                                                doctorModel =
                                                                DoctorModel
                                                                    .fromDocument(
                                                                        ds);
                                                            Modular.to.pushNamed(
                                                                '/profile/edit-profile',
                                                                arguments:
                                                                    doctorModel);
                                                          },
                                                          icon: Icon(
                                                            Icons.create,
                                                            size: 25,
                                                            color: Color(
                                                                0xff707070),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                        PerfilTill(
                                          onTap: () => Modular.to.pushNamed(
                                              '/profile/notifications'),
                                          title: 'Notificações',
                                          icon: Icons.notifications_none,
                                          index: store.newNotifications,
                                        ),
                                        mainStore.authStore.type == 'SECRETARY'
                                            ? PerfilTill(
                                                onTap: () {
                                                  if (mainStore.authStore
                                                          .viewDoctorId ==
                                                      null) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Nenhum médico associado",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Color(0xff21BCCE),
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    store.visibleProfileManager =
                                                        true;
                                                  }
                                                },
                                                title: 'Perfil do médico',
                                                icon: Icons.person,
                                              )
                                            : Container(),
                                        mainStore.authStore.viewDoctorId != null
                                            ? PerfilTill(
                                                onTap: () {
                                                  Modular.to
                                                      .pushNamed('/ratings');
                                                },
                                                title: 'Avaliações',
                                                icon: Icons.star_outline,
                                                index: store.newRatings,
                                              )
                                            : Container(),
                                        Visibility(
                                          visible: authStore.type == 'DOCTOR' ||
                                              authStore.type == 'SECRETARY' &&
                                                  store.secretariesAllowed,
                                          child: PerfilTill(
                                            onTap: () {
                                              Modular.to
                                                  .pushNamed('/secretaries');
                                            },
                                            title: 'Meus secretários',
                                            icon: Icons.people,
                                          ),
                                        ),
                                        mainStore.authStore.type == 'DOCTOR'
                                            ? PerfilTill(
                                                onTap: () => Modular.to
                                                    .pushNamed('/signature'),
                                                title: 'Assinaturas',
                                                icon: Icons.touch_app_outlined,
                                              )
                                            : Container(),
                                        PerfilTill(
                                          onTap: () async {
                                            if (mainStore.hasSupport) {
                                              store.getSuportChat(
                                                  mainStore.supportId);
                                            }

                                            Modular.to.pushNamed('/suport');
                                          },
                                          title: 'Suporte',
                                          icon: Icons.headset_mic_rounded,
                                          index: store.supportNotifications,
                                        ),
                                        PerfilTill(
                                          onTap: () {
                                            Modular.to.pushNamed('/settings/');
                                          },
                                          title: 'Configurações',
                                          icon: Icons.settings,
                                        ),
                                        PerfilTill(
                                          onTap: () {
                                            store.logout = true;
                                          },
                                          title: 'Sair',
                                          icon: Icons.logout,
                                          bottomBorder: store.haveDeleteProfile,
                                        ),
                                        store.haveDeleteProfile
                                            ? PerfilTill(
                                                bottomBorder: false,
                                                onTap: () {
                                                  store.deleteProfileDialog =
                                                      true;
                                                },
                                                title: 'Excluir perfil',
                                                icon: Icons.delete,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Observer(
                                builder: (context) {
                                  if (authStore.user == null) {
                                    return Positioned(
                                      top: wXD(34, context),
                                      child: CardProfile(
                                          size: wXD(47, context),
                                          photo: avatar),
                                    );
                                  } else {
                                    return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(authStore.user.uid)
                                            .snapshots(),
                                        builder: (context, snapshotUser) {
                                          if (!snapshotUser.hasData) {
                                            return Positioned(
                                              top: wXD(34, context),
                                              child: CardProfile(
                                                  size: wXD(47, context),
                                                  photo: null),
                                            );
                                          }

                                          DocumentSnapshot ds =
                                              snapshotUser.data;
                                          avatar = ds['avatar'];

                                          return Positioned(
                                            top: wXD(34, context),
                                            child: InkWell(
                                              onTap: () {
                                                DoctorModel doctorModel =
                                                    DoctorModel.fromDocument(
                                                        ds);
                                                Modular.to.pushNamed(
                                                    '/profile/edit-profile',
                                                    arguments: doctorModel);
                                              },
                                              child: CardProfile(
                                                  size: wXD(47, context),
                                                  photo: ds['avatar']),
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                      Observer(
                        builder: (context) {
                          return Visibility(
                            visible: store.logout || store.deleteProfileDialog,
                            child: Container(
                              height: maxHeight,
                              width: maxWidth,
                              color: Color(0x50000000),
                              child: Center(
                                child: StatefulBuilder(
                                    builder: (context, stateSet) {
                                  return Container(
                                    padding:
                                        EdgeInsets.only(top: wXD(5, context)),
                                    height: wXD(160, context),
                                    width: wXD(324, context),
                                    decoration: BoxDecoration(
                                        color: Color(0xfffafafa),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(38))),
                                    child: Column(
                                      children: [
                                        Spacer(),
                                        Text(
                                          store.deleteProfileDialog
                                              ? 'Deseja excluir o seu perfil?'
                                              : 'Tem certeza que deseja sair?',
                                          style: TextStyle(
                                            fontSize: wXD(15, context),
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xfa707070),
                                          ),
                                        ),
                                        Spacer(),
                                        loadCircularLogout
                                            ? Row(
                                                children: [
                                                  Spacer(),
                                                  CircularProgressIndicator(),
                                                  Spacer(),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      store.logout = false;
                                                      store.deleteProfileDialog =
                                                          false;
                                                    },
                                                    child: Container(
                                                      height: wXD(47, context),
                                                      width: wXD(98, context),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 3,
                                                                color: Color(
                                                                    0x28000000))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          22)),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0x80707070)),
                                                          color: Color(
                                                              0xfffafafa)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Não',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff2185D0),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: wXD(
                                                                16, context)),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () async {
                                                      stateSet(() {
                                                        loadCircularLogout =
                                                            true;
                                                      });

                                                      if (store.logout) {
                                                        store.listenSecretaryDoc
                                                            .cancel();

                                                        await store
                                                            .setTokenLogout();
                                                        await mainStore
                                                            .userConnected(
                                                                false);
                                                        authStore.signout();

                                                        rootStore
                                                            .selectedTrunk = 1;
                                                        store.logout = false;
                                                        store.deleteProfileDialog =
                                                            false;
                                                        mainStore.authStore
                                                                .viewDoctorId =
                                                            null;
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                                context,
                                                                '/',
                                                                ModalRoute
                                                                    .withName(
                                                                        '/'));
                                                      }
                                                      if (store
                                                          .deleteProfileDialog) {
                                                        store.deletingProfile();
                                                      }

                                                      stateSet(() {
                                                        loadCircularLogout =
                                                            false;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: wXD(47, context),
                                                      width: wXD(98, context),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 3,
                                                                color: Color(
                                                                    0x28000000))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          22)),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0x80707070)),
                                                          color: Color(
                                                              0xfffafafa)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Sim',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff2185D0),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: wXD(
                                                                16, context)),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                        Spacer(),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                      ProfileManager(
                        onCancel: () {
                          store.visibleProfileManager = false;
                        },
                        viewProfile: () async {
                          DoctorModel doctorModel =
                              await store.getDoctorModel();
                          Modular.to.pushNamed('/profile/dr-profile',
                              arguments: doctorModel);
                          store.visibleProfileManager = false;
                        },
                        editProfile: () async {
                          if (mainStore.authStore.type == 'DOCTOR' ||
                              (mainStore.authStore.type == 'SECRETARY' &&
                                  store.editProfileAllowed == true)) {
                            mainStore.secretaryEditDoctor = true;

                            DoctorModel doctorModel =
                                await store.getDoctorModel();

                            Modular.to.pushNamed('/profile/edit-profile',
                                arguments: doctorModel);

                            store.visibleProfileManager = false;
                          } else {
                            Fluttertoast.showToast(
                                msg: "Acesso negado",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff21BCCE),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      ),
                      authStore.viewDoctorId != null
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("doctors")
                                  .doc(authStore.viewDoctorId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  DocumentSnapshot ds = snapshot.data;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    store.getRatingNotifications(ds);
                                  });
                                }

                                return Container();
                              },
                            )
                          : Container(),
                    ],
                  );
                })),
      ),
    );
  }
}

class PerfilTill extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool bottomBorder;
  final Function onTap;
  final String index;

  const PerfilTill({
    Key key,
    this.icon,
    this.title,
    this.onTap,
    this.bottomBorder = true,
    this.index = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: maxWidth,
            height: hXD(65, context),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: maxWidth * 1 / 375,
                      left: maxWidth * 12 / 375,
                      right: wXD(10, context)),
                  child: Icon(
                    icon,
                    size: wXD(29, context),
                    color: Color(0xff707070),
                  ),
                ),
                Container(
                  child: Text(
                    '$title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: wXD(15, context),
                  color: Color(0xff707070),
                ),
                SizedBox(
                  width: wXD(10, context),
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: maxWidth * 15 / 375),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: bottomBorder ? Color(0x40707070) : Colors.transparent,
                ),
              ),
            ),
          ),
          index != ''
              ? Positioned(
                  left: wXD(40, context),
                  top: wXD(10, context),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: wXD(5, context)),
                    height: wXD(17, context),
                    width: wXD(17, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red),
                    child: Text(
                      index,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
