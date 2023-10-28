import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
part 'suport_store.g.dart';

class SuportStore = _SuportStoreBase with _$SuportStore;

abstract class _SuportStoreBase with Store {
  final AuthStore authStore = Modular.get();

  @observable
  bool emojisShow = false;
  @observable
  TextEditingController txtcontrol = TextEditingController();
  @observable
  String text;
  @observable
  bool uploadSpin = false;
  @observable
  bool downloadSpin = false;
  @observable
  String photo;
  @observable
  FilePickerResult result;
  @observable
  File fileBytes;
  @observable
  String fileName;
  @observable
  String supportTitle = 'Suporte';
  @observable
  String localPath;
  @observable
  Directory appDir;
  @observable
  Future<Uint8List> bytes;
  @observable
  File file;

  Future<bool> clearNotifications() async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    await _user.reference.update({'support_notifications': 0});

    return true;
  }

  @action
  supportDispose() {
    // chat.clear();
    // messagesDocs = null;
    // supportDoc = null;
    fileName = null;
    fileBytes = null;
    photo = null;
    result = null;
    txtcontrol.clear();
    text = null;
    file = null;
    emojisShow = false;
    uploadSpin = false;
    photo = null;
  }

  @action
  setText(String tx) => text = tx;
  @action
  setEmojisShow(bool sh) => emojisShow = sh;
  @action
  setUploadSpin(bool sh) => uploadSpin = sh;

  @action
  onBackspacePressed() {
    txtcontrol
      ..text = txtcontrol.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtcontrol.text.length));
  }

  @action
  getDownloaded(String name) async {
    appDir = await getExternalStorageDirectory();
    localPath = '${appDir.path}/$name';
  }

  @action
  downloadFiles(String url, String name, String id, String message) async {
    DocumentSnapshot messageDoc = await FirebaseFirestore.instance
        .collection('support')
        .doc(id)
        .collection('messages')
        .doc(message)
        .get();

    await messageDoc.reference.update({'user_download': 'await'});

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

    await messageDoc.reference.update({'user_download': 'true'});
  }

  @action
  handleNotifications(String id, bool increase) {
    int drnotf = 0;
    if (increase) {
      FirebaseFirestore.instance
          .collection('support')
          .doc(id)
          .get()
          .then((value) {
        if (value.get('sp_notifications') != null) {
          drnotf = value.get('sp_notifications') + 1;
        }

        value.reference.update({
          'sp_notifications': drnotf,
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('support')
          .doc(id)
          .get()
          .then((value) {
        value.reference.update({
          'usr_notifications': 0,
        });
      });
    }
  }

  sendMessage(String id) async {
    String avatar;
    DocumentSnapshot patDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    avatar = patDoc.get('avatar');

    await FirebaseFirestore.instance.collection('support').doc(id).update({
      'updated_at': FieldValue.serverTimestamp(),
    });

    if (avatar == null) {
      avatar =
          'https://firebasestorage.googleapis.com/v0/b/encontrar-cuidado-project.appspot.com/o/settings%2FuserDefaut.png?alt=media&token=4c4aa544-555a-4c1d-bef1-0b61a1e2dc10';
    }

    DocumentSnapshot _support =
        await FirebaseFirestore.instance.collection('support').doc(id).get();

    await _support.reference.collection('messages').add({
      "author": authStore.user.uid,
      "text": text,
      "user_download": 'false',
      "sp_download": 'false',
      "extension": null,
      "data": null,
      "id": null,
      "file": null,
      "image": null,
      "created_at": FieldValue.serverTimestamp(),
    }).then((value) {
      value.update({'id': value.id});
    });

    // DocumentSnapshot _docDoc = await FirebaseFirestore.instance
    //     .collection('doctors')
    //     .doc(_support['doctor_id'])
    //     .get();
    // FirebaseFunctions functions = FirebaseFunctions.instance;

    // HttpsCallable supportNotification =
    //     FirebaseFunctions.instance.httpsCallable('supportNotification');
    // String _text = '${_docDoc['username']}: $text';
    // print('text $_text');
    // try {
    //   print('no try');
    //   await supportNotification.call({
    //     'text': _text,
    //     'receiverId': 'support',
    //   });
    //   print('Notificação enviada');
    // } on FirebaseFunctionsException catch (e) {
    //   print('caught firebase functions exception');
    //   print(e);
    //   print(e.code);
    //   print(e.message);
    //   print(e.details);
    // } catch (e) {
    //   print('caught generic exception');
    //   print(e);
    // }

    text = null;
    handleNotifications(id, true);
  }

  @action
  pickImage(String id) async {
    if (await Permission.storage.request().isGranted) {
      setUploadSpin(true);

      File _imageFile;
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (pickedFile != null) _imageFile = File(pickedFile.path);

      if (_imageFile != null) {
        String now = DateFormat('yyyyMMdd_kkmm').format(DateTime.now());

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('support/$id/images/$now/${_imageFile.path[0]}');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          await FirebaseFirestore.instance
              .collection('support')
              .doc(id)
              .collection('messages')
              .add({
            "author": authStore.user.uid,
            "image": '$now.jpeg',
            "data": downloadURL,
            "user_download": 'false',
            "sp_download": 'false',
            "extension": null,
            "id": null,
            "text": null,
            "file": null,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });
          await FirebaseFirestore.instance
              .collection('support')
              .doc(id)
              .update({
            'updated_at': FieldValue.serverTimestamp(),
          });

          photo = downloadURL;
          setUploadSpin(false);
        });
      } else {
        setUploadSpin(false);
      }
      handleNotifications(id, true);
    }
  }

  @action
  uploadFiles(String id) async {
    result = await FilePicker.platform.pickFiles(
        withData: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpeg', 'jpg']);

    if (result != null) {
      result.files.forEach((element) async {
        fileName = element.name;
        fileBytes = File(element.path);

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('support/$id/files/$fileName');

        UploadTask uploadTask = firebaseStorageRef.putFile(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          await FirebaseFirestore.instance
              .collection('support')
              .doc(id)
              .collection('messages')
              .add({
            "author": authStore.user.uid,
            "file": element.name,
            "image": null,
            "text": null,
            "id": null,
            "user_download": 'false',
            "sp_download": 'false',
            "data": downloadURL,
            "extension": element.extension,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });
        });
        await FirebaseFirestore.instance.collection('support').doc(id).update({
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
      handleNotifications(id, true);
    }
  }
}
