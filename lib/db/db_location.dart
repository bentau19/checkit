import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class Loader {
  //////// get access from android users.
  Future<dynamic> androidAccess() async {
    Directory dir = (await getExternalStorageDirectory())!;
    String newPath = "";
    List<String> folders = dir.path.split("/");
    for (int i = 1; i < folders.length; i++) {
      String folder = folders[i];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    newPath = newPath + "/DataBase";
    dir = Directory(newPath);

    if (await Loader().storge(
      Permission.storage,
    )) if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return newPath;
  }

  //////// get access to the storge from both platforms.
  Future<bool> storge(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await permission.request();

      if (result == PermissionStatus.granted) {
        // Navigator.pushReplacementNamed(context, '/ToDo');
        return true;
      } else {
        print("not working");
        return false;
        //exit(0);
      }
    }
  }
}
