import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'drprofile_store.dart';
import 'widgets/edit_post.dart';
import 'widgets/feed_card_profile.dart';

final DrProfileStore store = Modular.get();
final MainStore mainStore = Modular.get();
String doctorId = '';

class DrProfilePage extends StatefulWidget {
  final DoctorModel doctorModel;

  const DrProfilePage({Key key, this.doctorModel}) : super(key: key);
  @override
  _DrProfilePageState createState() => _DrProfilePageState();
}

class _DrProfilePageState extends State<DrProfilePage> {
  File imageFile;
  int index = 0;
  List<AssetEntity> assets = [];

  @override
  void initState() {
    store.getRatings(widget.doctorModel.id);
    _fetchAssets();
    doctorId = widget.doctorModel.id;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(onWillPop: () async {
          return true;
        }, child: Observer(builder: (_) {
          return Stack(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(mainStore.authStore.user != null
                          ? mainStore.authStore.user.uid
                          : '')
                      .snapshots(),
                  builder: (context, snapshotUser) {
                    return StreamBuilder<Object>(
                        stream: FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(mainStore.authStore.user != null
                                ? mainStore.authStore.user.uid
                                : '')
                            .collection('permissions')
                            .where('label', isEqualTo: 'FEED')
                            .snapshots(),
                        builder: (context, snapermissions) {
                          DocumentSnapshot _user;
                          QuerySnapshot feed;

                          if (!snapshotUser.hasData) {
                            return Container();
                          }
                          if (snapshotUser.hasData) {
                            _user = snapshotUser.data;
                          }
                          if (mainStore.authStore.type == 'SECRETARY') {
                            if (snapermissions.hasData) {
                              feed = snapermissions.data;
                              store.allowed = feed.docs.first.get('value');
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EncontrarCuidadoAppBar(
                                onTap: () {
                                  Modular.to.pop();
                                },
                                title: 'Perfil do médico',
                              ),
                              Perfil(doctorModel: widget.doctorModel),
                              Separator(),
                              MedicDetails(
                                index: index,
                                onTap0: () {
                                  if (index != 0) {
                                    setState(() {
                                      index = 0;
                                    });
                                  }
                                },
                                onTap1: () {
                                  if (index != 1) {
                                    setState(() {
                                      index = 1;
                                    });
                                  }
                                },
                                onTap2: () {
                                  if (index != 2) {
                                    setState(() {
                                      index = 2;
                                    });
                                  }
                                },
                                onTap3: () {
                                  if (index != 3) {
                                    setState(() {
                                      index = 3;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: index == 0
                                    ? RefreshIndicator(
                                        onRefresh: () async {
                                          setState(() {
                                            index = 0;
                                          });
                                        },
                                        child: GestureDetector(
                                            onVerticalDragUpdate: (details) {
                                              if (details.delta.direction < 0) {
                                                mainStore.setShowNav(false);
                                              }
                                              if (details.delta.direction > 0) {
                                                if (store.postEditor == false) {
                                                  mainStore.setShowNav(true);
                                                }
                                              }
                                            },
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Posts())))
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: index == 1
                                            ? Informations(
                                                doctorModel: widget.doctorModel,
                                              )
                                            : index == 2
                                                ? Contact(
                                                    doctorModel:
                                                        widget.doctorModel,
                                                  )
                                                : index == 3
                                                    ? OpinionDetail()
                                                    : Container(),
                                      ),
                              )
                            ],
                          );
                        });
                  }),
              Observer(builder: (context) {
                return Visibility(
                  visible: store.postEditor,
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
                          child: PostEditor(
                            editPost: () async {
                              store.setEditPost('edited');
                              await store.postEditing(store.postId);
                              store.showPostEditor(false);
                            },
                            pickedImage: () {
                              mainStore.setShowNav(false);
                              store.showPostEditor(false);
                              store.showGalery(true);
                            },
                            canceled: () {
                              store.feedDispose();
                              store.setPostText(null);
                              store.showPostEditor(false);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Observer(builder: (context) {
                return SingleChildScrollView(
                  child: Visibility(
                    visible: store.galery,
                    child: Container(
                      height: maxHeight,
                      width: maxWidth,
                      color: Color(0x50000000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
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
                            height: maxHeight * 0.85,
                            width: maxWidth,
                            child: Stack(children: [
                              Column(
                                children: [
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: wXD(10, context)),
                                        margin: EdgeInsets.only(
                                            bottom: wXD(50, context)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: constraints.maxWidth * .40,
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  if (store.postEditor ==
                                                      false) {
                                                    mainStore.setShowNav(true);
                                                  }
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
                                  itemCount: assets.length,
                                  itemBuilder: (_, index) {
                                    return AssetThumbnail(
                                      asset: assets[index],
                                      stateSet: () async {
                                        mainStore.setShowNav(false);
                                        store.showGalery(false);
                                        imageFile = await assets[index].file;
                                        store.setImageFile(imageFile);
                                        store.showPostEditor(true);
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
              Observer(builder: (context) {
                return Visibility(
                  visible: store.deleteDialog,
                  child: AnimatedContainer(
                    height: maxHeight,
                    width: maxWidth,
                    color: !store.deleteDialog
                        ? Colors.transparent
                        : Color(0x50000000),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: wXD(5, context)),
                        height: wXD(153, context),
                        width: wXD(324, context),
                        decoration: BoxDecoration(
                            color: Color(0xfffafafa),
                            borderRadius:
                                BorderRadius.all(Radius.circular(33))),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17)),
                                        border: Border.all(
                                            color: Color(0x80707070)),
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
                                    await store.deletePost(store.postId);
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17)),
                                        border: Border.all(
                                            color: Color(0x80707070)),
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
              })
            ],
          );
        })),
      ),
    );
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    setState(() => assets = recentAssets);
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
        if (!snapshot.hasData) return Container();
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
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

class Posts extends StatelessWidget {
  const Posts({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('feed')
          .where('status', isEqualTo: 'VISIBLE')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshotFeed) {
        if (snapshotFeed.connectionState == ConnectionState.waiting)
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
              ),
              Center(child: CircularProgressIndicator())
            ],
          );

        return snapshotFeed.data.docs.isNotEmpty
            ? Column(
                children: [
                  Column(
                      children:
                          List.generate(snapshotFeed.data.docs.length, (index) {
                    DocumentSnapshot feed = snapshotFeed.data.docs[index];
                    store.mapDeletedPost.putIfAbsent(feed['id'], () => false);
                    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

                    return FeedCardProfile(
                      avatar: feed['dr_avatar'],
                      description: feed['text'],
                      imageUrl: feed['bgr_image'],
                      likes: feed['like_count'].toString(),
                      name: feed['dr_name'],
                      postId: feed['id'],
                      speciality: feed['dr_speciality'],
                      timeAgo: store.getTime(feed['created_at']),
                    );
                  })),
                  SizedBox(
                    height: wXD(80, context),
                  )
                ],
              )
            : Column(
                children: [
                  EmptyStateList(
                    image: 'assets/img/work_on2.png',
                    title: 'Sem postagens',
                    description: 'Sem postagens para serem exibidas',
                  ),
                  SizedBox(height: wXD(80, context)),
                ],
              );
      },
    );
  }
}

class Perfil extends StatelessWidget {
  final DoctorModel doctorModel;

  const Perfil({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: wXD(18, context),
        left: wXD(18, context),
        right: wXD(15, context),
      ),
      width: wXD(375, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: wXD(44, context),
            backgroundImage:
                doctorModel.avatar == null || doctorModel.avatar == ''
                    ? AssetImage('assets/img/defaultUser.png')
                    : NetworkImage(doctorModel.avatar),
          ),
          SizedBox(
            width: wXD(8, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: wXD(10, context),
              ),
              Container(
                width: wXD(245, context),
                child: Text(
                  doctorModel.fullname != null
                      ? doctorModel.fullname
                      : doctorModel.username,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w900,
                    fontSize: wXD(16, context),
                  ),
                ),
              ),
              Text(
                doctorModel.specialityName != null
                    ? doctorModel.specialityName
                    : 'Não informado',
                style: TextStyle(
                  color: Color(0xff484D54),
                  fontWeight: FontWeight.w400,
                  fontSize: wXD(14, context),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'CRM:',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w400,
                    fontSize: wXD(14, context),
                  ),
                ),
                TextSpan(
                  text: doctorModel.crm != null
                      ? doctorModel.crm
                      : 'Não informado',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w300,
                    fontSize: wXD(13, context),
                  ),
                ),
              ])),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'RQE:',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w400,
                    fontSize: wXD(14, context),
                  ),
                ),
                TextSpan(
                  text: doctorModel.rqe != null
                      ? doctorModel.rqe
                      : 'Não informado',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w300,
                    fontSize: wXD(13, context),
                  ),
                ),
              ])),
              Observer(
                builder: (context) {
                  return Row(
                    children: [
                      Text(
                        store.ratingsAverage,
                        style: TextStyle(
                          color: Color(0xff2185D0),
                          fontWeight: FontWeight.w600,
                          fontSize: wXD(12, context),
                        ),
                      ),
                      SizedBox(
                        width: wXD(5, context),
                      ),
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: wXD(20, context),
                        initialRating: double.parse(store.ratingsAverage),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        width: wXD(3, context),
                      ),
                      Text(
                        '${store.ratingsLength} opiniões',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontWeight: FontWeight.w300,
                          fontSize: wXD(13, context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedicDetails extends StatelessWidget {
  final int index;
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;

  const MedicDetails({
    Key key,
    this.index = 0,
    this.onTap0,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(5, context),
      ),
      height: wXD(63, context),
      width: wXD(375, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 3,
            color: Color(0x30000000),
          )
        ],
        color: Color(0xfffafafa),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: wXD(15, context)),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTap0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          width: wXD(94, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Postagens',
                            style: TextStyle(
                              color: index == 0
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: wXD(15, context)),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTap1,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          width: wXD(95, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Informações',
                            style: TextStyle(
                              color: index == 1
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: wXD(15, context)),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTap2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          width: wXD(90, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Contato',
                            style: TextStyle(
                              color: index == 2
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: wXD(15, context)),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTap3,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          width: wXD(90, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Opiniões',
                            style: TextStyle(
                              color: index == 3
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: wXD(15, context)),
                    ],
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      Container(
                        width: wXD(435, context),
                        height: wXD(3, context),
                      ),
                      AnimatedPositioned(
                        bottom: 0,
                        left: index == 0
                            ? wXD(15, context)
                            : index == 1
                                ? wXD(125, context)
                                : index == 2
                                    ? wXD(249, context)
                                    : wXD(351, context),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 300),
                          height: wXD(8, context),
                          width: index == 0
                              ? wXD(94, context)
                              : index == 1
                                  ? wXD(94, context)
                                  : index == 2
                                      ? wXD(59, context)
                                      : wXD(65, context),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                            color: Color(0xff2185d0),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const Separator({
    Key key,
    this.vertical = 0,
    this.horizontal = 25,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      height: wXD(1, context),
      margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
          vertical: wXD(vertical, context)),
      color: Color(0xff707070).withOpacity(.26),
    );
  }
}

class Informations extends StatelessWidget {
  final DoctorModel doctorModel;

  const Informations({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: 'Experiência',
          top: wXD(20, context),
          left: wXD(31, context),
          bottom: wXD(5, context),
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.person_pin,
          title: 'Sobre mim',
        ),
        InfoText(
          title: doctorModel.aboutMe != null
              ? doctorModel.aboutMe
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.business_center,
          title: 'Especialidade',
        ),
        InfoText(
          title: doctorModel.specialityName != null
              ? doctorModel.specialityName
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.school,
          title: 'Formação acadêmica',
        ),
        InfoText(
          title: doctorModel.academicEducation != null
              ? doctorModel.academicEducation
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medical_services,
          title: 'Experiência em:    ',
        ),
        InfoText(
          title: doctorModel.experience != null
              ? doctorModel.experience
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medication_rounded,
          title: 'Tratar condições médicas',
        ),
        InfoText(
          title: doctorModel.medicalConditions != null
              ? doctorModel.medicalConditions
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medical_services,
          title: 'Faixa etária',
        ),
        InfoText(
          title: doctorModel.attendance != null
              ? doctorModel.attendance
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.local_hospital,
          title: 'Clínica',
        ),
        InfoText(
          title: doctorModel.clinicName != null
              ? doctorModel.clinicName
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.language,
          title: 'Idiomas',
        ),
        InfoText(
          title: doctorModel.language != null
              ? doctorModel.language
              : 'Não informado',
        ),
        SizedBox(height: wXD(15, context))
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final double size;
  final double left;
  final double right;
  final double top;
  final double height;
  final Color color;
  final FontWeight weight;

  const InfoText({
    Key key,
    this.title,
    this.size = 15,
    this.left = 40,
    this.right = 20,
    this.top = 10,
    this.height = 1,
    this.color,
    this.weight,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getWeight() {
    FontWeight _weight;
    if (weight == null) {
      _weight = FontWeight.w400;
    } else {
      _weight = weight;
    }
    return _weight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        left: wXD(left, context),
        right: wXD(right, context),
        top: wXD(top, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          height: height,
          color: getColor(),
          fontWeight: getWeight(),
          fontSize: wXD(size, context),
        ),
      ),
    );
  }
}

class Topic extends StatelessWidget {
  final String title;

  const Topic({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        top: wXD(4.5, context),
        bottom: wXD(4.5, context),
        left: wXD(40, context),
        right: wXD(20, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.only(right: wXD(4, context), top: wXD(5, context)),
            height: wXD(6, context),
            width: wXD(6, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff707070),
            ),
          ),
          Container(
            width: wXD(300, context),
            child: Text(
              '$title',
              maxLines: 5,
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InformationTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final double left;
  final Color color;

  const InformationTitle({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.left,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: wXD(22, context),
            color: Color(0xff707070).withOpacity(.8),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Container(
            width: wXD(294, context),
            padding: EdgeInsets.only(top: wXD(2, context)),
            child: Text(
              '$title',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final DoctorModel doctorModel;

  const Contact({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: wXD(20, context),
        ),
        InformationTitle(icon: Icons.phone, title: 'Número de telefone'),
        InfoText(title: getMask(doctorModel.landline, 1)),
        InfoText(title: getMask(doctorModel.phone, 2)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.email, title: 'E-mail'),
        InfoText(
            title: doctorModel.email != null
                ? doctorModel.email.toLowerCase()
                : 'Não informado'),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.phone_android, title: 'Rede Social'),
        InfoText(
            title: doctorModel.social != null
                ? doctorModel.social
                : 'Não informado'),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.pin_drop,
          title: 'Endereço',
        ),
        InfoText(
          title: 'CEP: ' + getMask(doctorModel.cep, 3),
        ),
        InfoText(
          title: doctorModel.state +
              ', ' +
              doctorModel.city +
              ', ' +
              doctorModel.neighborhood +
              ', ' +
              doctorModel.address +
              ', ' +
              doctorModel.numberAddress +
              ', ' +
              doctorModel.complementAddress,
        ),
      ],
    );
  }

  String getMask(String text, int index) {
    String newText;
    switch (index) {
      case 1:
        if (text != null) {
          newText = '+55 ' +
              '(' +
              text.substring(0, 2) +
              ') ' +
              text.substring(2, 6) +
              '-' +
              text.substring(6, 10);
          return newText;
        } else {
          return 'Não informado';
        }
        break;

      case 2:
        if (text != null) {
          newText = text.substring(0, 3) +
              ' (' +
              text.substring(3, 5) +
              ') ' +
              text.substring(5, 10) +
              '-' +
              text.substring(10, 14);
          return newText;
        } else {
          return 'Não informado';
        }
        break;

      case 3:
        if (text != null) {
          newText = text.substring(0, 2) +
              '.' +
              text.substring(2, 5) +
              '-' +
              text.substring(5, 8);
          return newText;
        } else {
          return 'Não informado';
        }
        break;

      default:
        return 'Não informado';
        break;
    }
  }
}

class OpinionDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpinionsType(
              index: index,
              onTap0: () {
                if (index != 0) {
                  setState(() {
                    index = 0;
                  });
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap1: () {
                if (index != 1) {
                  setState(() {
                    index = 1;
                  });
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap2: () {
                if (index != 2) {
                  setState(() {
                    index = 2;
                  });
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap3: () {
                if (index != 3) {
                  setState(() {
                    index = 3;
                  });
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
            ),
            Opinions(
              index: index,
            ),
          ],
        );
      },
    );
  }
}

class Opinions extends StatelessWidget {
  final int index;
  const Opinions({
    Key key,
    this.index,
  }) : super(key: key);

  String getText() {
    if (index != 0) {
      if (index == 1) return ' positivas';

      if (index == 2) return ' neutras';

      if (index == 3) return ' negativas';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(doctorId)
              .collection('ratings')
              .where('status', isEqualTo: 'VISIBLE')
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshotRatings) {
            if (!snapshotRatings.hasData) {
              return Row(
                children: [
                  Spacer(),
                  CircularProgressIndicator(),
                  Spacer(),
                ],
              );
            } else {
              store.getOpinions(
                querySnapshot: snapshotRatings.data,
                index: index,
              );
              return Observer(
                builder: (context) {
                  // if (store.listRatings == null) {
                  //   return Row(
                  //     children: [
                  //       Spacer(),
                  //       CircularProgressIndicator(),
                  //       Spacer(),
                  //     ],
                  //   );
                  // }

                  if (store.listRatings.isEmpty || store.listRatings == null) {
                    return EmptyStateList(
                      image: 'assets/img/work_on2.png',
                      title: 'Sem avaliações ${getText()}',
                      description:
                          'Sem avaliações ${getText()} para serem exibidas',
                    );
                  }

                  return Column(children: [
                    Column(
                      children: List.generate(
                        store.listRatings.length,
                        (i) {
                          var ref = store.listRatings[i];
                          return Opinion(
                            avaliation: ref['avaliation'].toDouble(),
                            date: ref['created_at'],
                            photo: ref['photo'],
                            text: ref['text'],
                            username: ref['username'],
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: store.moreReviews,
                      child: Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              store.getMoreOpinion();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: wXD(15, context),
                              bottom: wXD(25, context),
                            ),
                            height: wXD(35, context),
                            width: wXD(127, context),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              border: Border.all(
                                  color: Color(0xff707070).withOpacity(.3)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                  color: Color(0x30000000),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ver mais',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff2185d0),
                                fontWeight: FontWeight.w500,
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
              );
            }
          },
        );
      },
    );
  }
}

class Opinion extends StatelessWidget {
  final String photo;
  final String username;
  final Timestamp date;
  final num avaliation;
  final String text;

  const Opinion({
    Key key,
    this.photo,
    this.username,
    this.date,
    this.avaliation,
    this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: wXD(6, context),
              left: wXD(18, context),
              right: wXD(34, context),
              bottom: wXD(8, context),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: photo != null
                      ? NetworkImage(photo)
                      : AssetImage('assets/img/defaultUser.png'),
                  backgroundColor: Colors.white,
                  radius: wXD(19.5, context),
                ),
                Container(
                  width: wXD(184, context),
                  padding: EdgeInsets.symmetric(horizontal: wXD(6, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$username',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w500,
                          fontSize: wXD(14, context),
                        ),
                      ),
                      SizedBox(
                        height: wXD(3, context),
                      ),
                      Text(
                        store.converterDateToString(date),
                        style: TextStyle(
                          color: Color(0xff787C81),
                          fontWeight: FontWeight.w700,
                          fontSize: wXD(10, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: wXD(20, context),
                  initialRating: avaliation.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
          Container(
            width: wXD(375, context),
            padding: EdgeInsets.only(
              left: wXD(50, context),
              right: wXD(22, context),
            ),
            child: Text(
              '$text',
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(15, context),
              ),
            ),
          ),
          Separator(
            vertical: wXD(7, context),
          ),
        ],
      ),
    );
  }
}

class OpinionsType extends StatelessWidget {
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;
  final int index;

  const OpinionsType({
    Key key,
    this.onTap0,
    this.onTap1,
    this.onTap2,
    this.onTap3,
    this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(wXD(10, context), wXD(10, context),
            wXD(10, context), wXD(0, context)),
        height: wXD(36, context),
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints2) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Color(0xff707070).withOpacity(.3),
                      width: 2,
                    )),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: onTap0,
                            child: Container(
                              alignment: Alignment.center,
                              width: constraints2.maxWidth * .22,
                              height: wXD(33, context),
                              child: Text(
                                'Todas',
                                style: TextStyle(
                                  color: index == 0
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                  fontWeight: FontWeight.w700,
                                  fontSize: wXD(15, context),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: onTap1,
                            child: Container(
                              alignment: Alignment.center,
                              width: constraints2.maxWidth * .25,
                              height: wXD(33, context),
                              child: Text(
                                'Positivas',
                                style: TextStyle(
                                  color: index == 1
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                  fontWeight: FontWeight.w700,
                                  fontSize: wXD(15, context),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: onTap2,
                            child: Container(
                              alignment: Alignment.center,
                              width: constraints2.maxWidth * .23,
                              height: wXD(33, context),
                              child: Text(
                                'Neutras',
                                style: TextStyle(
                                  color: index == 2
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                  fontWeight: FontWeight.w700,
                                  fontSize: wXD(15, context),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: onTap3,
                            child: Container(
                              alignment: Alignment.center,
                              width: constraints2.maxWidth * .3,
                              height: wXD(33, context),
                              child: Text(
                                'Negativas',
                                style: TextStyle(
                                  color: index == 3
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                  fontWeight: FontWeight.w700,
                                  fontSize: wXD(15, context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  bottom: 0,
                  left: index == 0
                      ? 0
                      : index == 1
                          ? constraints2.maxWidth * .22
                          : index == 2
                              ? constraints2.maxWidth * .47
                              : constraints2.maxWidth * .70,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 300),
                    height: 2,
                    width: index == 0
                        ? constraints2.maxWidth * .22
                        : index == 1
                            ? constraints2.maxWidth * .25
                            : index == 2
                                ? constraints2.maxWidth * .23
                                : constraints2.maxWidth * .30,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                      color: Color(0xff2185d0),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
