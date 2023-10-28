import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'settings_store.dart';

class TermsOfUsagePage extends StatefulWidget {
  @override
  _TermsOfUsagePageState createState() => _TermsOfUsagePageState();
}

class _TermsOfUsagePageState extends State<TermsOfUsagePage> {
  final SettingsStore store = Modular.get();
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
                        'Termos de uso',
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
                            'snapshot: ${snapshot.data.docs[0]['Terms_of_use']}');
                        // snapshot.docudata['Terms_of_use'];
                        return SfPdfViewer.network(
                          '${snapshot.data.docs[0]['Terms_of_use']}',
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
// import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
// import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
// import 'package:flutter/material.dart';

// class TermsOfUsagePage extends StatefulWidget {
//   @override
//   _TermsOfUsagePageState createState() => _TermsOfUsagePageState();
// }

// class _TermsOfUsagePageState extends State<TermsOfUsagePage> {
//   @override
//   Widget build(BuildContext context) {
//     double maxWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 EncontrarCuidadoNavBar(
//                   leading: Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: wXD(11, context), right: wXD(11, context)),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Icon(
//                             Icons.arrow_back_ios_outlined,
//                             size: maxWidth * 26 / 375,
//                             color: Color(0xff707070),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         'Termos de uso',
//                         style: TextStyle(
//                           color: Color(0xff707070),
//                           fontSize: wXD(20, context),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           padding:
//                               EdgeInsets.only(top: wXD(19, context), left: 10),
//                           child: Text(
//                             'Termos e Condições',
//                             style: TextStyle(
//                                 color: Color(0xff41C3B3),
//                                 fontSize: maxWidth * 25 / 375,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(top: wXD(8, context)),
//                           margin: EdgeInsets.symmetric(horizontal: 30),
//                           child: RichText(
//                             text: TextSpan(
//                                 style: TextStyle(
//                                     color: Color(0xff707070),
//                                     fontSize: maxWidth * 14 / 375,
//                                     fontWeight: FontWeight.w400),
//                                 children: [
//                                   TextSpan(
//                                       text:
//                                           "Por favor, leia com atenção os termos e condições. Ao se cadastrar no"),
//                                   TextSpan(
//                                       text: " EncontrarCuidado ",
//                                       style:
//                                           TextStyle(color: Color(0xff41C3B3))),
//                                   TextSpan(
//                                       text:
//                                           "  você está de acordo com as condições e termos do Aplicativo."),
//                                 ]),
//                             textAlign: TextAlign.justify,
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 30),
//                           alignment: Alignment.bottomLeft,
//                           padding: EdgeInsets.only(
//                               top: wXD(8, context), left: wXD(1, context)),
//                           child: Text(
//                             'Lorem Ipsum',
//                             style: TextStyle(
//                                 color: Color(0xff41C3B3),
//                                 fontSize: maxWidth * 25 / 375,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(top: wXD(8, context)),
//                           margin: EdgeInsets.symmetric(horizontal: 30),
//                           child: RichText(
//                             text: TextSpan(
//                                 style: TextStyle(
//                                     color: Color(0xff707070),
//                                     fontSize: maxWidth * 14 / 375,
//                                     fontWeight: FontWeight.w400),
//                                 children: [
//                                   TextSpan(
//                                       text:
//                                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum when an unknown printer took a galley of typeand scrambled it to make a type specimen book. \n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged including versions of Lorem Ipsum. \n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum when an unknown printer took a galley of typeand scrambled it to make a type specimen book. \n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500slike Aldus PageMaker including versions of Lorem Ipsum."),
//                                 ]),
//                             textAlign: TextAlign.justify,
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           alignment: Alignment.bottomLeft,
//                           padding: EdgeInsets.only(
//                               top: wXD(10, context), left: 15, bottom: 30),
//                           child: Text(
//                             'Última atualização: 15 de março de 2021',
//                             style: TextStyle(
//                                 color: Color(0xff41C3B3),
//                                 fontSize: maxWidth * 14 / 375,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
