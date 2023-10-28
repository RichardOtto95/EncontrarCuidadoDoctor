import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
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
                            size: maxWidth(context) * 26 / 375,
                            color: Color(0xff707070),
                          ),
                        ),
                      ),
                      Text(
                        'Política de privacidade',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: wXD(20, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('info')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        print(
                            'snapshot: ${snapshot.data.docs[0]['privacy_policy']}');
                        // snapshot.docudata['Terms_of_use'];
                        return SfPdfViewer.network(
                          '${snapshot.data.docs[0]['privacy_policy']}',
                          // canShowScrollStatus: false,
                          canShowScrollHead: false,
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
