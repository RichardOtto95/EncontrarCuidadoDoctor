import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ConsultationsModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ConsultationsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ConsultationsPage()),
  ];

  @override
  Widget get view => ConsultationsPage();
}
