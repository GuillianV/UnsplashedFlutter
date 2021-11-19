import 'package:flutter/material.dart';
import 'package:unsplashed/models/photo.dart';
import 'package:unsplashed/models/http';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  late final int _defaultPhotosPerPageCount = 10;
  List<Photo> _photos = [];
  final int _nextPageThreshold = 5;

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    try {
      final fetchedPhotos = await http_get_Photos(pageNumber: _pageNumber);
      setState(
        () {
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: GridView.builder(
              itemCount: _photos.length,
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              // Generate 100 widgets that display their index in the List.

              itemBuilder: (context, index) {
                if (index == _photos.length - _nextPageThreshold) {
                  fetchPhotos();
                }
                final Photo photo = _photos[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: width,
                        height: height,
                        imageUrl: photo.fullUrl,
                        placeholder: (context, url) =>
                            BlurHash(hash: photo.blurHash),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
