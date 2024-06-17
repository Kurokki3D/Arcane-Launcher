import 'package:arcane/apps_page.dart';
import 'package:arcane/home_apps_stste.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ArcadeHomeApps extends StatefulWidget {
  const ArcadeHomeApps({super.key});

  @override
  State<ArcadeHomeApps> createState() => _ArcadeHomeAppsState();
}

class _ArcadeHomeAppsState extends State<ArcadeHomeApps> {
  List<String> character = [
    "assets/images/toppng.png",
    "assets/images/goku.png",
    "assets/images/broly.png",
    "assets/images/grandpa.png",
    "assets/images/naruto.png"
  ];

  int inntex = 1;
  int character_num = 0;
  Widget thing = Placeholder();
  late ApplicationWithIcon centerApp;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final appsinfo = ref.watch(homeappsProvider);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: appsinfo.when(
            data: (List<Application> apps) => Stack(children: [
              InkWell(
                onDoubleTap: () {
                  Navigator.pushNamed(context, 'Login form');
                },
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    child: Image(
                      image: AssetImage(character[character_num]),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.65, 0.005),
                child: SvgPicture.asset('assets/images/svg/arcane_middle.svg'),
              ),
              Align(
                alignment: Alignment(0.45, -0.02),
                child: SvgPicture.asset('assets/images/svg/arcane_pointer.svg'),
              ),
              Align(
                alignment: const Alignment(0.75, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/svg/arcane_top.svg'),
                      const SizedBox(
                        height: 70,
                      ),
                      SvgPicture.asset('assets/images/svg/arcane_bottom.svg'),
                    ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  color: Colors.black12,
                  width: 100,
                  height: 100,
                  child: Center(
                    child: thing,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: 130,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 150,
                    onSelectedItemChanged: (index) {
                      print('selected item $index');
                      setState(() {
                        if (character_num < 4) {
                          character_num++;
                        } else {
                          character_num = 0;
                        }

                        // character_num == 0
                        //     ? character_num = 1
                        //     : character_num = 0;

                        inntex = index;
                        if (inntex == inntex++) {
                          inntex = index++;
                        }

                        if (inntex == inntex--) {
                          inntex = index--;
                        }
                      });
                    },
                    offAxisFraction: -1.4,
                    physics: const FixedExtentScrollPhysics(),
                    perspective: 0.005,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: apps.length,
                      builder: (BuildContext context, int index) {
                        ApplicationWithIcon app =
                            apps[index] as ApplicationWithIcon;

                        centerApp = apps[inntex] as ApplicationWithIcon;
                        // if (apps[index] == 0) {
                        //   centerApp = apps[index] as ApplicationWithIcon;
                        // } else {
                        //   centerApp = apps[index + 3] as ApplicationWithIcon;
                        // }

                        thing = Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Stack(children: [
                            InkWell(
                              onTap: () =>
                                  DeviceApps.openApp(centerApp.packageName),
                              child: Center(
                                child: Image.memory(
                                  centerApp.icon,
                                  width: 55,
                                ),
                              ),
                            ),
                            ListTile(
                              // title: Text(app.appName),
                              onTap: () =>
                                  DeviceApps.openApp(centerApp.packageName),
                            ),
                          ]),
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Stack(children: [
                            InkWell(
                              onTap: () => DeviceApps.openApp(app.packageName),
                              child: Center(
                                child: Image.memory(
                                  app.icon,
                                  width: 55,
                                ),
                              ),
                            ),
                            ListTile(
                              // title: Text(app.appName),
                              onTap: () => DeviceApps.openApp(app.packageName),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ]),
            error: (e, s) => Container(),
            loading: () => const CircularProgressIndicator(),
          ),
          drawer: const AppsPage(),
        );
      },
    );
  }
}
