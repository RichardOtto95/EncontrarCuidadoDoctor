import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/ratings/ratings_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../shared/utilities.dart';

final RatingsStore store = Modular.get();
final MainStore mainStore = Modular.get();
int index = 0;
bool report = false;

class RatingsPage extends StatefulWidget {
  const RatingsPage({
    Key key,
  }) : super(key: key);
  @override
  RatingsPageState createState() => RatingsPageState();
}

class RatingsPageState extends State<RatingsPage> {
  @override
  void initState() {
    // store.listRatings = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double scrennHeight =
        size.height - MediaQuery.of(context).padding.top - (size.width * .184);

    return WillPopScope(
      onWillPop: () async {
        store.back();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfffafafa),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              EncontrarCuidadoAppBar(
                  title: 'Avaliações',
                  onTap: () {
                    store.back();
                    Modular.to.pop();
                  }),
              Container(
                padding: EdgeInsets.only(
                  top: wXD(20, context),
                  right: wXD(20, context),
                  left: wXD(20, context),
                ),
                width: size.width,
                height: scrennHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MedicDetails(
                      index: index,
                      onTap0: () {
                        setState(() {
                          if (index != 0) {
                            index = 0;
                            store.limit = 5;
                            store.moreReviews = true;
                          }
                        });
                      },
                      onTap1: () {
                        setState(() {
                          if (index != 1) {
                            index = 1;
                            store.limit = 5;
                            store.moreReviews = true;
                          }
                        });
                      },
                      onTap2: () {
                        setState(() {
                          if (index != 2) {
                            index = 2;
                            store.limit = 5;
                            store.moreReviews = true;
                          }
                        });
                      },
                      onTap3: () {
                        setState(() {
                          if (index != 3) {
                            index = 3;
                            store.limit = 5;
                            store.moreReviews = true;
                          }
                        });
                      },
                    ),
                    Opinions(
                      index: index,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: wXD(65, context),
              width: constraints.maxWidth,
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
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Minhas avaliações',
                      style: TextStyle(
                          color: Color(0xff41C3B3),
                          fontSize: wXD(19, context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: onTap0,
                        child: Container(
                          alignment: Alignment.center,
                          width: constraints.maxWidth * .22,
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
                        onTap: onTap1,
                        child: Container(
                          alignment: Alignment.center,
                          width: constraints.maxWidth * .25,
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
                        onTap: onTap2,
                        child: Container(
                          alignment: Alignment.center,
                          width: constraints.maxWidth * .23,
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
                        onTap: onTap3,
                        child: Container(
                          alignment: Alignment.center,
                          width: constraints.maxWidth * .3,
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
                      ? constraints.maxWidth * .22
                      : index == 2
                          ? constraints.maxWidth * .47
                          : constraints.maxWidth * .70,
              curve: Curves.ease,
              duration: Duration(milliseconds: 300),
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: Duration(milliseconds: 300),
                height: 2,
                width: index == 0
                    ? constraints.maxWidth * .22
                    : index == 1
                        ? constraints.maxWidth * .25
                        : index == 2
                            ? constraints.maxWidth * .23
                            : constraints.maxWidth * .30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  color: Color(0xff2185d0),
                ),
              ),
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
    this.index = 0,
  }) : super(key: key);

  String getText(int index) {
    switch (index) {
      case 0:
        return '';
        break;
      case 1:
        return 'positivas ';
        break;
      case 2:
        return 'neutras ';
        break;
      case 3:
        return 'negativas ';
        break;
      default:
        return '';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'mainStore.viewDoctorId ============================: ${mainStore.authStore.viewDoctorId}');
    return Observer(builder: (context) {
      return Expanded(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.only(top: 15),
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(mainStore.authStore.viewDoctorId)
                      .collection('ratings')
                      .where('status', isEqualTo: 'VISIBLE')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshotRatings) {
                    if (snapshotRatings.hasData) {
                      store.getOpinions(
                          index: index, querySnapshot: snapshotRatings.data);
                    }

                    return Observer(
                      builder: (context) {
                        if (store.listRatings == null) {
                          return Column(
                            children: [
                              CircularProgressIndicator(),
                            ],
                          );
                        }

                        if (store.listRatings.isEmpty) {
                          return EmptyStateList(
                            image: 'assets/img/work_on2.png',
                            title: 'Sem avaliações ${getText(index)}',
                            description:
                                'Sem avaliações ${getText(index)}para serem exibidas',
                          );
                        }

                        return Column(children: [
                          Column(
                            children: List.generate(
                              store.listRatings.length,
                              (i) {
                                var ref = store.listRatings[i];
                                return Opinion(
                                  id: ref['id'],
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
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
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
                                        color:
                                            Color(0xff707070).withOpacity(.3)),
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
                  },
                );
              }),
            ),
          );
        }),
      );
    });
  }
}

class Opinion extends StatelessWidget {
  final String photo;
  final String username;
  final Timestamp date;
  final double avaliation;
  final String text, id;

  const Opinion({
    Key key,
    this.photo,
    this.username,
    this.date,
    this.avaliation,
    this.text,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StatefulBuilder(
          builder: (context, setState) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  report = false;
                });
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: photo != null
                                  ? NetworkImage(photo)
                                  : AssetImage('assets/img/defaultUser.png'),
                              backgroundColor: Colors.white,
                              radius: wXD(19.5, context),
                            ),
                            Container(
                              width: wXD(145, context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: wXD(6, context)),
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
                              initialRating: avaliation,
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
                            Spacer(),
                            IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  setState(() {
                                    report = !report;
                                  });
                                }),
                          ],
                        ),
                        Container(
                          width: constraints.maxWidth,
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
                      ],
                    ),
                  ),
                  Positioned(
                      top: wXD(15, context),
                      right: wXD(25, context),
                      child: Visibility(
                        visible: report,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              report = false;
                            });
                            store.reportRating(id);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: wXD(130, context),
                            height: wXD(30, context),
                            decoration: BoxDecoration(
                              color: Color(0XFFFAFAFA),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              'Reportar avaliação',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
