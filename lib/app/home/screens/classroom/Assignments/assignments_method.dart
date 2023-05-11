import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future saveDirFiles({
  required List files,
  required String path,
}) async {
  files = await getDirFiles(path);
  List fileNames = [];
  List fileExt = [];
  print(files);
  if (files.isNotEmpty) {
    for (int i = 0; i < files.length; i++) {
      fileNames.add(files[i].path.split('/').last);

      fileExt.add(files[i].path.split('.').last);
    }
  }
  return [files, fileNames, fileExt];
}

Future<List<FileSystemEntity>> getDirFiles(String path) async {
  final dir = await getDirectory(path);

  final myDir = Directory(dir);

  final _folders = myDir.listSync(recursive: true, followLinks: false);
  print(_folders);
  return _folders;
}

Future<String> getDirectory(String path) async {
  final dir = await getApplicationDocumentsDirectory();
  final Directory folder = Directory('${dir.path}/$path/');
  if (await folder.exists()) {
    //if folder already exists return path
    return folder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder = await folder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

Future saveUploadedFiles(
    {required List files,
    required List fileNames,
    required String path}) async {
  final dir = await getDirectory(path);
  print(files);

  for (int i = 0; i < files.length; i++) {
    Uint8List fileBytes = files[i].readAsBytesSync();
    print(fileBytes);
    File file = await File('$dir/${fileNames[i]}').create();
    print(file);
    file = await File('$dir/${fileNames[i]}').writeAsBytes(fileBytes);
    print(File('$path/${fileNames[i]}'));
    print(file.path);
  }
}

Future uploadFiles(
    {required List files,
    required List fileNames,
    required List fileExt,
    required String firebasePath}) async {
  for (int i = 0; i < files.length; i++) {
    final storageRef =
        FirebaseStorage.instance.ref().child('$firebasePath/${fileNames[i]}');
    await storageRef.putFile(files[i]);
  }
}

Future generateLinks(
    {required List fileNames,
    required String firebasePath,
    required List fileLinks}) async {
  for (int i = 0; i < fileNames.length; i++) {
    final fileLink = await FirebaseStorage.instance
        .ref()
        .child('$firebasePath/${fileNames[i]}')
        .getDownloadURL();

    fileLinks.add(fileLink);
    print(fileLinks[i]);
  }
}

Future openFile(String fileName, String path, List files, int index) async {
  if (path.isNotEmpty) {
    final dir = await getDirectory(path);

    await OpenFilex.open('$dir/$fileName');
  } else {
    await OpenFilex.open(files[index].path);
  }
}

Future getStudentAssignment(
    String className, String title, String studentId) async {
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .ref()
      .child('assignments/Students/$className/$title/$studentId')
      .get();
  if (snapshot.exists) {
    final value = snapshot.value;
    Map json = value as Map;
    return json;
  } else {
    return {'fileLinks': []};
  }
}
