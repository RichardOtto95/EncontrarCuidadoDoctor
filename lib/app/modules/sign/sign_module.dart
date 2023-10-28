import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/sign_page_phone.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/sign_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/on_boarding.dart';

class SignModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignStore(i.get())),
    Bind<PatientModel>((i) => PatientModel()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SignPhonePage()),
    ChildRoute("/boarding", child: (_, args) => OnBoarding()),
    ModuleRoute('/main', module: MainModule()),
    // ModuleRoute('/verify-phone', module: HomeModule()),
  ];

  @override
  Widget get view => SignPhonePage();
}
