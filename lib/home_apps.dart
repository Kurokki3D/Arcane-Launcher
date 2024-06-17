import 'package:arcane/home_apps_stste.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeApps extends StatelessWidget {
  const HomeApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final appsinfo = ref.watch(homeappsProvider);

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: appsinfo.when(
            data: (List<Application> apps) => ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (BuildContext context, int index) {
                    ApplicationWithIcon app =
                        apps[index] as ApplicationWithIcon;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(children: [
                        Center(
                          child: Image.memory(
                            app.icon,
                            width: 55,
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
            error: (e, s) => Container(),
            loading: () => const CircularProgressIndicator()),
      );
    });
  }
}
