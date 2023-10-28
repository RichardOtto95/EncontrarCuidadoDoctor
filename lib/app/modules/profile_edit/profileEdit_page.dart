import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/widgets/data_tile_profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/person_photo.dart';
import 'widgets/title_widget_profile.dart';

class ProfileEditPage extends StatefulWidget {
  final DoctorModel doctorModel;
  const ProfileEditPage({
    Key key,
    this.doctorModel,
  }) : super(key: key);
  @override
  ProfileEditPageState createState() => ProfileEditPageState();
}

class ProfileEditPageState extends State<ProfileEditPage> {
  final ProfileEditStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  List<String> listGender = ['Masculino', 'Feminino', 'Outro'];
  final _formKey = GlobalKey<FormState>();
  DateTime initialDate = DateTime.now();

  FocusNode userNameFocus;
  FocusNode fullNameFocus;
  FocusNode cpfFocus;
  FocusNode crmFocus;
  FocusNode rqeFocus;
  FocusNode emailFocus;
  FocusNode emailFocus2;
  FocusNode landlineFocus;
  FocusNode socialFocus;
  FocusNode clinicNameFocus;
  FocusNode cepFocus;
  FocusNode addressFocus;
  FocusNode numberFocus;
  FocusNode complementFocus;
  FocusNode neighborhoodFocus;
  FocusNode aboutMeFocus;
  FocusNode academicEducationFocus;
  FocusNode experienceFocus;
  FocusNode medicalConditionsFocus;
  FocusNode attendanceFocus;
  FocusNode languageFocus;
  ScrollController scrollControllerProfile = ScrollController();

