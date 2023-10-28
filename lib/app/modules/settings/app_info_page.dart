import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppInfo extends StatefulWidget {
  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EncontrarCuidadoNavBar(
                  leading: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: wXD(11, context), right: wXD(11, context)),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: maxWidth * 26 / 375,
                            color: Color(0xff707070),
                          ),
                        ),
                      ),
                      Text(
                        'Informações do app',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: wXD(20, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: wXD(19, context), left: 10, bottom: 6),
                          child: Text(
                            'Lorem Ipsum lorem ipsum',
                            style: TextStyle(
                                color: Color(0xff41C3B3),
                                fontSize: maxWidth * 25 / 375,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: wXD(8, context)),
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: maxWidth * 14 / 375,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                      text:
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum when an unknown printer took a galley of typeand scrambled it to make a type specimen book. \n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                                ]),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Link(
                          icon: FontAwesomeIcons.facebookSquare,
                          name: "Facebook",
                          description: "facebook.com.br",
                        ),
                        Link(
                          icon: FontAwesomeIcons.instagram,
                          name: "Instagram",
                          description: "Instagram.com.br",
                        ),
                        Link(
                          icon: FontAwesomeIcons.twitter,
                          name: "Twitter",
                          description: "Twitter.com.br",
                        ),
                        Link(
                          icon: FontAwesomeIcons.youtube,
                          name: "YouTube",
                          description: "YouTube.com.br",
                        ),
                        Link(
                          icon: FontAwesomeIcons.linkedin,
                          name: "Linkedin",
                          description: "facebook.com.br",
                        ),
                      ],
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

class Link extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;

  const Link({Key key, this.icon, this.name, this.description})
      : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: wXD(15, context)),
              child: IconButton(icon: FaIcon(icon), onPressed: () {}),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: wXD(
                    1,
                    context,
                  )),
                  child: Text(
                    '$name',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: maxWidth * 13 / 375,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '$description',
                    style: TextStyle(
                        color: Color(0xff41C3B3),
                        fontSize: maxWidth * 13 / 375,
                        fontWeight: FontWeight.w800),
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
