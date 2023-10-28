import 'package:flutter/material.dart';
import '../utilities.dart';
import 'encontrar_cuidado._app_bar.dart';

class ScheduleAppointment extends StatefulWidget {
  final String avatar;

  const ScheduleAppointment({
    Key key,
    this.avatar =
        'https://firebasestorage.googleapis.com/v0/b/ayou-4d78d.appspot.com/o/user%2FUMItaLegFxbqzRaXjKVBLfMjpof1%2Favatar?alt=media&token=34801b65-9ee8-4935-a1dc-d588f089bd19',
  }) : super(key: key);
  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  int type = 1;
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EncontrarCuidadoAppBar(title: 'Agendar consulta'),

            Container(
              padding: EdgeInsets.only(
                bottom: wXD(14, context),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: wXD(20, context), vertical: wXD(12, context)),
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
                                'Dra. Ariel Sousa Freitas',
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
                                    'Pediatra',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                  Text(
                                    'Clínica amor e saúde',
                                    style: TextStyle(
                                      color: Color(0xff484D54),
                                      fontSize: wXD(14, context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: Color(0xffFBBD08),
                                  size: wXD(20, context),
                                ),
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                      color: Color(0xff2185D0),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '  252 opiniões',
                                  style: TextStyle(
                                    color: Color(0xff787C81),
                                    fontSize: wXD(14, context),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: wXD(12, context)),
              height: wXD(42, context),
              decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Color(0x20000000),
                    )
                  ],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(25))),
              alignment: Alignment.center,
              child: Text(
                'Calendário',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: wXD(20, context),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: maxWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: wXD(17, context), vertical: wXD(15, context)),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: wXD(2, context)),
                    height: wXD(27, context),
                    width: wXD(27, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Color(0xff41C3B3),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xfffafafa),
                      size: wXD(16, context),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Seg',
                      ),
                      SizedBox(
                        height: wXD(3, context),
                      ),
                      Text('01 Mar', style: TextStyle(color: Color(0xff787C81)))
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Ter',
                      ),
                      SizedBox(
                        height: wXD(3, context),
                      ),
                      Text('02 Mar', style: TextStyle(color: Color(0xff787C81)))
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Qua',
                      ),
                      SizedBox(
                        height: wXD(3, context),
                      ),
                      Text('03 Mar', style: TextStyle(color: Color(0xff787C81)))
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      if (type == 1) {
                        setState(() {
                          type = 2;
                        });
                      } else if (type == 2) {
                        setState(() {
                          type = 3;
                        });
                      } else if (type == 3) {
                        setState(() {
                          type = 1;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: wXD(1, context)),
                      height: wXD(27, context),
                      width: wXD(27, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Color(0xff41C3B3),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xfffafafa),
                        size: wXD(16, context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(25, context)),
              height: wXD(1, context),
              color: Color(0xff707070).withOpacity(.4),
            ),

            // Container(child: CarouselSlider())
            type == 1 || type == 2
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      wXD(27, context),
                      wXD(13, context),
                      wXD(27, context),
                      wXD(13, context),
                    ),
                    child: Text(
                      'Horários disponíveis',
                      style: TextStyle(
                        color: Color(0xff787C81),
                        fontSize: wXD(13, context),
                      ),
                    ),
                  )
                : Container(),
            type == 1
                ? Expanded(
                    child: AvailableTimes(
                      times1: [
                        '08:00',
                        '08:30',
                        '09:00',
                        '09:30',
                        '10:00',
                        '10:30',
                        '11:00',
                        '11:30',
                        '12:00',
                        '12:30',
                        '13:00',
                        '13:30',
                        '14:00',
                        '14:30',
                        '15:00',
                        '15:30',
                        '16:00',
                        '16:30',
                        '17:00',
                        '17:30',
                        '18:00',
                        '18:30',
                      ],
                    ),
                  )
                : type == 2
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Periods(),
                              SizedBox(
                                width: wXD(35, context),
                              ),
                              Periods(),
                              SizedBox(
                                width: wXD(35, context),
                              ),
                              Periods(),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: wXD(85, context)),
                          child: Column(
                            children: [
                              Text('Próximo dia disponível:'),
                              Text('25 Mar, 10:00'),
                              Container(
                                margin: EdgeInsets.only(top: wXD(50, context)),
                                height: wXD(38, context),
                                width: wXD(260, context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff41C3B3),
                                      Color(0xff21BCCE),
                                    ],
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Mostar horas disponíveis',
                                      style: TextStyle(
                                          color: Color(0xfffafafa),
                                          fontSize: wXD(16, context)),
                                    ),
                                    SizedBox(
                                      width: wXD(10, context),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: wXD(18, context),
                                      color: Color(0xfffafafa),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class AvailableTimes extends StatefulWidget {
  final List times1;

  const AvailableTimes({
    Key key,
    this.times1,
  }) : super(key: key);
  @override
  _AvailableTimesState createState() => _AvailableTimesState();
}

class _AvailableTimesState extends State<AvailableTimes> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.times1.length,
      itemBuilder: (context, index) {
        // var x = index * 2;
        // var y = x + 1;
        String time1 = widget.times1[index];
        String time2 = widget.times1[index];
        return Row(
          children: [
            Spacer(
              flex: 5,
            ),
            Container(
              margin: EdgeInsets.only(bottom: wXD(15, context)),
              height: wXD(30, context),
              width: wXD(71, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: Color(0xff41C3B3)),
              ),
              alignment: Alignment.center,
              child: Text('$time1',
                  style: TextStyle(
                    color: Color(0xff41c3b3),
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Spacer(
              flex: 6,
            ),
            Text('-'),
            Spacer(
              flex: 6,
            ),
            Container(
              margin: EdgeInsets.only(bottom: wXD(15, context)),
              height: wXD(30, context),
              width: wXD(71, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: Color(0xff41C3B3)),
              ),
              alignment: Alignment.center,
              child: Text('$time2',
                  style: TextStyle(
                    color: Color(0xff41c3b3),
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Spacer(
              flex: 5,
            ),
          ],
        );
      },
    );
  }
}

class Periods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Period(
          begin: '08:00',
          end: '12:00',
        ),
        Period(
          begin: '12:00',
          end: '18:00',
        ),
        Period(
          begin: '18:00',
          end: '22:00',
        )
      ],
    );
  }
}

class Period extends StatelessWidget {
  final String begin;
  final String end;

  const Period({
    Key key,
    this.begin,
    this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: wXD(15, context)),
      height: wXD(105, context),
      width: wXD(71, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        border: Border.all(width: 2, color: Color(0xff41C3B3)),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Noite',
            style: TextStyle(
              color: Color(0xff41c3b3),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '$begin',
            style: TextStyle(
              color: Color(0xff41c3b3),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'às',
            style: TextStyle(
              color: Color(0xff41c3b3),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$end',
            style: TextStyle(
              color: Color(0xff41c3b3),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
