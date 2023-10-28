import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/feed/widgets/new_post.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/person_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'feed_card.dart';
import 'feed_store.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  final FeedStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final RootStore rootStore = Modular.get();
  ScrollController scrollController;
  File imageFile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.clearFeed();
    });
    scrollController = ScrollController();
    store.getHasNext();
    store.fetchAssets();
    handleScroll();
    mainStore.getUser();
    super.initState();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setShowNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setShowNav(true);
      }

      if ((scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange)) {
        if (store.hasNext) {
          store.feedLimit += 10;
          store.getLimit();
          store.getHasNext();
        }
      }
    });
  }

  @override
  void dispose() {
    // mainStore.getQueries();
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Observer(builder: (_) {
      return Listener(
        onPointerDown: (event) {
          if (store.newPost == false && store.galery == false) {
            mainStore.setShowNav(true);
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xfffafafa),
          body: SafeArea(
            child: PageStorage(
              bucket: rootStore.bucketGlobal,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      EncontrarCuidadoNavBar(
                        leading: Padding(
                          padding: EdgeInsets.fromLTRB(
                            wXD(15, context),
                            wXD(10, context),
                            wXD(10, context),
                            wXD(10, context),
                          ),
                          child: Image.asset(
                            'assets/img/grupo_43.png',
                            height: wXD(45, context),
                          ),
                        ),
                        action: Observer(
                          builder: (context) {
                            if (mainStore.authStore.user == null) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: wXD(10, context),
                                        top: wXD(7, context)),
                                    child: PersonPhoto(
                                      photo: null,
                                      borderColor: Color(0xff41C3B3),
                                      size: maxWidth * .11,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      height: maxWidth * .0613,
                                      width: 23,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff21BCCE),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return StreamBuilder<Object>(
                                stream: FirebaseFirestore.instance
                                    .collection('doctors')
                                    .doc(mainStore.authStore.viewDoctorId)
                                    .snapshots(),
                                builder: (context, snapDoctor) {
                                  if (!snapDoctor.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    DocumentSnapshot _doctorDoc =
                                        snapDoctor.data;
                                    if (_doctorDoc.exists) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        // store.newNotifications =
                                        //     _doctorDoc['new_notifications'] ??
                                        //         0;
                                        store.newRatings =
                                            _doctorDoc['new_ratings'] ?? 0;
                                      });
                                    }

                                    return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('doctors')
                                          .doc(mainStore.authStore.user.uid)
                                          .snapshots(),
                                      builder: (context, snapshotUser) {
                                        if (!snapshotUser.hasData) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('doctors')
                                                .doc(mainStore
                                                    .authStore.user.uid)
                                                .collection('permissions')
                                                .where('label',
                                                    isEqualTo: 'FEED')
                                                .snapshots(),
                                            builder:
                                                (context, snapshotPrmissions) {
                                              DocumentSnapshot _user;
                                              QuerySnapshot feed;

                                              if (!snapshotUser.hasData) {
                                                return Container();
                                              }

                                              if (snapshotUser.hasData) {
                                                _user = snapshotUser.data;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  store.supportNotifications =
                                                      _user['support_notifications'] ??
                                                          0;
                                                  store
                                                      .newNotifications = _user[
                                                          'new_notifications'] ??
                                                      0;
                                                });
                                              }

                                              if (mainStore.authStore.type ==
                                                  'SECRETARY') {
                                                if (snapshotPrmissions
                                                    .hasData) {
                                                  feed =
                                                      snapshotPrmissions.data;
                                                  if (feed.docs.isNotEmpty) {
                                                    store.allowed = feed
                                                        .docs.first
                                                        .get('value');
                                                  }
                                                }
                                              }

                                              // allNotifications =
                                              //     store.getAllNotifications(
                                              //         _user['new_ratings'],
                                              //         _user['new_notifications'],
                                              //         _user['support_notifications']);
                                              return Observer(
                                                builder: (context) {
                                                  // WidgetsBinding.instance
                                                  //     .addTimingsCallback(
                                                  //         (timings) {
                                                  // });
                                                  store.allNotifications = store
                                                          .newNotifications +
                                                      store.newRatings +
                                                      store
                                                          .supportNotifications;

                                                  print(
                                                      "totalNotifications: ${store.allNotifications} = ${store.newNotifications} + ${store.newRatings} + ${store.supportNotifications}");
                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          print(
                                                              'xxxxxxxxxxxx onTapp xxxxxxxxxxxxxxx');
                                                          // FirebaseFunctions
                                                          //     functions =
                                                          //     FirebaseFunctions
                                                          //         .instance;
                                                          // functions
                                                          //     .useFunctionsEmulator(
                                                          //         'localhost',
                                                          //         5001);
                                                          // HttpsCallable
                                                          //     callable =
                                                          //     FirebaseFunctions
                                                          //         .instance
                                                          //         .httpsCallable(
                                                          //             'lastPaymentTeste');

                                                          // try {
                                                          //   await callable
                                                          //       .call({
                                                          //     'id': FirebaseAuth
                                                          //         .instance
                                                          //         .currentUser
                                                          //         .uid,
                                                          //   });
                                                          // } on FirebaseFunctionsException catch (e) {
                                                          //   print('ERROR:');

                                                          //   print(e);
                                                          // }

                                                          Modular.to.pushNamed(
                                                              '/profile');
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: wXD(10,
                                                                      context),
                                                                  top: wXD(7,
                                                                      context)),
                                                          child: PersonPhoto(
                                                            photo:
                                                                _user['avatar'],
                                                            borderColor: Color(
                                                                0xff41C3B3),
                                                            size:
                                                                maxWidth * .11,
                                                          ),
                                                        ),
                                                      ),
                                                      store.allNotifications ==
                                                              0
                                                          ? Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: Container(
                                                                height:
                                                                    maxWidth *
                                                                        .0613,
                                                                width: 23,
                                                              ),
                                                            )
                                                          : Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: Container(
                                                                height: wXD(24,
                                                                    context),
                                                                width: wXD(24,
                                                                    context),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xff21BCCE)),
                                                                child: Center(
                                                                  child:
                                                                      Observer(
                                                                    builder: (
                                                                      context,
                                                                    ) {
                                                                      return Text(
                                                                        getString(
                                                                            store.allNotifications),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w400),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (mainStore.authStore.type == 'DOCTOR' ||
                              (mainStore.authStore.type == 'SECRETARY' &&
                                  store.allowed == true)) {
                            mainStore.setShowNav(false);
                            final permitted =
                                await PhotoManager.requestPermission();
                            if (permitted) {
                              setState(() {
                                store.showGalery(true);
                              });
                            }
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
                        child: Container(
                          padding: EdgeInsets.only(
                            left: wXD(12, context),
                            right: wXD(14, context),
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: wXD(23, context),
                          ),
                          height: wXD(41, context),
                          width: wXD(337, context),
                          decoration: BoxDecoration(
                            color: Color(0xfffafafa),
                            border: Border.all(
                                color: Color(0xff707070).withOpacity(.2),
                                width: 1),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(0, 3),
                                color: Color(0x20000000),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Poste uma publicação',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff707070).withOpacity(.6),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Icon(
                                Icons.image,
                                size: wXD(25, context),
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      feedScroll(maxWidth),
                    ],
                  ),
                  newPost(maxHeight, maxWidth),
                  showGalery(maxHeight, maxWidth),
                  deleteDialog(maxHeight, maxWidth),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String getString(int value) {
    print('value: $value');
    if (value > 9) {
      return '+9';
    } else {
      return value.toString();
    }
  }

  Widget deleteDialog(double maxHeight, double maxWidth) {
    return Observer(builder: (context) {
      return Visibility(
        visible: store.deleteDialog,
        child: AnimatedContainer(
          height: maxHeight,
          width: maxWidth,
          color: Color(0x50000000),
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: wXD(5, context)),
              height: wXD(153, context),
              width: wXD(324, context),
              decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  borderRadius: BorderRadius.all(Radius.circular(33))),
              child: Column(
                children: [
                  Container(
                    width: wXD(240, context),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    child: Text(
                      '''Tem certeza que deseja excluir esta publicação?''',
                      style: TextStyle(
                        fontSize: wXD(15, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xfa707070),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          store.setDeleteDialog(!store.deleteDialog);
                        },
                        child: Container(
                          height: wXD(47, context),
                          width: wXD(98, context),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 3,
                                    color: Color(0x28000000))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              border: Border.all(color: Color(0x80707070)),
                              color: Color(0xfffafafa)),
                          alignment: Alignment.center,
                          child: Text(
                            'Não',
                            style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.bold,
                                fontSize: wXD(16, context)),
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          store.setDeleteDialog(!store.deleteDialog);
                          store.deleting(store.postId);
                        },
                        child: Container(
                          height: wXD(47, context),
                          width: wXD(98, context),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 3,
                                    color: Color(0x28000000))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              border: Border.all(color: Color(0x80707070)),
                              color: Color(0xfffafafa)),
                          alignment: Alignment.center,
                          child: Text(
                            'Sim',
                            style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.bold,
                                fontSize: wXD(16, context)),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget showGalery(double maxHeight, double maxWidth) {
    return SingleChildScrollView(
      child: Observer(builder: (context) {
        return Visibility(
          visible: store.galery,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              store.galery = false;
            },
            child: Container(
              height: maxHeight,
              width: maxWidth,
              color: Color(0x50000000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                        color: Color(0xfffafafa),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    margin: EdgeInsets.only(
                      right: wXD(15, context),
                      left: wXD(15, context),
                    ),
                    padding: EdgeInsets.only(
                        left: wXD(15, context),
                        right: wXD(15, context),
                        top: wXD(20, context)),
                    height: store.galery ? maxHeight * 0.85 : 0,
                    width: maxWidth,
                    child: Stack(children: [
                      Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                padding:
                                    EdgeInsets.only(left: wXD(10, context)),
                                margin:
                                    EdgeInsets.only(bottom: wXD(50, context)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: constraints.maxWidth * .40,
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          mainStore.setShowNav(true);

                                          store.showGalery(false);
                                        },
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: constraints.maxWidth * .40,
                                      child: Text(
                                        'Galeria',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: wXD(25, context)),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: store.assets.length,
                          itemBuilder: (_, index) {
                            return AssetThumbnail(
                              asset: store.assets[index],
                              stateSet: () async {
                                store.showGalery(false);
                                imageFile = await store.assets[index].file;
                                store.setImageFile(imageFile);
                                store.setNewPost(true);
                              },
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget newPost(double maxHeight, double maxWidth) {
    return Observer(builder: (context) {
      return Visibility(
        visible: store.newPost,
        child: Container(
          height: maxHeight,
          width: maxWidth,
          color: Color(0x50000000),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xfffafafa),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    )),
                margin: EdgeInsets.only(
                  right: wXD(15, context),
                  left: wXD(15, context),
                ),
                padding: EdgeInsets.only(
                    left: wXD(15, context),
                    right: wXD(15, context),
                    bottom: wXD(20, context),
                    top: wXD(20, context)),
                height: wXD(400, context),
                width: maxWidth,
                child: NewPost(
                  postOrEdit: () async {
                    print('xxxxxxxxxx onTap xxxxxxxxxxxxx');
                    if (store.editPost == null) {
                      await store.toPost();
                      store.setNewPost(false);
                    }

                    if (store.editPost == 'editing') {
                      store.setEditPost('edited');
                      await store.postEditing(store.postId);
                      store.setNewPost(false);
                    }
                  },
                  pickedImage: () {
                    store.setNewPost(false);
                    store.showGalery(true);
                  },
                  canceled: () async {
                    store.editPost = null;
                    store.postText = null;
                    store.imageString = null;
                    store.imageFile = null;
                    store.setPostText(null);
                    store.setNewPost(false);
                    mainStore.setShowNav(true);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget feedScroll(double maxWidth) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .doc(mainStore.authStore.viewDoctorId)
          .collection('feed')
          .where('status', isEqualTo: 'VISIBLE')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshotFeed) {
        if (snapshotFeed.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        if (!snapshotFeed.hasData) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyStateList(
                  image: 'assets/img/pacient_communication.png',
                  title: 'Sem postagens',
                  description:
                      'Adicione uma localização ao seu perfil para começar a disparar suas postagens',
                ),
              ],
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          store.getFeed(snapshotFeed.data);
        });

        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              store.clearFeed();
              store.getHasNext();

              setState(() {});
            },
            child: SingleChildScrollView(
              key: PageStorageKey<String>('feedKey'),
              controller: scrollController,
              child: Observer(builder: (context) {
                if (store.feedList.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyStateList(
                        image: 'assets/img/pacient_communication.png',
                        title: 'Sem postagens',
                        description: 'Não há postagens para serem exibidas',
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Column(
                      children: List.generate(
                        store.feedList.length,
                        (index) {
                          DocumentSnapshot feedDoc = store.feedList[index];

                          String since = store.getTime(feedDoc['created_at']);

                          return FeedCard(
                            timeAgo: since,
                            status: feedDoc['status'],
                            postId: feedDoc['id'],
                            imageUrl: feedDoc['bgr_image'],
                            avatar: feedDoc['dr_avatar'],
                            name: feedDoc['dr_name'],
                            speciality: feedDoc['dr_speciality'],
                            description: feedDoc['text'],
                            likes: feedDoc['like_count'].toString(),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: wXD(20, context),
                    ),
                    store.hasNext
                        ? CircularProgressIndicator()
                        : Container(
                            margin: EdgeInsets.only(
                                top: maxWidth * .04,
                                left: maxWidth * .05,
                                right: maxWidth * .05,
                                bottom: maxWidth * .02),
                            height: wXD(40, context),
                            width: maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(
                                  flex: 5,
                                ),
                                Text(
                                  'Não há mais postagens para mostrar',
                                  style: TextStyle(
                                    fontSize: maxWidth * .04,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff21BCCE),
                                  ),
                                ),
                                Spacer(
                                  flex: 5,
                                ),
                              ],
                            )),
                    SizedBox(
                      height: wXD(20, context),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final Function stateSet;
  const AssetThumbnail({
    Key key,
    @required this.asset,
    this.stateSet,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            stateSet();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: wXD(95, context),
                height: wXD(68, context),
              ),
              Container(
                width: wXD(110, context),
                height: wXD(78, context),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xfffafafa), width: wXD(5, context)),
                    borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ],
          ),
        );
      },
    );
  }
}
