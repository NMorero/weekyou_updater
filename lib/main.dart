import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:weekyou_updater/global.dart';
import 'package:weekyou_updater/home.dart';

void main() {
  runApp(const MyApp());

  // Add this code below

  doWhenWindowReady(() {
    const initialSize = Size(500, 350);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CC.grey(),
        body: WindowBorder(
          color: CC.grey(),
          width: 1,
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [Expanded(child: MoveWindow()), const WindowButtons()],
                ),
              ),
              HomePage()
            ],
          ),
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: CC.white(),
    mouseOver: CC.white(),
    mouseDown: CC.white(),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: CC.white(),
  iconMouseOver: Colors.white,
);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //MinimizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
