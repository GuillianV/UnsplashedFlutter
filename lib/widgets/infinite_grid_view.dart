import 'package:flutter/material.dart';
import 'package:unsplashed/models/photo.dart';
import 'package:unsplashed/models/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

class InfiniteGridView extends StatefulWidget {
  InfiniteGridView({
    int? maxItemPerPage,
    int? nextPageThreshold,
  })  : _maxItemPerPage = maxItemPerPage ?? 10,
        _nextPageThreshold = nextPageThreshold ?? 5,
        super();

  final int _maxItemPerPage;
  final int _nextPageThreshold;

  @override
  State<StatefulWidget> createState() {
    return _InfiniteGridViewState();
  }
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  List<Photo> _photos = [];
  late final int _defaultPhotosPerPageCount = widget._maxItemPerPage;
  late final int _nextPageThreshold = widget._nextPageThreshold;

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

    return GridView.builder(
        itemCount: _photos.length,
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
              child: GestureDetector(
                onTap: () {
                  _save(photo.fullUrl);
                },
                child: Center(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                    imageUrl: photo.smallUrl,
                    placeholder: (context, url) =>
                        BlurHash(hash: photo.blurHash),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

_save(String url) async {
  var response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
  );
}
