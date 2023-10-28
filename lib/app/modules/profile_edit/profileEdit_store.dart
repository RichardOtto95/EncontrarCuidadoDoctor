import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/confirm_code.dart';
import 'widgets/confirm_profile_edit.dart';
part 'profileEdit_store.g.dart';

class ProfileEditStore = _ProfileEditStoreBase with _$ProfileEditStore;

abstract class _ProfileEditStoreBase with Store {
  final MainStore mainStore = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @observable
  bool genderDialog = false;
  @observable
  int listGenderIndex = 0;
  @observable
  bool loadCircularAvatar = false;
  @observable
  DateTime selectedDate = DateTime.now();
  @observable
  bool genderError = false;
  @observable
  bool dateError = false;
  @observable
  bool specialityError = false;
  @observable
  bool avatarError = false;
  @observable
  bool validEdit = false;
  @observable
  List listCitys = [], listStates = [], listSpecialites = [];
  @observable
  List newListCitys = [], newListStates = [], newListSpecialites = [];
  @observable
  FocusNode focusNodeCity;
  @observable
  FocusNode focusNodeState;
  @observable
  FocusNode focusNodeSpecialty;
  @observable
  ObservableMap<String, dynamic> mapDoctor = ObservableMap();
  @observable
  TextEditingController textEditingControllerCity = TextEditingController(),
      textEditingControllerState = TextEditingController(),
      textEditingControllerSpeciality = TextEditingController();
  @observable
  List addressKeys = [];
  @observable
  bool inputCity = false, inputState = false, inputSpecialty = false;
  @observable
  bool haveDialogCity = false, haveDialogState = false;
  @observable
  Timer _timer;
  @observable
  String email;
  @observable
  String code = '';
  @observable
  bool loadCircularCode = false, loadCircularEdit = false;
  @observable
  String userVerificationId;
  @observable
  String oldEmail;
  @observable
  OverlayEntry confirmEditOverlay;
  @observable
  OverlayEntry confirmCodeOverlay;
  @observable
  int forceResendingToken;
  @observable
  Timer timerResendeCode;
  @observable
  int timerSeconds;

  @action
  setAddressKeys() async {
    if (mapDoctor['state'] != null) {
      QuerySnapshot aux =
          await FirebaseFirestore.instance.collection('info').get();

      QuerySnapshot states = await aux.docs.first.reference
          .collection('states')
          .where('name', isEqualTo: mapDoctor['state'])
          .get();
      DocumentSnapshot state = states.docs.first;
      if (state != null) {
        for (var i = 0; i < state.get('name').length; ++i) {
          addressKeys.add(state.get('name').substring(0, i + 1).toUpperCase());
        }
      }
    }
    if (mapDoctor['city'] != null) {
      for (var ii = 0; ii < mapDoctor['city'].length; ++ii) {
        addressKeys.add(mapDoctor['city'].substring(0, ii + 1).toUpperCase());
      }
    }
  }

  @action
  filterListCity(String text) {
    List newList = [];

    if (text != '') {
      listCitys.forEach((city) {
        if (!newList.contains(city) && city.toLowerCase().contains(text)) {
          newList.add(city);
        }
      });

      newListCitys = newList;
    } else {
      newListCitys = [];
    }
  }

  void filterListState(String text) {
    List newList = [];
    if (text != '') {
      listStates.forEach((state) {
        if (!newList.contains(state) && state.toLowerCase().contains(text)) {
          newList.add(state);
        }
      });
      newListStates = newList;
    } else {
      newListStates = [];
    }
  }

  void filterListSpeciality(String text) {
    List newList = [];
    if (text != '') {
      for (var i = 0; i < listSpecialites.length; i++) {
        String speciality = listSpecialites[i];

        if (!newList.contains(speciality) &&
            speciality.toLowerCase().contains(text)) {
          newList.add(speciality);
        }
      }
      newListSpecialites = newList;
    } else {
      newListSpecialites = [];
    }
  }

  void getSpecialites() async {
    QuerySnapshot specialites = await FirebaseFirestore.instance
        .collection('specialties')
        .where('active', isEqualTo: true)
        .get();

    for (var i = 0; i < specialites.docs.length; i++) {
      DocumentSnapshot speciality = specialites.docs[i];
      listSpecialites.add(speciality['speciality']);
    }
  }

