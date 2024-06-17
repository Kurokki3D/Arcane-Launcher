import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

import 'package:arcane/home_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestLaunch extends StatefulWidget {
  const TestLaunch({super.key});

  @override
  State<TestLaunch> createState() => _TestLaunchState();
}

class _TestLaunchState extends State<TestLaunch> {
  String greet = "";
  late Timer _timer;
  String formattedDate = '';

//for the lever switch
  Artboard? riveArtboard;
  StateMachineController? _controller;
  SMIBool? shiftMode;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        formattedDate =
            DateFormat(' MMM d                  kk:mm:ss').format(now);

        //greet = "Periodic${DateTime.now().second}";
      });
    });

    //initializing variables for the lever switch
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
    return Stack(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dy > sensitivity) {
              // Down Swipe
            } else if (details.delta.dy < -sensitivity) {
              // Up Swipe
              Navigator.pushNamed(context, 'apps');
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.apps),
              onPressed: () => Navigator.pushNamed(context, 'apps'),
            ),
            body: Container(
              color: const Color.fromARGB(77, 0, 0, 0),
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0.5, 0.045),
                    child:
                        SvgPicture.asset('assets/images/svg/middle_line.svg'),
                  ),
                  Align(
                    alignment: const Alignment(0.545, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/svg/top_line.svg'),
                          const SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset('assets/images/svg/pointer.svg'),
                          const SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset('assets/images/svg/bottom_line.svg'),
                        ]),
                  ),

                  //time and date

                  Align(
                    alignment: const Alignment(0.45, 0),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        formattedDate,
                        //'10:20',
                        style: const TextStyle(
                            fontSize: 40,
                            color: Color.fromARGB(255, 169, 198, 255)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(1, 0),
          child: Container(
            height: double.infinity,
            width: 100,
            color: Colors.transparent,
            padding: const EdgeInsets.only(top: 150, bottom: 150),
            child: const Scaffold(
                backgroundColor: Colors.transparent, body: HomeApps()),
          ),
        ),
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
                    () => Navigator.pushNamed(context, 'arcade mode'));

                // if (shiftMode?.value == true) {
                //   shiftMode?.value = false;
                // }
              },
            ),
          ),
        )
      ],
    );
  }
}