  @override
  void initState() {
    store.setMapDoctor(widget.doctorModel);
    userNameFocus = FocusNode();
    fullNameFocus = FocusNode();
    cpfFocus = FocusNode();
    crmFocus = FocusNode();
    rqeFocus = FocusNode();
    emailFocus = FocusNode();
    emailFocus2 = FocusNode();
    landlineFocus = FocusNode();
    socialFocus = FocusNode();
    clinicNameFocus = FocusNode();
    cepFocus = FocusNode();
    addressFocus = FocusNode();
    numberFocus = FocusNode();
    complementFocus = FocusNode();
    neighborhoodFocus = FocusNode();
    aboutMeFocus = FocusNode();
    academicEducationFocus = FocusNode();
    experienceFocus = FocusNode();
    medicalConditionsFocus = FocusNode();
    attendanceFocus = FocusNode();
    languageFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // if (store.confirmEditOverlay != null && store.confirmEditOverlay.mounted) {
    //   store.confirmEditOverlay.remove();
    // }

    userNameFocus.dispose();
    fullNameFocus.dispose();
    cpfFocus.dispose();
    crmFocus.dispose();
    rqeFocus.dispose();
    emailFocus.dispose();
    emailFocus2.dispose();
    landlineFocus.dispose();
    socialFocus.dispose();
    clinicNameFocus.dispose();
    cepFocus.dispose();
    addressFocus.dispose();
    numberFocus.dispose();
    complementFocus.dispose();
    neighborhoodFocus.dispose();
    aboutMeFocus.dispose();
    academicEducationFocus.dispose();
    experienceFocus.dispose();
    medicalConditionsFocus.dispose();
    attendanceFocus.dispose();
    languageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'ppppppppppppppppp profileEdit build ${mainStore.secretaryEditDoctor}');
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (store.confirmCodeOverlay != null &&
            store.confirmCodeOverlay.mounted) {
          return false;
        } else {
          store.clearErrors();

          return true;
        }
      },
      child: Listener(
        onPointerDown: (event) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: maxWidth,
                    height: wXD(203, context),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: Color(0x40000000),
                            offset: Offset(0, 3))
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff41C3B3),
                          Color(0xff21BCCE),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25)),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SingleChildScrollView(
                    controller: scrollControllerProfile,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: wXD(20, context),
                            left: wXD(12, context),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (store.confirmEditOverlay != null &&
                                      store.confirmCodeOverlay.mounted) {
                                  } else {
                                    store.clearErrors();
                                    Modular.to.pop();
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: maxWidth * 28 / 375,
                                  color: Color(0xfffafafa),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                'Editar Perfil',
                                style: TextStyle(
                                    color: Color(0xfffafafa),
                                    fontSize: wXD(20, context),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            wXD(18, context),
                            wXD(20, context),
                            wXD(18, context),
                            wXD(18, context),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Color(0x40000000),
                                  offset: Offset.zero),
                            ],
                            color: Color(0xfffafafa),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Observer(
                                      builder: (context) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: wXD(15, context),
                                            vertical: wXD(25, context),
                                          ),
                                          height: wXD(120, context),
                                          width: wXD(120, context),
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                  'AQUIIIIIIIIIIIIIIIIIIIIIIIIIIIII');
                                              store.pickImage();
                                              print(
                                                  'pickImagepickImagepickImagepickImagepickImage   ${store.mapDoctor['avatar']}');
                                            },
                                            child: store.loadCircularAvatar
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : PersonPhoto(
                                                    photo: store
                                                        .mapDoctor['avatar'],
                                                    borderColor:
                                                        Color(0xff41C3B3),
                                                    size: wXD(120, context),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: wXD(20, context),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: wXD(38, context),
                                        color: Color(0xff41C3B3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Observer(builder: (context) {
                                return Visibility(
                                  visible: store.avatarError,
                                  child: Center(
                                    child: Text(
                                      'Selecione uma imagem!',
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              TitleWidgetProfile(
                                title: 'Dados pessoais',
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: Fulano',
                                initialValue: widget.doctorModel.username,
                                title: 'Nome de usuário',
                                type: 'username',
                                focusNode: userNameFocus,
                                mandatory: true,
                                onChanged: (String value) {
                                  store.mapDoctor['username'] = value;
                                },
                                onEditingComplete: () {
                                  fullNameFocus.requestFocus();
                                },
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: Fulano de tal',
                                initialValue: widget.doctorModel.fullname,
                                title: 'Nome completo',
                                type: 'fullname',
                                focusNode: fullNameFocus,
                                mandatory: true,
                                onChanged: (String value) {
                                  store.mapDoctor['fullname'] = value;
                                },
                              ),
                              DataTileProfileEdit(
                                hint: store.converterDate(null, true),
                                mandatory: true,
                                title: 'Data de nascimento ',
                                iconTap: () => store.selectDate(context),
                                type: 'birthday',
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: 123.456.789-10',
                                initialValue: widget.doctorModel.cpf,
                                title: 'CPF',
                                type: 'cpf',
                                focusNode: cpfFocus,
                                mandatory: true,
                                onChanged: (String value) {
                                  store.mapDoctor['cpf'] = value;
                                },
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: Feminino',
                                title: 'Gênero',
                                iconTap: () {
                                  store.genderDialog = true;
                                },
                                type: 'gender',
                                mandatory: true,
                              ),
                              widget.doctorModel.type == 'DOCTOR'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DataTileProfileEdit(
                                          hint: 'Ex: 12345',
                                          initialValue: widget.doctorModel.crm,
                                          title: 'CRM',
                                          type: 'crm',
                                          focusNode: crmFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['crm'] = value;
                                          },
                                          onEditingComplete: () {
                                            rqeFocus.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: 12345',
                                          initialValue: widget.doctorModel.rqe,
                                          title: 'RQE',
                                          type: 'rqe',
                                          focusNode: rqeFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['rqe'] = value;
                                          },
                                          onEditingComplete: () {
                                            emailFocus.requestFocus();
                                          },
                                        ),
                                      ],
                                    )
                                  : Container(),
                              TitleWidgetProfile(
                                title: 'Dados de contato',
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: fulano@gmail.com',
                                initialValue: widget.doctorModel.email,
                                secretaryEditDoctor:
                                    mainStore.secretaryEditDoctor,
                                title: 'E-mail',
                                type: 'email',
                                focusNode: emailFocus,
                                onChanged: (String value) {
                                  store.email = value;
                                },
                                onEditingComplete: () {
                                  emailFocus2.requestFocus();
                                },
                                mandatory: true,
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: fulano@gmail.com',
                                initialValue: widget.doctorModel.email,
                                secretaryEditDoctor:
                                    mainStore.secretaryEditDoctor,
                                title: 'Confirme o seu e-mail',
                                type: 'email2',
                                focusNode: emailFocus2,
                                onChanged: (String value) {
                                  store.mapDoctor['email'] = value;
                                },
                                onEditingComplete: () {
                                  landlineFocus.requestFocus();
                                },
                                mandatory: true,
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: +55 (61) 99999-9999',
                                initialValue: widget.doctorModel.phone,
                                title: 'Telefone',
                                type: 'phone',
                              ),
                              DataTileProfileEdit(
                                hint: 'Ex: (61) 3333-3333',
                                initialValue: widget.doctorModel.landline,
                                title: 'Telefone fixo',
                                type: 'landline',
                                focusNode: landlineFocus,
                                mandatory: true,
                                onChanged: (String value) {
                                  store.mapDoctor['landline'] = value;
                                },
                                onEditingComplete: () {
                                  if (widget.doctorModel.type == 'DOCTOR') {
                                    socialFocus.requestFocus();
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  }
                                },
                              ),
                              widget.doctorModel.type == 'DOCTOR'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DataTileProfileEdit(
                                          hint: 'Ex: @Fulano_oficial',
                                          initialValue:
                                              widget.doctorModel.social,
                                          title: 'Rede social',
                                          type: 'social',
                                          focusNode: socialFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['social'] = value;
                                          },
                                          onEditingComplete: () {
                                            clinicNameFocus.requestFocus();
                                          },
                                        ),
                                        TitleWidgetProfile(
                                          title: 'Endereço da clínica',
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: Clínica bem estar',
                                          initialValue:
                                              widget.doctorModel.clinicName,
                                          title: 'Nome da clínica',
                                          type: 'clinicName',
                                          focusNode: clinicNameFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['clinic_name'] =
                                                value;
                                          },
                                          onEditingComplete: () {
                                            cepFocus.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: 12.345-678',
                                          initialValue: widget.doctorModel.cep,
                                          title: 'CEP',
                                          type: 'cep',
                                          focusNode: cepFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['cep'] = value;
                                          },
                                          onEditingComplete: () {
                                            addressFocus.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: Lote 01, Conj. 05',
                                          initialValue:
                                              widget.doctorModel.address,
                                          title: 'Endereço',
                                          type: 'address',
                                          focusNode: addressFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['address'] = value;
                                          },
                                          onEditingComplete: () {
                                            numberFocus.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: 04',
                                          initialValue:
                                              widget.doctorModel.numberAddress,
                                          title: 'Número',
                                          type: 'number',
                                          focusNode: numberFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['number_address'] =
                                                value;
                                          },
                                          onEditingComplete: () {
                                            complementFocus.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: Sobre a loja',
                                          initialValue: widget
                                              .doctorModel.complementAddress,
                                          title: 'Complemento',
                                          type: 'complement',
                                          focusNode: complementFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor[
                                                'complement_address'] = value;
                                          },
                                          onEditingComplete: () {
                                            neighborhoodFocus.requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: Bairro nobre',
                                          initialValue:
                                              widget.doctorModel.neighborhood,
                                          title: 'Bairro',
                                          type: 'neighborhood',
                                          focusNode: neighborhoodFocus,
                                          mandatory: true,
                                          onChanged: (String value) {
                                            store.mapDoctor['neighborhood'] =
                                                value;
                                          },
                                          onEditingComplete: () {
                                            store.focusNodeState.requestFocus();
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          mandatory: true,
                                          title: 'País',
                                          type: 'country',
                                          initialValue:
                                              widget.doctorModel.country,
                                        ),
                                        DataTileProfileEdit(
                                          mandatory: true,
                                          title: 'Estado',
                                          type: 'state',
                                          iconTap: () {
                                            if (!store
                                                .focusNodeState.hasFocus) {
                                              store.focusNodeState
                                                  .requestFocus();
                                            } else {
                                              store.focusNodeState.unfocus();
                                            }
                                          },
                                        ),
                                        DataTileProfileEdit(
                                          mandatory: true,
                                          title: 'Cidade',
                                          type: 'city',
                                          iconTap: () {
                                            if (!store.focusNodeCity.hasFocus) {
                                              store.focusNodeCity
                                                  .requestFocus();
                                            } else {
                                              store.focusNodeCity.unfocus();
                                            }
                                          },
                                        ),
                                        Observer(builder: (context) {
                                          if (store.inputCity ||
                                              store.inputState) {
                                            Timer(Duration(milliseconds: 400),
                                                () {
                                              if (scrollControllerProfile
                                                      .offset <
                                                  scrollControllerProfile
                                                          .position
                                                          .maxScrollExtent *
                                                      .65) {
                                                scrollControllerProfile
                                                    .animateTo(
                                                        scrollControllerProfile
                                                                .offset +
                                                            wXD(120, context),
                                                        duration: Duration(
                                                            milliseconds: 800),
                                                        curve: Curves.ease);
                                              }
                                            });
                                          }
                                          double getHeight(
                                              {double value,
                                              int length,
                                              bool input}) {
                                            if (input) {
                                              double fraction = value / 6.0;
                                              if (length > 6) {
                                                return value;
                                              } else {
                                                if (length <= 3) {
                                                  return 0;
                                                } else {
                                                  return length * fraction;
                                                }
                                              }
                                            } else {
                                              return 0;
                                            }
                                          }

                                          return store.inputCity
                                              ? AnimatedContainer(
                                                  duration:
                                                      Duration(seconds: 0),
                                                  height: store.inputCity
                                                      ? store.newListCitys
                                                                  .length >
                                                              6
                                                          ? wXD(120, context)
                                                          : store.newListCitys
                                                                  .length *
                                                              wXD(25, context)
                                                      : 0,
                                                )
                                              : AnimatedContainer(
                                                  duration:
                                                      Duration(seconds: 0),
                                                  height: getHeight(
                                                      input: store.inputState,
                                                      length: store
                                                          .newListStates.length,
                                                      value: wXD(70, context)),
                                                );
                                        }),
                                        TitleWidgetProfile(
                                          title: 'Experiência',
                                        ),
                                        DataTileProfileEdit(
                                          hint:
                                              'Ex: É um privilégio exercer a profissão que eu amo e ao mesmo tempo poder ajudar as pessoas. Procuro olhar o paciente como um todo e não apenas como um orgão.',
                                          initialValue:
                                              widget.doctorModel.aboutMe,
                                          title: 'Sobre mim',
                                          maxLines: null,
                                          type: 'aboutMe',
                                          focusNode: aboutMeFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['about_me'] = value;
                                          },
                                          onEditingComplete: () {
                                            academicEducationFocus
                                                .requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        Observer(builder: (context) {
                                          if (store.inputSpecialty) {
                                            Timer(Duration(milliseconds: 400),
                                                () {
                                              if (scrollControllerProfile
                                                      .offset <
                                                  scrollControllerProfile
                                                          .position
                                                          .maxScrollExtent *
                                                      .75) {
                                                scrollControllerProfile
                                                    .animateTo(
                                                        scrollControllerProfile
                                                                .offset +
                                                            wXD(120, context),
                                                        duration: Duration(
                                                            milliseconds: 800),
                                                        curve: Curves.ease);
                                              }
                                            });
                                          }

                                          return AnimatedContainer(
                                            duration: Duration(seconds: 0),
                                            height: store.inputSpecialty
                                                ? store.newListSpecialites
                                                            .length >
                                                        6
                                                    ? wXD(120, context)
                                                    : store.newListSpecialites
                                                            .length *
                                                        wXD(25, context)
                                                : 0,
                                          );
                                        }),
                                        DataTileProfileEdit(
                                          hint:
                                              'Ex: Graduação em medicina pela Universidade de Brasília (UNB).',
                                          initialValue: widget
                                              .doctorModel.academicEducation,
                                          title: 'Formação acadêmica',
                                          maxLines: null,
                                          type: 'academicEducation',
                                          focusNode: academicEducationFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor[
                                                'academic_education'] = value;
                                          },
                                          onEditingComplete: () {
                                            experienceFocus.requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        DataTileProfileEdit(
                                          hint:
                                              'Ex: Cardiologia ambulatorial, eletrocardiograma, exames e diagnósticos.',
                                          initialValue:
                                              widget.doctorModel.experience,
                                          title: 'Experiência em',
                                          maxLines: null,
                                          type: 'experience',
                                          focusNode: experienceFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['experience'] =
                                                value;
                                          },
                                          onEditingComplete: () {
                                            medicalConditionsFocus
                                                .requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        DataTileProfileEdit(
                                          hint:
                                              'Ex: Hipertensão, arritmia, insuficiência cardíaca.',
                                          initialValue: widget
                                              .doctorModel.medicalConditions,
                                          title: 'Tratar condições médicas',
                                          maxLines: null,
                                          type: 'medicalConditions',
                                          focusNode: medicalConditionsFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor[
                                                'medical_conditions'] = value;
                                          },
                                          onEditingComplete: () {
                                            attendanceFocus.requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        DataTileProfileEdit(
                                          hint: 'Ex: Acima de 16 anos.',
                                          initialValue:
                                              widget.doctorModel.attendance,
                                          title: 'Faixa etária',
                                          maxLines: null,
                                          type: 'attendance',
                                          focusNode: attendanceFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['attendance'] =
                                                value;
                                          },
                                          onEditingComplete: () {
                                            languageFocus.requestFocus();
                                          },
                                          mandatory: true,
                                        ),
                                        DataTileProfileEdit(
                                          hint:
                                              'Ex: Inglês, Espanhol e Português.',
                                          initialValue:
                                              widget.doctorModel.language,
                                          title: 'Idioma',
                                          type: 'language',
                                          focusNode: languageFocus,
                                          onChanged: (String value) {
                                            store.mapDoctor['language'] = value;
                                          },
                                          mandatory: true,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                              Observer(builder: (context) {
                                return Center(
                                  child: store.loadCircularEdit
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            top: maxWidth * .025,
                                            bottom: maxWidth * .07,
                                          ),
                                          height: maxWidth * .1493,
                                          width: maxWidth * .1493,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                          child: CircularProgressIndicator(),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            await store.getValidate();
                                            if (_formKey.currentState
                                                    .validate() &&
                                                store.validEdit) {
                                              store.confirmEdit(context);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Preencha os campos obrigatórios corretamente, inclusive a foto",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.red[700],
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              scrollControllerProfile
                                                  .jumpTo(0.00);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: maxWidth * .025,
                                              bottom: maxWidth * .07,
                                            ),
                                            height: maxWidth * .1493,
                                            width: maxWidth * .1493,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xff41C3B3),
                                                    Color(0xff21BCCE),
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 6,
                                                    offset: Offset(0, 3),
                                                    color: Color(0x30000000),
                                                  )
                                                ]),
                                            child: Icon(
                                              Icons.check,
                                              color: Color(0xfffafafa),
                                              size: maxWidth * .1,
                                            ),
                                          ),
                                        ),
                                );
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Observer(
                    builder: (context) {
                      return Visibility(
                        visible: store.genderDialog,
                        child: GestureDetector(
                          onTap: () {
                            store.genderDialog = false;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: maxHeight,
                            width: maxWidth,
                            color: Color(0x50000000),
                            child: Container(
                              width: maxWidth,
                              height: wXD(201, context),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Color(0xfffafafa),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: wXD(19, context),
                                      vertical: wXD(10, context),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            store.genderDialog = false;
                                          },
                                          child: Container(
                                            width: maxWidth * .3,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                  fontSize: wXD(15, context),
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          height: wXD(5, context),
                                          width: wXD(34, context),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Color(0xff707070)
                                                .withOpacity(.35),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            store.setGender(
                                                genders: listGender);
                                            store.genderDialog = false;
                                          },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            width: maxWidth * .3,
                                            child: InkWell(
                                              child: Text(
                                                'Selecionar',
                                                style: TextStyle(
                                                    fontSize: wXD(15, context),
                                                    color: Color(0xff2185D0),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      initialPage: store.listGenderIndex,
                                      height: wXD(90, context),
                                      viewportFraction: .4,
                                      scrollDirection: Axis.vertical,
                                      onPageChanged: (index, reason) {
                                        store.listGenderIndex = index;
                                      },
                                    ),
                                    items: listGender.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              store.setGender(
                                                  genders: listGender,
                                                  clickItem: true,
                                                  itemName: i);
                                              store.genderDialog = false;
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        wXD(20, context)),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Color(0x70707070),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  i,
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                )),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
