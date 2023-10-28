import 'package:encontrar_cuidadodoctor/app/modules/schedule/scheduleWeek_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/cancel_time_register.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/edit_time_register.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/time_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScheduleModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ScheduleStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SchedulePage()),
    ChildRoute('/week-page', child: (_, args) => ScheduleWeekPage()),
    ChildRoute('/time-register', child: (_, args) => TimeRegister()),
    ChildRoute('/edit-time-register', child: (_, args) => EditTimeRegister()),
    ChildRoute('/cancel-time-register',
        child: (_, args) => CancelTimeRegister()),
  ];

  @override
  Widget get view => SchedulePage();
}
