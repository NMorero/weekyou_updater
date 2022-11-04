import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';
import 'package:weekyou_updater/global.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _searching = true;
  String _downloadPercentage = "0.0";
  Future<void> _getLastUpdate() async {
    var res = await http.get(
      Uri.parse('${GD.url}/update/last'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Access-Control-Allow-Origin": "*"},
    );
    final body = jsonDecode(res.body);

    if (Platform.isLinux && !Platform.isAndroid) {
      _handleUpdateLinux(body["version"]);
    }
  }

  Future<void> _handleUpdateWindows(String version) async {
    Shell shell = Shell();
    await shell.run("whoami").then((value) async {
      final user = value.outText.split("\\");
      bool manifestExist = await File("C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\manifest.txt").exists();
      bool directoryExists = await Directory("C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou").exists();
      if (!directoryExists) {
        Directory("C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\updater").create(recursive: true);
      }
      if (manifestExist) {
        String manifest = await File("C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\manifest.txt").readAsString();
        if (manifest == version) {
          shell.run(""" start ..\\weekyou """);

          Timer(const Duration(seconds: 1), () {
            exit(0);
          });
          return;
        }
      }

      setState(() {
        _searching = false;
      });
      Dio dio = Dio();
      await dio.download("${GD.urlS3}/v$version/windows.zip", "C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\windows.zip",
          onReceiveProgress: (rec, total) {
        double percentage = (rec * 100) / total;
        setState(() {
          _downloadPercentage = percentage.toStringAsFixed(0);
        });
      }).then((res) async {
        //print(res.statusCode);
        if (res.statusCode == 200) {
          await shell.run(
              'tar -C "C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\" -xvf "C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\windows.zip" ');
          await shell.run('del C:\\Users\\${user.last.capitalize}\\ApelieApps\\Weekyou\\windows.zip');
          await File("/home/${value.outText}/ApelieApps/Weekyou/manifest.txt").writeAsString(version);
          shell.run(""" ../weekyou """);
          Timer(const Duration(seconds: 1), () {
            exit(0);
          });
        }
      });
    });
  }

  Future<void> _handleUpdateLinux(String version) async {
    Shell shell = Shell();
    await shell.run("whoami").then((value) async {
      bool manifestExist = await File("/home/${value.outText}/ApelieApps/Weekyou/manifest.txt").exists();
      bool directoryExists = await Directory("/home/ApelieApps").exists();
      if (!directoryExists) {
        Directory("/home/${value.outText}/ApelieApps/Weekyou").create(recursive: true);
      }
      if (manifestExist) {
        String manifest = await File("/home/${value.outText}/ApelieApps/Weekyou/manifest.txt").readAsString();
        if (manifest == version) {
          shell.run(""" ../weekyou """);

          Timer(const Duration(seconds: 1), () {
            exit(0);
          });
          return;
        }
      }

      setState(() {
        _searching = false;
      });
      Dio dio = Dio();

      await dio.download("${GD.urlS3}/v$version/linux.tar.gz", "/home/${value.outText}/ApelieApps/Weekyou/linux.tar.gz",
          onReceiveProgress: (rec, total) {
        double percentage = (rec * 100) / total;
        setState(() {
          _downloadPercentage = percentage.toStringAsFixed(0);
        });
      }).then((res) async {
        //print(res.statusCode);
        if (res.statusCode == 200) {
          await shell.run('tar -C "/home/${value.outText}/ApelieApps/Weekyou/" -xvf "/home/${value.outText}/ApelieApps/Weekyou/linux.tar.gz" ');
          await shell.run('rm "/home/${value.outText}/ApelieApps/Weekyou/linux.tar.gz"');
          await File("/home/${value.outText}/ApelieApps/Weekyou/manifest.txt").writeAsString(version);
          shell.run(""" ../weekyou """);
          Timer(const Duration(seconds: 1), () {
            exit(0);
          });
        }
      });
    });
    print("DONE");
  }

  @override
  void initState() {
    _getLastUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/APELIE_logo_claim_15.png",
            width: 300,
            color: CC.white(),
          ),
          if (_searching)
            Column(
              children: [
                CircularProgressIndicator(
                  color: CC.white(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Buscando actualizaciones",
                  style: TextStyle(color: CC.white()),
                )
              ],
            ),
          if (!_searching)
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Text(
                    "$_downloadPercentage %",
                    style: TextStyle(color: CC.white(), fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    value: double.parse(_downloadPercentage) / 100,
                    color: CC.white(),
                    backgroundColor: CC.white(opacity: 0.5),
                  )
                ],
              ),
            ),
          const Center()
        ],
      ),
    );
  }
}
