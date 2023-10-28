import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/widgets/scheduling_empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/widgets/canceled_scheduling.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/widgets/next_scheduling.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/widgets/awaiting_scheduling.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'scheduling_store.dart';
import 'widgets/previous_scheduling.dart';

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({
    Key key,
  }) : super(key: key);
  @override
  SchedulingPageState createState() => SchedulingPageState();
}

class SchedulingPageState extends State<SchedulingPage> {
  final SchedulingStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  bool confirm = false;
  String listing = 'Próximos agendamentos';
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.showMenuFilter = false;
      store.appointmentPage = 1;
    });
    mainStore.getUser();
    super.initState();
    handleScroll();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setShowNav(false);
      } else {
        mainStore.setShowNav(true);
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                store.showMenuFilter = false;
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EncontrarCuidadoAppBar(title: 'Atendimentos'),
                    Container(
                      padding: EdgeInsets.fromLTRB(21, 10, 21, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            listing,
                            style: TextStyle(
                              color: Color(0xff4C4C4C),
                              fontSize: wXD(19, context),
                            ),
                          ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              store.showMenuFilter = !store.showMenuFilter;
                            },
                            child: Icon(
                              Icons.filter_list_outlined,
                              size: wXD(25, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.delta.direction < 0) {
                            mainStore.setShowNav(false);
                          }
                          if (details.delta.direction > 0) {
                            mainStore.setShowNav(true);
                          }
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('appointments')
                                  .where('doctor_id',
                                      isEqualTo:
                                          mainStore.authStore.viewDoctorId)
                                  .orderBy('hour', descending: false)
                                  .snapshots(),
                              builder: (context, snapshotAppointments) {
                                if (!snapshotAppointments.hasData) {
                                  return Container();
                                }

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  store.getListAppointments(
                                      snapshotAppointments.data);
                                });

                                return Observer(builder: (context) {
                                  if (store.listAppointments == null) {
                                    return Container(
                                        padding: EdgeInsets.only(
                                          right: wXD(17.5, context),
                                          left: wXD(17.5, context),
                                        ),
                                        alignment: Alignment.center,
                                        child: LinearProgressIndicator());
                                  }
                                  if (store.listAppointments.isEmpty) {
                                    return SchedulingEmptyState(
                                      image: './assets/svg/calendar.svg',
                                      description: getEmptyText(),
                                    );
                                  } else {
                                    return Column(
                                      children: List.generate(
                                          store.listAppointments.length,
                                          (index) {
                                        var appointment =
                                            store.listAppointments[index];
                                        bool isDependent =
                                            appointment['dependent_id'] != null;
                                        String id = isDependent
                                            ? appointment['dependent_id']
                                            : appointment['patient_id'];

                                        String appointmentId = appointment['id']
                                            .substring(
                                                appointment['id'].length - 4,
                                                appointment['id'].length)
                                            .toUpperCase();

                                        return store.appointmentPage == 1
                                            ? NextScheduling(
                                                appointmentId: appointmentId,
                                                store: store,
                                                date: appointment['hour'],
                                                patientId:
                                                    appointment['patient_id'],
                                                status: appointment['status'],
                                                patientName:
                                                    appointment['patient_name'],
                                                viewPatientProfile: () {
                                                  print(
                                                      'id ====================$id');
                                                  store.viewPatientProfile(id);
                                                },
                                                viewConsulationDetail: () =>
                                                    store.viewConsulationDetail(
                                                        appointment),
                                                isDependent: isDependent,
                                              )
                                            : store.appointmentPage == 2
                                                ? WaitingScheduling(
                                                    appointmentId:
                                                        appointmentId,
                                                    store: store,
                                                    date: appointment['hour'],
                                                    patientId: appointment[
                                                        'patient_id'],
                                                    status:
                                                        appointment['status'],
                                                    patientName: appointment[
                                                        'patient_name'],
                                                    viewPatientProfile: () =>
                                                        store
                                                            .viewPatientProfile(
                                                                id),
                                                    viewConsulationDetail: () =>
                                                        store
                                                            .viewConsulationDetail(
                                                                appointment),
                                                    isDependent: isDependent,
                                                  )
                                                : store.appointmentPage == 3
                                                    ? PreviousScheduling(
                                                        appointmentId:
                                                            appointmentId,
                                                        store: store,
                                                        date:
                                                            appointment['hour'],
                                                        patientId: appointment[
                                                            'patient_id'],
                                                        status: appointment[
                                                            'status'],
                                                        patientName:
                                                            appointment[
                                                                'patient_name'],
                                                        viewPatientProfile:
                                                            () => store
                                                                .viewPatientProfile(
                                                                    id),
                                                        viewConsulationDetail:
                                                            () => store
                                                                .viewConsulationDetail(
                                                                    appointment),
                                                        isDependent:
                                                            isDependent,
                                                      )
                                                    : CanceledScheduling(
                                                        appointmentId:
                                                            appointmentId,
                                                        store: store,
                                                        date:
                                                            appointment['hour'],
                                                        patientId: appointment[
                                                            'patient_id'],
                                                        status: appointment[
                                                            'status'],
                                                        patientName:
                                                            appointment[
                                                                'patient_name'],
                                                        viewPatientProfile:
                                                            () => store
                                                                .viewPatientProfile(
                                                                    id),
                                                        viewConsulationDetail:
                                                            () => store
                                                                .viewConsulationDetail(
                                                                    appointment),
                                                        isDependent:
                                                            isDependent,
                                                      );
                                      }),
                                    );
                                  }
                                });
                              }),
                        ),
                      ),
                    ),
                  ]),
            ),
            schedulingMenuFilter(context),
          ],
        ),
      ),
    );
  }

  String getEmptyText() {
    switch (store.appointmentPage) {
      case 1:
        return 'Sem futuros atendimentos';
        break;
      case 2:
        return 'Nenhum paciente aguardando ';
        break;
      case 3:
        return 'Sem atendimentos anteriores';
        break;
      case 4:
        return 'Sem atendimentos cancelados';
        break;
      default:
        return 'Something is wrong';
    }
  }

  Widget schedulingMenuFilter(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Observer(builder: (context) {
      return Visibility(
        visible: store.showMenuFilter,
        child: Container(
          height: maxHeight,
          width: maxWidth,
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(
            right: wXD(35, context),
            top: wXD(90, context),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              vertical: wXD(5, context),
            ),
            height: wXD(125, context),
            width: wXD(225, context),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff707070).withOpacity(.1)),
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x15000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SchedulingMenuItem(
                  title: 'Próximos agendamentos',
                  inScheduling: store.appointmentPage == 1,
                  onTap: () {
                    mainStore.showNavigator = true;
                    setState(() {
                      listing = 'Próximos agendamentos';
                    });
                    store.appointmentPage = 1;
                    store.showMenuFilter = false;
                  },
                ),
                SchedulingMenuItem(
                  title: 'Em atendimento',
                  inScheduling: store.appointmentPage == 2,
                  onTap: () {
                    mainStore.showNavigator = true;
                    setState(() {
                      listing = 'Em atendimento';
                    });
                    store.appointmentPage = 2;

                    store.showMenuFilter = false;
                  },
                ),
                SchedulingMenuItem(
                  title: 'Atendimentos anteriores',
                  inScheduling: store.appointmentPage == 3,
                  onTap: () {
                    mainStore.showNavigator = true;
                    setState(() {
                      listing = 'Atendimentos anteriores';
                    });
                    store.appointmentPage = 3;
                    store.showMenuFilter = false;
                  },
                ),
                SchedulingMenuItem(
                  title: 'Atendimentos cancelados',
                  inScheduling: store.appointmentPage == 4,
                  onTap: () {
                    mainStore.showNavigator = true;
                    setState(() {
                      listing = 'Atendimentos cancelados';
                    });
                    store.appointmentPage = 4;
                    store.showMenuFilter = false;
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class SchedulingMenuItem extends StatelessWidget {
  final bool inScheduling;
  final String title;
  final Function onTap;

  const SchedulingMenuItem({
    Key key,
    this.inScheduling,
    this.title,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: wXD(10, context)),
        width: wXD(223, context),
        height: wXD(25, context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: inScheduling
                ? Color(0xff41C3B3).withOpacity(.25)
                : Color(0xfffafafa)),
        child: Text(
          '$title',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: wXD(15, context),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
