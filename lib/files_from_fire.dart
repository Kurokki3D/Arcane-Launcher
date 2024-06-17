// import 'dart:html';
// import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';

// import 'package:dio/dio.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:cached_network_image/cached_network_image.dart';

// class FromFire extends StatefulWidget {
//   const FromFire({super.key});

//   @override
//   State<FromFire> createState() => _FromFireState();
// }

// class _FromFireState extends State<FromFire> {
//   late String imageUrl;
//   final storage = FirebaseStorage.instance;

//   @override
//   void initState() {
//     super.initState();
//     //set the initial value of the url to a empty string
//     imageUrl = "";
//     //retreave the image from the firebase storage
//     getImageUrl();
//   }

//   Future<void> getImageUrl() async {
//     //get the refrence to the image filr in firebase storage
//     final ref = (storage.ref().child('files/broly.png'));
//     //get the imageurl to download url
//     final url = await ref.getDownloadURL();
//     setState(() {
//       imageUrl = url;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//             child: Image.network(
//           imageUrl,
//           fit: BoxFit.cover,
//         )),
//       ],
//     );
//   }
// }

class FilesFromFire extends StatefulWidget {
  const FilesFromFire({super.key});

  @override
  State<FilesFromFire> createState() => _FilesFromFireState();
}

class _FilesFromFireState extends State<FilesFromFire> {
  late Future<ListResult> futureFiles;
  Map<int, double> downloadprogress = {};

  // final Dio dio = Dio();
  // bool loading = false;
  // double progress = 0;

  // Future<bool> saveVideo(String url, String fileName) async {
  //   Directory directory;
  //   try {
  //     if (await _requestPermission(Permission.storage)) {
  //       directory = (await getExternalStorageDirectory())!;

  //       String newPath = "";
  //       List<String> paths = directory.path.split("/");

  //       // /storage/emulated/0/Android/data/com.example.arcane/files
  //       for (int x = 1; x < paths.length; x++) {
  //         String folder = paths[x];
  //         if (folder != "Android") {
  //           newPath += "/" + folder;
  //         } else {
  //           break;
  //         }
  //       }
  //       newPath = newPath + "/Arcane_Characters";
  //       directory = Directory(newPath);
  //       print(directory.path);
  //     } else {
  //       return false;
  //     }

  //     File saveFile = File(directory.path + "/$fileName");

  //     if (!await directory.exists()) {
  //       await directory.create(recursive: true);
  //     }
  //     if (await directory.exists()) {
  //       await dio.download(url, saveFile.path,
  //           onReceiveProgress: (value1, value2) {
  //         setState(() {
  //           progress = value1 / value2;
  //         });
  //       });

  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  //   return false;
  // }

  // Future downloadFile(Reference ref) async {
  //   final url = await ref.getDownloadURL();

  //   setState(() {
  //     loading = true;
  //   });

  //   bool downloaded = await saveVideo(url, ref.name);

  //   if (downloaded) {
  //     print("File Downloaded");
  //   } else {
  //     print("Problem Downloading File");
  //   }

  //   setState(() {
  //     loading = false;
  //   });

  //   // final url = await ref.getDownloadURL();
  //   // final tempdir = await getTemporaryDirectory();
  //   // final path = '${tempdir.path}/${ref.name}';

  //   // await Dio().download(url, path);

  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   SnackBar(
  //   //     content: Text('downloaded ${ref.name}'),
  //   //   ),
  //   // );
  // }

  Future<String> getImageUrl(String imageName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('files/$imageName');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return "https://firebasestorage.googleapis.com/v0/b/arcane-launcher.appspot.com/o/broly.png?alt=media&token=e126586c-4e34-47af-adf2-45f091be9745";
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
    loadImage('punch girl.png');
  }

  Future<void> loadImage(String nam) async {
    final url = await getImageUrl(nam); // Adjust the image name accordingly
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureFiles,
      builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No data"),
            );
          }

          final files = snapshot.data!.items;

          return ListWheelScrollView.useDelegate(
              itemExtent: 400,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.006,
              onSelectedItemChanged: (index) {
                final car = files[index];
                setState(() {
                  loadImage(car.name);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: files.length,
                builder: (context, index) {
                  final file = files[index];

                  return Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      //color: Colors.amber,
                      image: DecorationImage(
                          image: AssetImage("assets/images/oura.png")),
                      borderRadius: BorderRadius.all(
                        Radius.circular(31),
                      ),
                    ),
                    child: imageUrl != null
                        ?
                        //Stack(children: [
                        CachedNetworkImage(
                            width: double.infinity,
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        // Card(
                        //   child: ListTile(
                        //     title: Text(file.name),
                        //     trailing: IconButton(
                        //       icon: Icon(Icons.download),
                        //       onPressed: () {
                        //         print('downloading');
                        //         print(file);

                        //         //downloadFile();
                        //         //downloadFile(file);
                        //       },
                        //     ),
                        //   ),
                        // ),
                        //])
                        : CircularProgressIndicator(),

                    //     Card(
                    //   color: Colors.transparent,
                    //   child: ListTile(
                    //     title: Text(file.name),
                    //     trailing: IconButton(
                    //       icon: Icon(Icons.download),
                    //       onPressed: () {
                    //         print('downloading');
                    //         print(file);

                    //         //downloadFile();
                    //         //downloadFile(file);
                    //       },
                    //     ),
                    //   ),
                    // ),
                  );
                },
              ));
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('No internet Conection'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
