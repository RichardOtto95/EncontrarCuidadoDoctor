import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'patient_profile_page.dart';
import 'patient_profile_store.dart';

class PatientProfileModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PatientProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => PatientProfilePage()),
  ];

  @override
  Widget get view => PatientProfileModule();
}
