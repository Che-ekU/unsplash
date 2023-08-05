import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'package:ajay_kumar_flutter_task_round_1/shared-module/theme.dart';
import 'package:ajay_kumar_flutter_task_round_1/unsplash.dart';

///////////android_intent_plus, open_file  ////////////

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Plugin must be initialized before using
  // await FlutterDownloader.initialize(
  //     debug:
  //         true, // optional: set to false to disable printing logs to console (default: true)
  //     ignoreSsl:
  //         true // option: set to false to disable working with http links (default: false)
  //     );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UnsplashProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unsplash app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primaryColor,
            background: AppTheme.backGroundColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const _MyHomePage(),
      ),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  late final UnsplashProvider unsplashProvider;
  // late final Future<List<Photo>> fetchPhoto;
  // ReceivePort _port = ReceivePort();

  // @pragma('vm:entry-point')
  // static void downloadCallback(String id, int status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send?.send([id, status, progress]);
  // }

  @override
  void initState() {
    unsplashProvider = context.read<UnsplashProvider>();
    unsplashProvider.initializeSplash();
    // IsolateNameServer.registerPortWithName(
    //     _port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   String id = data[0];
    //   // DownloadTaskStatus status = DownloadTaskStatus.values(data[1]);
    //   int progress = data[2];
    //   // setState(() {});
    // });

    // FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    unsplashProvider.client.close();
    // IsolateNameServer.removePortNameMapping('downloader_send_port');
    _debounce?.cancel();
    super.dispose();
  }

  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      unsplashProvider.fetchPhotoByQuery(query);
    });
  }

  Future<String?> _getLocalImagePath(String imageUrl) async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
    return fileInfo?.file.path;
  }

  CroppedFile? _croppedFile;

  Future<void> _cropImage(String url) async {
    String? path = await _getLocalImagePath(url);
    if (path != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              activeControlsWidgetColor: AppTheme.primaryColor,
              toolbarTitle: 'Cropper',
              toolbarColor: AppTheme.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        _croppedFile = croppedFile;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        title: Column(
          children: [
            const Text("Search for images"),
            const SizedBox(
              height: 12,
            ),
            TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (input) {
                if (input.length > 2) {
                  _onSearchChanged(input);
                } else if (input.isEmpty) {
                  unsplashProvider.fetchFiveRandomPhotos();
                }
              },
              style: const TextStyle(
                color: AppTheme.backGroundColor,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppTheme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: "",
                hintText: "Type to search",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade100,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppTheme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppTheme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.search,
                    size: 24,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<List<Photo>>(
              future: unsplashProvider.fetchFiveRandomPhotos(),
              builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
                Widget child = const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: CircularProgressIndicator(),
                  ),
                );
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      child = Consumer<UnsplashProvider>(
                        builder: (context, unsplashProvider, child) {
                          return Column(
                            children: [
                              if (unsplashProvider.photos.isNotEmpty) ...[
                                for (Photo photo in unsplashProvider.photos)
                                  CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    progressIndicatorBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress.progress == 1) {}
                                      return const SizedBox();
                                    },
                                    imageBuilder: (context, imageProvider) {
                                      return Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          if (frame != null) {
                                            return Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: AppTheme
                                                            .primaryColor,
                                                      )),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 12,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: child,
                                                  ),
                                                ),
                                                FutureBuilder(
                                                  future: Future.delayed(
                                                    const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox();
                                                    } else {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _Action(
                                                            icon: Icons.crop,
                                                            ontap: () async {
                                                              // await precacheImage(
                                                              //     NetworkImage(
                                                              //       photo
                                                              //           .urls.full
                                                              //           .toString(),
                                                              //     ),
                                                              //     context);
                                                              await _cropImage(
                                                                photo.urls
                                                                    .regular
                                                                    .toString(),
                                                              );
                                                              Uint8List? image =
                                                                  await _croppedFile
                                                                      ?.readAsBytes();
                                                              if (_croppedFile !=
                                                                  null) {
                                                                // ignore: use_build_context_synchronously
                                                                await showGeneralDialog(
                                                                  context:
                                                                      context,
                                                                  pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) {
                                                                    return FutureBuilder(
                                                                      future:
                                                                          _getLocalImagePath(
                                                                        _croppedFile!
                                                                            .path,
                                                                      ),
                                                                      builder: (context,
                                                                          AsyncSnapshot
                                                                              snapshot) {
                                                                        if (snapshot.connectionState ==
                                                                            ConnectionState.done) {
                                                                          return BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                                            child:
                                                                                Container(
                                                                              color: Colors.black38,
                                                                              padding: const EdgeInsets.all(20.0),
                                                                              child: Stack(
                                                                                alignment: Alignment.center,
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: Alignment.topLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 6.0, top: 40),
                                                                                      child: _Action(
                                                                                        ontap: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        icon: Icons.arrow_back,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Image.memory(
                                                                                    height: MediaQuery.of(context).size.height * 0.7,
                                                                                    image!,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 12.0),
                                                                                    child: Align(
                                                                                      alignment: Alignment.bottomRight,
                                                                                      child: _Action(
                                                                                        ontap: () async {
                                                                                          Directory directory = await getApplicationDocumentsDirectory();
                                                                                          // await unsplashProvider.client.photos.download(photo.id).goAndGet().then((value) async {
                                                                                          //   final taskId =
                                                                                          // await FlutterDownloader.enqueue(
                                                                                          //   saveInPublicStorage: true,
                                                                                          //   fileName: photo.id,
                                                                                          //   url: photo.urls.small.toFilePath(),
                                                                                          //   savedDir: directory.path,
                                                                                          //   showNotification: true,
                                                                                          //   openFileFromNotification: true,
                                                                                          // );
                                                                                          // });
                                                                                          Uint8List bytes = await _croppedFile!.readAsBytes();
                                                                                          var result = await ImageGallerySaver.saveImage(bytes, quality: 100, name: photo.id);
                                                                                          if (result["isSuccess"] == true) {
                                                                                            Navigator.of(context).pop();
                                                                                            showToastWidget(
                                                                                              const Toast(),
                                                                                            );
                                                                                          } else {
                                                                                            print(result["errorMessage"]);
                                                                                          }
                                                                                        },
                                                                                        icon: Icons.download,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return const CircularProgressIndicator();
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ).then((value) {
                                                                  _croppedFile =
                                                                      null;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          _Action(
                                                            icon:
                                                                Icons.download,
                                                            ontap: () async {
                                                              // await FlutterDownloader
                                                              //     .enqueue(
                                                              //   saveInPublicStorage:
                                                              //       true,
                                                              //   fileName:
                                                              //       photo.id,
                                                              //   url: photo
                                                              //       .urls.small
                                                              //       .toString(),
                                                              //   savedDir:
                                                              //       "data/user/0/com.example.ajay_kumar_flutter_task_round_1/app_flutter",
                                                              //   showNotification:
                                                              //       false,
                                                              //   openFileFromNotification:
                                                              //       false,
                                                              // );

                                                              String? path =
                                                                  await _getLocalImagePath(photo
                                                                      .urls
                                                                      .regular
                                                                      .toString());

                                                              File file =
                                                                  File(path!);

                                                              Uint8List bytes =
                                                                  await file
                                                                      .readAsBytes();

                                                              var result =
                                                                  await ImageGallerySaver
                                                                      .saveImage(
                                                                bytes,
                                                                quality: 100,
                                                                name: photo.id,
                                                              );
                                                              if (result[
                                                                  'isSuccess']) {
                                                                showToastWidget(
                                                                  const Toast(),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      );
                                    },
                                    imageUrl: photo.urls.regular.toString(),
                                  ),
                                const SizedBox(height: 6),
                              ] else
                                const Center(
                                  child: Text(
                                    "No results found",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                            ],
                          );
                        },
                      );
                    }
                    return child;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Toast extends StatelessWidget {
  const Toast({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(12),
            width: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor[600]!),
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(
                      Icons.check,
                      color: AppTheme.primaryColor[600],
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Download successful!",
                      style: TextStyle(
                        color: AppTheme.primaryColor[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.ontap,
    required this.icon,
  });

  final Function ontap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.15,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.white30,
              shape: BoxShape.circle,
              border: Border.all(),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor[100]!.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppTheme.primaryColor[50]!.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 12),
                ),
              ]),
          child: IconButton(
            iconSize: 24,
            color: Colors.black,
            onPressed: () {
              ontap();
            },
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
