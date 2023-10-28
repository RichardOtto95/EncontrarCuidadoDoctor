import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class SearchAddPatient extends StatefulWidget {
  @override
  _SearchAddPatient createState() => _SearchAddPatient();
}

class _SearchAddPatient extends State<SearchAddPatient> {
  final ScheduleStore store = Modular.get();
  final FocusNode focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          Duration(seconds: 1),
          () => store.snapScrollController.animateTo(
              store.snapScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease),
        );
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height),
          link: this._layerLink,
          child: Material(
            color: Colors.transparent,
            child: SecretariesSuggestions(
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: wXD(16, context)),
          width: wXD(337, context),
          height: wXD(41, context),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff707070).withOpacity(.5),
              ),
              borderRadius: BorderRadius.all(Radius.circular(17))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: wXD(337, context),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: focusNode,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Busque pelo telefone ou CPF',
                      hintStyle: TextStyle(
                          color: Color(0xff707070).withOpacity(.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  onChanged: (text) => store.searchPatient(text),
                ),
              ),
              Positioned(
                right: wXD(27, context),
                child: Icon(
                  Icons.search,
                  size: wXD(25, context),
                  color: Color(0xff707070).withOpacity(.6),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecretariesSuggestions extends StatelessWidget {
  final ScheduleStore store = Modular.get();
  final FocusNode focusNode;
  SecretariesSuggestions({
    Key key,
    this.focusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
        padding: EdgeInsets.only(
          left: wXD(14, context),
          right: wXD(14, context),
          top: wXD(9, context),
        ),
        width: wXD(307, context),
        height: wXD(store.searchAddPatientHeight, context),
        decoration: BoxDecoration(
          color: Color(0xfffafafa),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Color(0x30000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .where('status', isEqualTo: 'ACTIVE')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      ObservableList<PatientModel> _patients =
                          <PatientModel>[].asObservable();
                      QuerySnapshot qs = snapshot.data;
                      // print(qs.docs.first.data());
                      qs.docs.forEach((element) {
                        // Map<String, dynamic> map = element.data();

                        // print(map['username']);
                        PatientModel _patient =
                            PatientModel.fromDocument(element);
                        _patients.add(_patient);
                      });

                      store.setPatients(_patients);
                      return Observer(builder: (context) {
                        print(
                            'overlay height: ${store.searchAddPatientHeight}');
                        return Column(
                          children: store.patientSearchKey == ''
                              ? []
                              : store.patientsSearched.isNotEmpty
                                  ? List.generate(
                                      store.patientsSearched.length,
                                      (index) => InkWell(
                                        child: SecretarieSuggestion(
                                          onTap: () {
                                            store.setPatientSelected(
                                                store.patientsSearched[index]);
                                            focusNode.unfocus();
                                          },
                                          patient:
                                              store.patientsSearched[index],
                                        ),
                                      ),
                                    )
                                  : [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: wXD(20, context)),
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Sem pacientes com este número ou cpf'),
                                      ),
                                    ],
                        );
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SecretarieSuggestion extends StatelessWidget {
  final PatientModel patient;
  final Function onTap;
  final ScheduleStore store = Modular.get();

  SecretarieSuggestion({Key key, this.onTap, this.patient}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('patient.avatar: ${patient.avatar}');
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: wXD(8, context)),
        width: wXD(300, context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: patient.avatar == null
                  ? Image.asset(
                      'assets/img/defaultUser.png',
                      height: wXD(40, context),
                      width: wXD(40, context),
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: patient.avatar,
                      width: wXD(40, context),
                      height: wXD(40, context),
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: wXD(10, context)),
            Container(
              width: wXD(200, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${patient.username ?? patient.fullname}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Telefone: ${patient.phone}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff707070).withOpacity(.5),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'CPF: ${cpfMasked(patient.cpf)}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff707070).withOpacity(.5),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
