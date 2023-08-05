import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashProvider extends ChangeNotifier {
  List<Photo> photos = [];
  late UnsplashClient client;
  bool isImageLoading = true;
  notify() => notifyListeners();
  void initializeSplash() async {
    AppCredentials appCredentials = loadAppCredentialsFromEnv();
    // Create a client.
    client = UnsplashClient(
      settings: ClientSettings(credentials: appCredentials),
    );
  }

  Future<List<Photo>> fetchPhotoByQuery(String query) async {
    SearchResults<Photo>? results;
    try {
      results = await client.search.photos(query).goAndGet();
    } catch (e) {
      print(e);
    }
    if (results != null) {
      photos = results.results;
    }
    notifyListeners();
    return photos;
  }

  Future<List<Photo>> fetchFiveRandomPhotos() async {
    // Fetch 5 random photos by calling `goAndGet` to execute the [Request]
    // returned from `random` and throw an exception if the [Response] is not ok.
    try {
      photos = await client.photos.random(count: 5).goAndGet();
    } catch (e) {
      print(e);
    }
    // print('--- Photos');
    // print(photos);
    // print('---\n');
    notifyListeners();
    return photos;
    // // Do something with the photos.

    // Create a dynamically resizing url.
    // final resizedUrl = photos.first.urls.raw.resizePhoto(
    //   width: 400,
    //   height: 400,
    //   fit: ResizeFitMode.clamp,
    //   format: ImageFormat.webp,
    // );
    // print('--- Resized Url');
    // print(resizedUrl);
  }

  AppCredentials loadAppCredentialsFromEnv() {
    // const accessKey = 'b7GAXRe9HWiScHGYQnikktJQUMEXttv93gVRKtVXnCM';
    // const secretKey = 'F6uHapQlhBUbQcGk9dbs5ToBdL66uDPvUiGOZfFHM_0';
    const accessKey = 'b7GAXRe9HWiScHGYQnikktJQUMEXttv93gVRKtVXnCM';
    const secretKey = 'F6uHapQlhBUbQcGk9dbs5ToBdL66uDPvUiGOZfFHM_0';

    return const AppCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  /// Loads [AppCredentials] from a json file with the given [fileName].
  // Future<AppCredentials> loadAppCredentialsFromFile(String fileName) async {
  //   final file = File(fileName);
  //   final content = await file.readAsString();
  //   final json = jsonDecode(content) as Map<String, dynamic>;
  //   return AppCredentials.fromJson(json);
  // }
}
