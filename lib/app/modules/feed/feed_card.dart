import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'feed_store.dart';

class FeedCard extends StatefulWidget {
  final String name;
  final String status;
  final String postId;
  final String avatar;
  final String speciality;
  final String description;
  final String imageUrl;
  final String timeAgo;
  final String likes;
  final String doctorId;

  const FeedCard({
    Key key,
    this.name,
    this.speciality,
    this.description,
    this.imageUrl,
    this.avatar,
    this.timeAgo,
    this.postId,
    this.status,
    this.likes,
    this.doctorId,
  }) : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _showMenu = false, connected = false;
  final FeedStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Observer(
      builder: (context) {
        return store.feedMapDelete[widget.postId] == null ||
                store.feedMapDelete[widget.postId] == false
            ? Stack(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (_showMenu == true) {
                        setState(() {
                          _showMenu = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: maxWidth * .04,
                          left: maxWidth * .05,
                          right: maxWidth * .05,
                          bottom: maxWidth * .02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 6),
                            child: Row(
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    store.viewDrProfile(context);
                                  },
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(mainStore.authStore.user.uid)
                                            .snapshots(),
                                        builder:
                                            (context, snapshotDoctorConnected) {
                                          if (snapshotDoctorConnected.hasData) {
                                            DocumentSnapshot doctorDoc =
                                                snapshotDoctorConnected.data;
                                            connected = doctorDoc['connected'];
                                          }

                                          return Stack(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: widget
                                                            .avatar ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/img/defaultUser.png')
                                                    : NetworkImage(
                                                        widget.avatar),
                                                backgroundColor: Colors.white,
                                                radius: maxWidth * .06,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 1,
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  height: 13,
                                                  width: 13,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: connected
                                                        ? Color(0xff00B5AA)
                                                        : Colors.red,
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Color(0xfffafafa),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: wXD(240, context),
                                            child: Text(
                                              widget.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: maxWidth * .036,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff484D54),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.speciality == null
                                                    ? 'Médico'
                                                    : widget.speciality,
                                                style: TextStyle(
                                                  fontSize: maxWidth * .036,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff484D54),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                              Text(
                                                widget.timeAgo,
                                                style: TextStyle(
                                                  fontSize: maxWidth * .036,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff787C81),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    if (mainStore.authStore.type == 'DOCTOR' ||
                                        (mainStore.authStore.type ==
                                                'SECRETARY' &&
                                            store.allowed == true)) {
                                      print('ontTAapppp ${widget.postId}');

                                      setState(() {
                                        _showMenu = !_showMenu;
                                      });
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
                                      alignment: Alignment.centerRight,
                                      width: wXD(40, context),
                                      height: wXD(40, context),
                                      child: Icon(Icons.more_vert)),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.width * .9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.imageUrl,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/img/defaultUser.png'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: StreamBuilder<Object>(
                                        stream: FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(mainStore
                                                .authStore.viewDoctorId)
                                            .collection('feed')
                                            .where('id',
                                                isEqualTo: widget.postId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          QuerySnapshot queryPost;
                                          DocumentSnapshot post;
                                          String likes = '0';
                                          if (snapshot.hasData) {
                                            queryPost = snapshot.data;
                                            if (queryPost.docs.isNotEmpty) {
                                              post = queryPost.docs.first;
                                              if (post.get('like_count') !=
                                                  null) {
                                                likes = post
                                                    .get('like_count')
                                                    .toString();
                                              }
                                            }
                                          }

                                          return Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.favorite,
                                                    color: Colors.red[900]),
                                                SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  likes,
                                                  style: TextStyle(
                                                    fontSize: maxWidth * .036,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff484D54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    width: 11,
                                  ),
                                ],
                              )
                              // }),
                              ),
                          ExpandableText(
                            widget.description,
                            style: TextStyle(
                                fontSize: maxWidth * .035,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff484D54)),
                            prefixText: "${widget.name}: ",
                            prefixStyle: TextStyle(
                              fontSize: maxWidth * .036,
                              fontWeight: FontWeight.bold,
                            ),
                            expandText: 'mais',
                            collapseText: 'menos',
                            maxLines: 3,
                            linkEllipsis: false,
                            linkColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: maxWidth * .08,
                    right: maxWidth * .1,
                    child: Container(
                      height: _showMenu ? maxWidth * .18 : 0,
                      width: _showMenu ? maxWidth * .25 : 0,
                      decoration: BoxDecoration(
                        color: Color(0xfffafafa),
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              mainStore.setShowNav(false);

                              setState(() {
                                _showMenu = !_showMenu;
                              });

                              store.setPostId(widget.postId);
                              store.setEditPost('editing');
                              store.setImageString(widget.imageUrl);
                              store.setPostText(widget.description);
                              store.setNewPost(true);
                            },
                            child: Container(
                              width: _showMenu ? maxWidth * .23 : 0,
                              margin: EdgeInsets.symmetric(
                                  vertical: wXD(5, context)),
                              padding: EdgeInsets.only(left: wXD(10, context)),
                              child: Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: _showMenu ? maxWidth * .039 : 0,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _showMenu = !_showMenu;
                              });
                              store.setDeleteDialog(!store.deleteDialog);
                              store.setPostId(widget.postId);
                            },
                            child: Container(
                              width: _showMenu ? maxWidth * .23 : 0,
                              margin: EdgeInsets.symmetric(
                                  vertical: wXD(5, context)),
                              padding: EdgeInsets.only(left: wXD(10, context)),
                              child: Text(
                                'Excluir',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: _showMenu ? maxWidth * .039 : 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                margin: EdgeInsets.only(
                    top: maxWidth * .04,
                    left: maxWidth * .05,
                    right: maxWidth * .05,
                    bottom: maxWidth * .02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                  color: Color(0xffEEEDED),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: 80,
                width: maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                      flex: 5,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff41C3B3),
                      size: maxWidth * .07,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      'Postagem excluída com sucesso',
                      style: TextStyle(
                        fontSize: maxWidth * .04,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff484D54),
                      ),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
