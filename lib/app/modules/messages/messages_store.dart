import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  @observable
  MainStore mainStore = Modular.get();
  @observable
  ObservableList userChats = [].asObservable();
  @observable
  Map patient = {};
  @observable
  String chatId = '';
  @observable
  ObservableList chat = [].asObservable();
  @observable
  TextEditingController srch = TextEditingController();
  @observable
  ItemScrollController chatScroll = ItemScrollController();
  // ScrollController chatScroll = ScrollController();
  @observable
  String text;
  @observable
  File file;
  @observable
  String chatTitle = 'Chat';
  @observable
  bool uploadSpin = false;
  @observable
  String photo;
  @observable
  bool emptyChat = false;
  @observable
  Directory appDir;
  @observable
  String localPath;
  @observable
  Future<Uint8List> bytes;
  @observable
  File fileBytes;
  @observable
  String fileName;
  @observable
  FilePickerResult result;
  @observable
  DocumentSnapshot chatDoc;
  @observable
  QuerySnapshot messagesDocs;
  @observable
  ObservableList searchResult = [].asObservable();
  @observable
  bool scrollJump = false;
  @observable
  QuerySnapshot searchedQuery;
  @observable
  String searchedText;
  @observable
  int searchPos;
  @observable
  String userAvatar;
  @observable
  String patAvatar;
  @observable
  bool allowed = false;
  @observable
  bool searchEmpty = false;
  @observable
  Stream<QuerySnapshot> chatStream;
  @observable
  bool emojisShowM = false;

  @action
  setPAvatar(String a) => patAvatar = a;
  @action
  setPos(int p) => searchPos = p;
  @action
  setJump(bool j) => scrollJump = j;
  @action
  setText(String tx) => text = tx;
  @action
  setEmptyChat(bool ec) => emptyChat = ec;
  @action
  setChatId(String id) => chatId = id;
  @action
  setUploadSpin(bool sh) => uploadSpin = sh;

  getConsultChat() async {
    mainStore.consultChat = true;
    if (mainStore.hasChat == false) {
      if (mainStore.patientId != null) {
        await startChat(mainStore.patientId);
      }
    } else if (mainStore.hasChat == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        chatId = mainStore.profileChat.id;
        chatTitle = mainStore.chatName;
        await getMessages(chatId, chatTitle);
        mainStore.hasChat = true;
        mainStore.profileChat = null;
        mainStore.chatName = null;
        getChats();
      });
    }
    mainStore.patientId = null;
  }

  String getSearched(QuerySnapshot chats, String txt) {
    String result;

    for (var i = 0; i < chats.docs.length; i++) {
      if (txt != null) {
        if (chats.docs[i]
            .get('text')
            .toString()
            .toUpperCase()
            .contains(txt.toUpperCase())) {
          result = chats.docs[i].get('text');
        }
      }
    }
    return result;
  }

  int getIndex(QuerySnapshot chats, String txt) {
    int result = 0;

    for (var i = 0; i < chats.docs.length; i++) {
      if (chats.docs[i]
          .get('text')
          .toString()
          .toUpperCase()
          .contains(txt.toUpperCase())) {
        result = i;
      }
    }
    return result;
  }

  search(String searchString) {
    chatStream = FirebaseFirestore.instance.collection('chats').snapshots();
    if (searchString.length >= 1) {
      searchResult.clear();
      userChats.forEach((elementX) {
        String name = patient[elementX['patient_id']]['username']
            .toString()
            .toUpperCase();

        if (name.contains(searchString)) {
          searchResult.add(elementX);
        }
        FirebaseFirestore.instance
            .collection('chats')
            .doc(elementX['id'])
            .collection('messages')
            .orderBy('created_at', descending: true)
            .get()
            .then((value) {
          value.docs.forEach((element2) {
            String text = element2.get('text').toString().toUpperCase();
            if (text.contains(searchString.toUpperCase())) {
              if (searchResult == null || !searchResult.contains(elementX)) {
                searchResult.add(elementX);
              }
            }
          });
        });
      });
    } else {}
  }

  getDownloaded(String name) async {
    appDir = await getExternalStorageDirectory();
    localPath = '${appDir.path}/$name';
  }

  @action
  handleNotifications(String chatId, bool increase) {
    if (chatId.isEmpty) {
      chatId = mainStore.profileChat.id;
    }

    int ptnotf = 0;
    if (increase) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get()
          .then((value) {
        if (value.get('pt_notifications') != null) {
          ptnotf = value.get('pt_notifications') + 1;
        }

        value.reference.update({
          'pt_notifications': ptnotf,
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get()
          .then((value) {
        value.reference.update({
          'dr_notifications': 0,
        });
      });
    }
  }

  @action
  downloadFiles(String url, String name, String chatId, String message) async {
    DocumentSnapshot messageDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message)
        .get();

    await messageDoc.reference.update({'dr_download': 'await'});

    HttpClient httpClient = new HttpClient();

    appDir = await getExternalStorageDirectory();
    localPath = '${appDir.path}/$name';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      if (response.statusCode == 200) {
        bytes = consolidateHttpClientResponseBytes(response);
        file = File(localPath);
        bytes.then((value) {
          file.writeAsBytes(value);
        });
      } else {
        localPath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      localPath = 'Can not fetch url';
    }

    await messageDoc.reference.update({'dr_download': 'true'});
  }

  @action
  uploadFiles() async {
    result = await FilePicker.platform.pickFiles(
        withData: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpeg', 'jpg']);

    DocumentSnapshot _chat =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    if (result != null) {
      result.files.forEach((element) async {
        fileName = element.name;
        fileBytes = File(element.path);

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('chat/$chatId/files/$fileName');

        UploadTask uploadTask = firebaseStorageRef.putFile(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .add({
            "author": mainStore.authStore.viewDoctorId,
            "file": element.name,
            "image": null,
            "text": null,
            "id": null,
            "pt_download": 'false',
            "dr_download": 'false',
            "data": downloadURL,
            "extension": element.extension,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });
        });
        _chat.reference.update({
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
      DocumentSnapshot _docDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_chat['doctor_id'])
          .get();
      // FirebaseFunctions functions = FirebaseFunctions.instance;

      HttpsCallable messageNotification =
          FirebaseFunctions.instance.httpsCallable('messageNotification');
      String _ptId = _chat['patient_id'];
      String _text = '${_docDoc['username']}: [arquivo]';
      print('text $_text');
      print('drId $_ptId');
      try {
        print('no try');
        messageNotification.call({
          'senderId': _docDoc.id,
          'text': _text,
          'receiverId': _ptId,
          'receiverCollection': 'patients',
        });
        print('Notificação enviada');
      } on FirebaseFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e);
        print(e.code);
        print(e.message);
        print(e.details);
      } catch (e) {
        print('caught generic exception');
        print(e);
      }
      handleNotifications(chatId, true);
    }
  }

  @action
  getMessages(String id, name) async {
    chatTitle = name;
    chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(id).get();

    messagesDocs = await chatDoc.reference.collection('messages').get();
    // if (patient.isNotEmpty) {
    //   patAvatar = patient[chatDoc.get('patient_id')]['avatar'];
    // }

    Stream<QuerySnapshot> msgs = FirebaseFirestore.instance
        .collection('chats')
        .doc(id)
        .collection('messages')
        .orderBy('created_at', descending: false)
        .snapshots();
    msgs.listen((event) {
      event.docs.forEach((element) {
        chat.add(element);
      });
    });
  }

  @action
  pickImage(String chtId) async {
    if (await Permission.storage.request().isGranted) {
      setUploadSpin(true);

      File _imageFile;
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (pickedFile != null) _imageFile = File(pickedFile.path);

      if (_imageFile != null) {
        String now = DateFormat('yyyyMMdd_kkmm').format(DateTime.now());

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('chat/$chtId/images/$now/${_imageFile.path[0]}');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          DocumentSnapshot _chat = await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .get();

          _chat.reference.collection('messages').add({
            "author": mainStore.authStore.viewDoctorId,
            "image": '$now.jpeg',
            "data": downloadURL,
            "pt_download": 'false',
            "dr_download": 'false',
            "extension": null,
            "id": null,
            "text": null,
            "file": null,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });

          _chat.reference.update({
            'updated_at': FieldValue.serverTimestamp(),
          });

          DocumentSnapshot _docDoc = await FirebaseFirestore.instance
              .collection('doctors')
              .doc(_chat['doctor_id'])
              .get();

          // FirebaseFunctions functions = FirebaseFunctions.instance;

          HttpsCallable messageNotification =
              FirebaseFunctions.instance.httpsCallable('messageNotification');
          String _ptId = _chat['patient_id'];
          String _text = '${_docDoc['username']}: [imagem]';
          print('text $_text');
          print('drId $_ptId');
          try {
            print('no try');
            messageNotification.call({
              'senderId': _docDoc.id,
              'text': _text,
              'receiverId': _ptId,
              'receiverCollection': 'patients',
            });
            print('Notificação enviada');
          } on FirebaseFunctionsException catch (e) {
            print('caught firebase functions exception');
            print(e);
            print(e.code);
            print(e.message);
            print(e.details);
          } catch (e) {
            print('caught generic exception');
            print(e);
          }

          photo = downloadURL;
          setUploadSpin(false);
        });
      } else {
        setUploadSpin(false);
      }
      handleNotifications(chatId, true);
    }
  }

  @action
  getChats() {
    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('doctor_id', isEqualTo: mainStore.authStore.viewDoctorId)
        .snapshots();

    chatStream.listen((event1) {
      userChats.clear();
      event1.docs.forEach((element) {
        if (!userChats.contains(element.id)) {
          userChats.add(element.data());
        }

        Stream<DocumentSnapshot> patients = FirebaseFirestore.instance
            .collection('patients')
            .doc(element.get('patient_id'))
            .snapshots();

        patients.listen((event3) {
          if (!patient.keys.contains(event3.id)) {
            patient.addAll({event3.id: event3.data()});
          }
        });
      });
    });
  }

  @action
  chatsDispose() {
    if (mainStore.consultChat == false) {
      chat.clear();
      getChats();
      searchResult.clear();
      chatId = '';
      srch.clear();
      chatTitle = "Chat";
      text = null;
      file = null;
      emojisShowM = false;
      uploadSpin = false;
      photo = null;
    } else {
      getChats();
    }
  }

  sendMessage() async {
    if (chatId.isEmpty) {
      chatId = mainStore.profileChat.id;
    }

    DocumentSnapshot _chat =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    DocumentSnapshot _docDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(_chat['doctor_id'])
        .get();

    await _chat.reference.collection('messages').add({
      "author": mainStore.authStore.viewDoctorId,
      "text": text,
      "pt_download": 'false',
      "dr_download": 'false',
      "extension": null,
      "data": null,
      "id": null,
      "file": null,
      "image": null,
      "created_at": FieldValue.serverTimestamp(),
    }).then((value) async {
      await value.update({'id': value.id});
    });
    await _chat.reference.update({
      'updated_at': FieldValue.serverTimestamp(),
    });
    handleNotifications(chatId, true);

    // FirebaseFunctions functions = FirebaseFunctions.instance;

    HttpsCallable messageNotification =
        FirebaseFunctions.instance.httpsCallable('messageNotification');
    String _ptId = _chat['patient_id'];
    String _text = '${_docDoc['username']}: $text';
    print('text $_text');
    print('drId $_ptId');
    try {
      print('no try');
      messageNotification.call({
        'senderId': _chat['doctor_id'],
        'text': _text,
        'receiverId': _ptId,
        'receiverCollection': 'patients',
      });
      print('Notificação enviada');
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }

    text = null;
  }

  @action
  String messageTimer(Timestamp timer) {
    int now = Timestamp.now().millisecondsSinceEpoch;
    int sinceMillis = now - timer.millisecondsSinceEpoch;
    String time;

    if (sinceMillis <= 86400000) {
      time = 'Hoje';
    }

    if (sinceMillis >= 86400000 && sinceMillis <= 172800000) {
      time = 'Ontem';
    }
    if (sinceMillis > 172800000) {
      time = DateFormat('dd MMM', "pt_BR").format(timer.toDate());
    }
    return time;
  }

  startChat(String patID) async {
    DocumentSnapshot pat = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patID)
        .get();

    DocumentReference chat =
        await FirebaseFirestore.instance.collection('chats').add({
      'doctor_id': mainStore.authStore.viewDoctorId,
      'patient_id': pat.id,
      'pt_notifications': 0,
      'dr_notifications': 0,
      'updated_at': FieldValue.serverTimestamp(),
      'created_at': FieldValue.serverTimestamp(),
    });

    chatId = chat.id;
    await chat.update({'id': chatId});
    await getMessages(chatId, pat.get('username'));

    DocumentReference message = await chat.collection('messages').add({
      'text':
          '''Bem-vindo ao EncontrarCuidado, este é seu canal de comunicação com o Médico e sua equipe. Não forneça senhas de cartão ou dados bancários para desconhecidos.''',
      "pt_download": 'false',
      "dr_download": 'false',
      "extension": null,
      'image': null,
      "id": null,
      'file': null,
      "data": null,
      'author': mainStore.authStore.viewDoctorId,
      'created_at': FieldValue.serverTimestamp(),
    });
    await message.update({'id': message.id});
    handleNotifications(chatId, true);
    await mainStore.hasChatWith(patID);

    mainStore.profileChat = null;
    mainStore.hasChat = true;
    mainStore.chatName = null;
  }
}
