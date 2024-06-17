import 'package:arcane/app_state.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.Grid);

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  _AppsPageState createState() => _AppsPageState();
}

enum DisplayMode {
  Grid,
  List,
}

class _AppsPageState extends State<AppsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, _) {
        final appsInfo = ref.watch(appsProvider);
        final mode = ref.watch(modeProvider);
        return Scaffold(
          backgroundColor: const Color.fromARGB(148, 0, 0, 0),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            actionsIconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon:
                    Icon(mode == DisplayMode.Grid ? Icons.list : Icons.grid_on),
                onPressed: () {
                  ref.read(modeProvider.notifier).update((state) =>
                      mode == DisplayMode.Grid
                          ? DisplayMode.List
                          : DisplayMode.Grid);
                },
              )
            ],
          ),
          body: appsInfo.when(
            data: (List<Application> apps) => mode == DisplayMode.List
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      ApplicationWithIcon app =
                          apps[index] as ApplicationWithIcon;

                      return ListTile(
                        leading: Image.memory(
                          app.icon,
                          width: 40,
                        ),
                        title: Text(app.appName),
                        onTap: () => DeviceApps.openApp(app.packageName),
                      );
                    },
                    itemCount: apps.length,
                  )
                : GridView(
                    padding: const EdgeInsets.fromLTRB(
                        16.0, kToolbarHeight + 16.0, 16.0, 16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    children: [
                      ...apps.map((app) => AppGridItem(
                            application: app as ApplicationWithIcon,
                          ))
                    ],
                  ),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => Container(
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AppGridItem extends StatelessWidget {
  final ApplicationWithIcon? application;
  const AppGridItem({
    this.application,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DeviceApps.openApp(application!.packageName);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              application!.icon,
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
          Text(
            application!.appName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
