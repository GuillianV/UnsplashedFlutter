import 'dart:convert';

import 'package:flutter/material.dart';

class Photo {
  String id;
  String? description;
  String? regularUrl;
  String fullUrl;
  String? rawUrl; //For downloading image only
  String? userName; //Attribution to the photographer
  String? userProfileUrl; //Photographer's profile
  String? userProfileImage; //Photographer's profile image
  int? likes;
  String? blurHash; //Optional
  String? downloadLocation; //Optional
  Color? color; //Optional

  Photo(this.id, this.fullUrl);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["id"], json["urls"]["full"]);
  }
}

List<Photo> allFromJson(List<dynamic> list) {
  return list.map((item) => Photo(item["id"], item["urls"]["full"])).toList();
}
