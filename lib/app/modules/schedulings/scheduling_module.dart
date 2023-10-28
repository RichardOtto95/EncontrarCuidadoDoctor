import 'package:encontrar_cuidadodoctor/app/modules/schedulings/scheduling_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/scheduling_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SchedulingModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SchedulingStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SchedulingPage()),
  ];

  @override
  Widget get view => SchedulingPage();
}