  @action
  getCitys() async {
    QuerySnapshot aux =
        await FirebaseFirestore.instance.collection('info').get();

    QuerySnapshot states =
        await aux.docs.first.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      if (state['name'] == mapDoctor['state']) {
        listCitys = state['citys'];
      }
    });
  }

  void getStates() async {
    List list = [];
    QuerySnapshot aux =
        await FirebaseFirestore.instance.collection('info').get();

    QuerySnapshot states =
        await aux.docs.first.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      list.add(state['name'] + ' - ' + state['acronyms']);
    });
    listStates = list;
  }

  @action
  setSpeciality(String specialityName) async {
    mapDoctor['speciality_name'] = specialityName;

    QuerySnapshot specialties =
        await FirebaseFirestore.instance.collection('specialties').get();

    specialties.docs.forEach((DocumentSnapshot speciality) {
      if (speciality['speciality'] == specialityName) {
        mapDoctor['speciality'] = speciality.id;
      }
    });
  }

  @action
  setMapDoctor(DoctorModel doctorModel) {
    mapDoctor = DoctorModel().convertUserObservable(doctorModel);
  }

  @action
  getValidate() {
    bool returnValue;
    bool haveGender =
        mapDoctor['gender'] != null && mapDoctor['gender'].isNotEmpty;
    bool haveDate = mapDoctor['birthday'] != null;
    bool haveSpeciality = mapDoctor['type'] == 'DOCTOR'
        ? mapDoctor['speciality'] != null && mapDoctor['speciality'].isNotEmpty
        : true;
    bool haveAvatar = mapDoctor['avatar'] != null;

    returnValue = haveGender && haveDate && haveSpeciality && haveAvatar;

    if (returnValue) {
      clearErrors();
      validEdit = true;
    } else {
      genderError = haveGender ? false : true;
      dateError = haveDate ? false : true;
      specialityError = haveSpeciality ? false : true;
      avatarError = haveAvatar ? false : true;
      validEdit = false;
    }
  }

  @action
  clearErrors() {
    dateError = false;
    genderError = false;
    specialityError = false;
    avatarError = false;
  }

  @action
  setSelectedDate(DateTime date) {
    selectedDate = date;

    mapDoctor['birthday'] = Timestamp.fromDate(date);
  }

  @action
  setGender({List<String> genders, bool clickItem = false, String itemName}) {
    if (clickItem) {
      mapDoctor['gender'] = itemName;
      for (var i = 0; i < genders.length; i++) {
        String label = genders[i];
        if (label == itemName) {
          listGenderIndex = i;
          break;
        }
      }
    } else {
      mapDoctor['gender'] = genders[listGenderIndex];
    }
    genderError = false;
  }

  Future<void> getValidEmail() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        await _user.reload();

        if (_user.emailVerified) {
          flutterToast('O seu e-mail foi validado!');
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
    return null;
  }

  Future<void> resendEmailValidation(
      String email, context, Function callBack) async {
    Future<void> getValidateEmail() async {
      await _auth.currentUser.reload();
      try {
        print(
            'xxxxxxxxxxxx authStore.user.email ${mainStore.authStore.user.email} xxxxxxxxxxxxxxx');

        await FirebaseAuth.instance.currentUser.sendEmailVerification();
        getValidEmail();
        flutterToast('Um e-mail de verificação foi enviado para sua conta.');
      } catch (e) {
        flutterToast(
            'Erro ao validar o e-mail, verifique se está tudo correto ou solicite o suporte.');

        print('xxxxxxxxxxxx ERROR: $e xxxxxxxxxxxxxxx');
      }
    }

    print(
        'xxxxxxxxxxxx resendEmailValidation ${FirebaseAuth.instance.currentUser.phoneNumber} xxxxxxxxxxxxxxx');

    print('xxxxxxxxxxxx resendEmailValidation2 $email xxxxxxxxxxxxxxx');

    await FirebaseAuth.instance.currentUser
        .updateEmail(email)
        .then((value) async {
      print('email atualizado!!!');
      await callBack();
      getValidateEmail();
      editCompleted(context);
    }).catchError((e) async {
      print('erro ao atualizar email:');
      print(e);
      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        Fluttertoast.showToast(
            msg: "O e-mail digitado já está em uso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        loadCircularEdit = false;
      }

      if (e.toString() ==
          '[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.') {
        print('ifffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

        loadCircularEdit = false;

        // reautenticando o usuário
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: FirebaseAuth.instance.currentUser.phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
          },
          verificationFailed: (FirebaseAuthException execption) {
            print('xxxxxxxxxxxxxx verificationFailed: $execption xxxxxxxxxxx');
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            print('xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
            userVerificationId = verificationId;
            forceResendingToken = forceResendingToken;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
          },
        );

        confirmCodeOverlay = OverlayEntry(
          builder: (context) => ConfirmCode(
            resend: () {
              const oneSec = const Duration(seconds: 1);

              timerSeconds = 60;

              timerResendeCode = Timer.periodic(oneSec, (timer) {
                if (timerSeconds == 0) {
                  timerSeconds = null;
                  timer.cancel();
                } else {
                  timerSeconds--;
                }
              });

              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: _auth.currentUser.phoneNumber,
                forceResendingToken: forceResendingToken,
                verificationCompleted:
                    (PhoneAuthCredential phoneAuthCredential) async {
                  print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
                },
                verificationFailed: (FirebaseAuthException execption) {
                  print(
                      'xxxxxxxxxxxxxx verificationFailed: $execption xxxxxxxxxxx');
                  flutterToast(
                      'Espere alguns instantes para poder solicitar outro SMS.');
                },
                codeSent: (String verificationId, [int forceResendingToken]) {
                  print(
                      'xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
                },
              );
            },
            cancel: () async {
              await callBack();
              await FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(_auth.currentUser.uid)
                  .update({'email': oldEmail});

              editCompleted(context,
                  'Perfil editado com sucesso, apenas o e-mail não foi atualizado');
            },
            confirm: () async {
              try {
                AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: userVerificationId, smsCode: code);

                final User _user =
                    (await _auth.signInWithCredential(credential)).user;

                await _user.updateEmail(email).then((value) async {
                  print('email atualizado!!! 2');
                  await callBack();
                  getValidateEmail();
                  userVerificationId = null;
                  code = null;
                  loadCircularCode = false;
                  editCompleted(context);
                }).catchError((e) async {
                  print('erro ao atualizar email2:');
                  print(e);
                  if (e.toString() ==
                      '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                    Fluttertoast.showToast(
                        msg: "O e-mail digitado já está em uso!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    loadCircularCode = false;

                    if (confirmCodeOverlay != null &&
                        confirmCodeOverlay.mounted) {
                      confirmCodeOverlay.remove();
                    }
                  } else {
                    await callBack();

                    loadCircularCode = false;

                    editCompleted(context,
                        'Perfil editado com sucesso, apenas o e-mail não foi atualizado');
                  }
                });
              } catch (e) {
                print('%%%%%%%%%%% error: $e %%%%%%%%%%%');
                loadCircularCode = false;

                Fluttertoast.showToast(
                    msg: "Código inválido!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        );

        Overlay.of(context).insert(confirmCodeOverlay);
      }
    });
  }

  void confirmEdit(context) async {
    loadCircularEdit = true;
    String newEmail, id;

    print(
        '%%%%%%%%%%%%%%%% confirmEdit() ${mainStore.secretaryEditDoctor} - ${mainStore.authStore.type} - ${mainStore.authStore.user.uid} - ${mainStore.authStore.viewDoctorId}%%%%%%%%%%%%%%%%');

    if (mainStore.authStore.type == 'SECRETARY' &&
        !mainStore.secretaryEditDoctor) {
      id = mainStore.authStore.user.uid;
    } else {
      id = mainStore.authStore.viewDoctorId;
    }

    print('%%%%%%%%%%%%%%%% confirmEdit() $id %%%%%%%%%%%%%%%%');

    DocumentSnapshot _user =
        await FirebaseFirestore.instance.collection('doctors').doc(id).get();

    oldEmail = _user['email'];

    await setAddressKeys();

    if (addressKeys != null) {
      mapDoctor['address_keys'] = addressKeys;
    }

    print('xxxxxx mapDoctor ${mapDoctor['email']} xxxxxxx');

    newEmail = mapDoctor['email'];

    if (mapDoctor['type'] == 'DOCTOR') {
      if (newEmail != null && oldEmail != newEmail) {
        await resendEmailValidation(
          mapDoctor['email'],
          context,
          () async {
            await _user.reference.update(mapDoctor);
          },
        );
      } else {
        await _user.reference.update(mapDoctor);

        editCompleted(context);
      }
    } else {
      await _user.reference.update(mapDoctor);

      editCompleted(context);
    }
  }

  void editCompleted(context, [String text = "Perfil editado com sucesso"]) {
    if (confirmCodeOverlay != null && confirmCodeOverlay.mounted) {
      confirmCodeOverlay.remove();
    }

    newListCitys = [];
    newListStates = [];

    addressKeys.clear();

    oldEmail = null;

    loadCircularEdit = false;

    mainStore.secretaryEditDoctor = false;

    confirmEditOverlay = OverlayEntry(
      builder: (context) => ConfirmProfileEdit(
        onBack: () => confirmEditOverlay.remove(),
        text: text,
      ),
    );

    Overlay.of(context).insert(confirmEditOverlay);

    Modular.to.pop();
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      context: context,
      initialDate: mapDoctor['birthday'] != null
          ? mapDoctor['birthday'].toDate()
          : DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF41c3b3),
            accentColor: const Color(0xFF21bcce),
            colorScheme: ColorScheme.light(primary: const Color(0xFF41c3b3)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setSelectedDate(picked);
      dateError = false;
    }
  }

  @action
  pickImage() async {
    if (await Permission.storage.request().isGranted) {
      loadCircularAvatar = true;

      File _imageFile;
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);

        if (_imageFile != null) {
          String id;

          if (mainStore.authStore.type == 'SECRETARY' &&
              !mainStore.secretaryEditDoctor) {
            print('piiiick aquiiiiiiiiiiiiiiiiiiiiiiiiiiii');
            id = mainStore.authStore.user.uid;
          } else {
            print('piiiick acoláaaaaaaaaaaaaaaaaaaaaaaaaa');
            id = mainStore.authStore.viewDoctorId;
          }
          print('piiiick ididididididididididididid    $id');
          Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('doctors/$id/avatar/${_imageFile.path[0]}');

          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

          TaskSnapshot taskSnapshot = await uploadTask;

          taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
            print(
                'downloadURLdownloadURLdownloadURLdownloadURLdownloadURL    $downloadURL');
            mapDoctor['avatar'] = downloadURL;
            print(
                'mapDoctor[avatar]mapDoctor[avatar]mapDoctor[avatar]mapDoctor[avatar]    $mapDoctor');
            avatarError = false;
          });
        }
      }

      loadCircularAvatar = false;
    }
  }

  @action
  String converterDate(Timestamp date, [bool hint = false]) {
    return !hint
        ? date != null
            ? date.toDate().day.toString().padLeft(2, '0') +
                '/' +
                date.toDate().month.toString().padLeft(2, '0') +
                '/' +
                date.toDate().year.toString()
            : null
        : 'Ex: ' +
            DateTime.now().day.toString().padLeft(2, '0') +
            '/' +
            DateTime.now().month.toString().padLeft(2, '0') +
            '/' +
            DateTime.now().year.toString();
  }

  @action
  getMask(String value, String type) {
    String newHint;

    if (value != null) {
      switch (type) {
        case 'cpf':
          newHint = value.substring(0, 3) +
              '.' +
              value.substring(3, 6) +
              '.' +
              value.substring(6, 9) +
              '-' +
              value.substring(9, 11);
          return newHint;
          break;

        case 'cep':
          newHint = value.substring(0, 2) +
              '.' +
              value.substring(2, 5) +
              '-' +
              value.substring(5, 8);
          return newHint;
          break;

        case 'phone':
          newHint = value.substring(0, 3) +
              ' (' +
              value.substring(3, 5) +
              ') ' +
              value.substring(5, 10) +
              '-' +
              value.substring(10, 14);
          return newHint;
          break;

        case 'landline':
          newHint = '(' +
              value.substring(0, 2) +
              ') ' +
              value.substring(2, 6) +
              '-' +
              value.substring(6, 10);

          return newHint;
          break;

        default:
          return value;
          break;
      }
    } else {
      return null;
    }
  }

  void flutterToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff41C3B3),
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
