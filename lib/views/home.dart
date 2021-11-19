import 'package:flutter/material.dart';
import 'package:unsplashed/models/photo.dart';
import 'package:unsplashed/models/http';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

import 'package:unsplashed/widgets/infinite_grid_view.dart';

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
      body: Center(child: InfiniteGridView()),
    );
  }
}
