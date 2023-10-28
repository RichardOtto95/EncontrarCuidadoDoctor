import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EncontrarCuidadoNavigator extends StatefulWidget {
  @required
  final bool show;
  final bool homePage;
  final bool specialtiePage;
  final bool messagePage;
  final bool searchPage;

  const EncontrarCuidadoNavigator({
    Key key,
    this.show = true,
    this.homePage = false,
    this.specialtiePage = false,
    this.messagePage = false,
    this.searchPage = false,
  }) : super(key: key);
  @override
  _EncontrarCuidadoNavigatorState createState() =>
      _EncontrarCuidadoNavigatorState();
}

class _EncontrarCuidadoNavigatorState extends State<EncontrarCuidadoNavigator> {
  final MainStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
      height: widget.show ? maxWidth * 66 / 375 : 0,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EncontrarCuidadoTile(
            ontap: () {
              setState(() {
                store.setSelectedTrunk(0);
              });
              print(
                  'store.selectedTrunkstore.selectedTrunk${store.selectedTrunk}');
            },
            icon: Icons.home_outlined,
            title: 'Início',
            thisPage: widget.homePage,
          ),
          EncontrarCuidadoTile(
            ontap: () {
              setState(() {
                store.setSelectedTrunk(1);
              });
              print(
                  'store.selectedTrunkstore.selectedTrunk${store.selectedTrunk}');
            },
            icon: Icons.medical_services_outlined,
            title: 'Especialidades',
            thisPage: widget.specialtiePage,
          ),
          Spacer(),
          EncontrarCuidadoTile(
            ontap: () {
              setState(() {
                store.setSelectedTrunk(3);
              });
              print(
                  'store.selectedTrunkstore.selectedTrunk${store.selectedTrunk}');
            },
            icon: Icons.messenger_outline,
            title: 'Mensagens',
            thisPage: widget.messagePage,
          ),
          EncontrarCuidadoTile(
            ontap: () {
              setState(() {
                store.setSelectedTrunk(4);
              });
              print(
                  'store.selectedTrunkstore.selectedTrunk${store.selectedTrunk}');
            },
            icon: Icons.search,
            title: 'Pesquisar',
            thisPage: widget.searchPage,
          ),
        ],
      ),
    );
  }
}

class EncontrarCuidadoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool thisPage;
  final Function ontap;

  const EncontrarCuidadoTile({
    Key key,
    @required this.icon,
    @required this.title,
    this.thisPage = false,
    this.ontap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.decelerate,
      height: maxWidth * 66 / 375,
      width: maxWidth * .22,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: ontap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              size: maxWidth * 30 / 375,
              color: Color(0xff434b56).withOpacity(.9),
            ),
            SizedBox(
              height: maxWidth * 2 / 375,
            ),
            Text(
              title,
              style:
                  TextStyle(color: Colors.grey, fontSize: maxWidth * 11 / 375),
            ),
            SizedBox(
              height: maxWidth * 5 / 375,
            ),
            Container(
              height: maxWidth * 2 / 375,
              width: maxWidth * .1813,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  color: thisPage ? Color(0xff2185D0) : Colors.transparent),
            )
          ],
        ),
      ),
    );
  }
}
