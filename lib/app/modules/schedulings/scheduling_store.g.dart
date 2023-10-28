// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SchedulingStore on _SchedulingStoreBase, Store {
  final _$showMenuFilterAtom =
      Atom(name: '_SchedulingStoreBase.showMenuFilter');

  @override
  bool get showMenuFilter {
    _$showMenuFilterAtom.reportRead();
    return super.showMenuFilter;
  }

  @override
  set showMenuFilter(bool value) {
    _$showMenuFilterAtom.reportWrite(value, super.showMenuFilter, () {
      super.showMenuFilter = value;
    });
  }

  final _$concludedBuildAtom =
      Atom(name: '_SchedulingStoreBase.concludedBuild');

  @override
  bool get concludedBuild {
    _$concludedBuildAtom.reportRead();
    return super.concludedBuild;
  }

  @override
  set concludedBuild(bool value) {
    _$concludedBuildAtom.reportWrite(value, super.concludedBuild, () {
      super.concludedBuild = value;
    });
  }

  final _$appointmentPageAtom =
      Atom(name: '_SchedulingStoreBase.appointmentPage');

  @override
  int get appointmentPage {
    _$appointmentPageAtom.reportRead();
    return super.appointmentPage;
  }

  @override
  set appointmentPage(int value) {
    _$appointmentPageAtom.reportWrite(value, super.appointmentPage, () {
      super.appointmentPage = value;
    });
  }

  final _$listAppointmentsAtom =
      Atom(name: '_SchedulingStoreBase.listAppointments');

  @override
  List<dynamic> get listAppointments {
    _$listAppointmentsAtom.reportRead();
    return super.listAppointments;
  }

  @override
  set listAppointments(List<dynamic> value) {
    _$listAppointmentsAtom.reportWrite(value, super.listAppointments, () {
      super.listAppointments = value;
    });
  }

  final _$_SchedulingStoreBaseActionController =
      ActionController(name: '_SchedulingStoreBase');

  @override
  String getDate(Timestamp date) {
    final _$actionInfo = _$_SchedulingStoreBaseActionController.startAction(
        name: '_SchedulingStoreBase.getDate');
    try {
      return super.getDate(date);
    } finally {
      _$_SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showMenuFilter: ${showMenuFilter},
concludedBuild: ${concludedBuild},
appointmentPage: ${appointmentPage},
listAppointments: ${listAppointments}
    ''';
  }
}
