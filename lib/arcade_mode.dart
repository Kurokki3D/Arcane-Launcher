import 'package:arcane/arcade_home_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:sqflite/sqflite.dart';

class ArcadeMode extends StatefulWidget {
  const ArcadeMode({super.key});

  @override
  State<ArcadeMode> createState() => _ArcadeModeState();
}

class _ArcadeModeState extends State<ArcadeMode> {
  Artboard? riveArtboard;
  SMIBool? shiftMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.load('assets/animations/lever.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controler =
          StateMachineController.fromArtboard(artboard, 'StateOfLever');
      if (controler != null) {
        artboard.addController(controler);
        shiftMode = controler.findSMI('on off');
        setState(() {
          riveArtboard = artboard;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(176, 0, 0, 0),
      body: Stack(children: [
        Align(
          alignment: const Alignment(1, 0),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: const Scaffold(
                backgroundColor: Colors.transparent, body: ArcadeHomeApps()),
          ),
        ),

        //the Switch
        Align(
          alignment: const Alignment(-1, 1),
          child: SizedBox(
            height: 120,
            width: 60,
            child: GestureDetector(
              child: riveArtboard == null
                  ? const SizedBox()
                  : Container(
                      color: Colors.transparent,
                      height: 120,
                      width: 60,
                      child: Rive(
                          alignment: Alignment.center, artboard: riveArtboard!),

                      // const RiveAnimation.asset('assets/animations/lever.riv'),
                    ),
              onLongPress: () {
                setState(() {
                  shiftMode?.value == true
                      ? shiftMode?.value = false
                      : shiftMode?.value = true;
                });

                Future.delayed(const Duration(seconds: 1),
                    () => Navigator.pushNamed(context, 'test launch'));

                // if (shiftMode?.value == true) {
                //   shiftMode?.value = false;
                // }
              },
            ),
          ),
        ),
      ]),
    );
  }
}
