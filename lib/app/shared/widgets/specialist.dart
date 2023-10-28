import 'package:flutter/material.dart';
import 'schedule_appointment.dart';

class Specialist extends StatefulWidget {
  final String name;
  final String workLocate;
  final String specialtie;
  final String note;
  final String avatar;
  final String opinions;
  final String price;

  const Specialist({
    Key key,
    this.name,
    this.workLocate,
    this.specialtie,
    this.note,
    this.avatar = '',
    this.opinions,
    this.price,
  }) : super(key: key);

  @override
  _SpecialistState createState() => _SpecialistState();
}

class _SpecialistState extends State<Specialist> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        bottom: wXD(10, context),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: wXD(20, context), vertical: wXD(9, context)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff707070).withOpacity(.4),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: wXD(30, context),
                backgroundImage: widget.avatar == ''
                    ? AssetImage('assets/img/defaltUser.png')
                    : NetworkImage(widget.avatar),
              ),
              Container(
                width: maxWidth * .7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: wXD(3, context),
                        left: wXD(5, context),
                      ),
                      child: Text(
                        '${widget.name}',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontSize: wXD(16, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: wXD(8, context),
                        top: wXD(2, context),
                        bottom: wXD(2, context),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.specialtie}',
                            style: TextStyle(
                              color: Color(0xff484D54),
                              fontSize: wXD(14, context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: wXD(5, context),
                              right: wXD(5, context),
                              bottom: wXD(3.5, context),
                            ),
                            height: wXD(6, context),
                            width: wXD(6, context),
                            decoration: BoxDecoration(
                                color: Color(0xff484D54),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                          Text(
                            '${widget.workLocate}',
                            style: TextStyle(
                              color: Color(0xff484D54),
                              fontSize: wXD(14, context),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: Color(0xffFBBD08),
                            size: wXD(20, context),
                          ),
                          Text(
                            '${widget.note}',
                            style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '  ${widget.opinions} opiniões',
                            style: TextStyle(
                              color: Color(0xff787C81),
                              fontSize: wXD(14, context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: wXD(10, context)),
                height: wXD(42, context),
                width: wXD(85, context),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff41C3B3), width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff41C3B3),
                          Color(0xff21BCCE),
                        ])),
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ScheduleAppointment())),
                  child: Text(
                    'Agendar',
                    style: TextStyle(
                      color: Color(0xfffafafa),
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    show = !show;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: wXD(10, context),
                    left: wXD(18, context),
                    right: wXD(3, context),
                  ),
                  height: wXD(42, context),
                  width: wXD(85, context),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff41C3B3), width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            show == false
                                ? Color(0xff41C3B3)
                                : Colors.transparent,
                            show == false
                                ? Color(0xff21BCCE)
                                : Colors.transparent,
                          ])),
                  alignment: Alignment.center,
                  child: Text(show == false ? 'Preço' : '${widget.price}',
                      style: TextStyle(
                        color: show == false
                            ? Color(0xfffafafa)
                            : Color(0xff787C81),
                        fontSize: wXD(15, context),
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
