import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:unsplashed/models/network.dart';
import './photo.dart';

Future<Photo> http_get_random_Photo([dynamic data]) async {
  //http.get(Uri.parse('https://api.unsplash.com/photos/random/?client_id=S_vBTCKYQ5qL4vgOVeFxK7-Zn-bXQRF-r8h7vi5u5dM'));
  //Uri uri = Uri.http("api.unsplash.com/photos", "/random", { "client_id" : "S_vBTCKYQ5qL4vgOVeFxK7-Zn-bXQRF-r8h7vi5u5dM"});
  var result =
      await http.get(Uri.parse(UnsplashedNetwork.RandomPhoto().GetUrl()));
  var decodeReesp = jsonDecode(result.body);
  return Photo.fromJson(decodeReesp);
}

Future<List<Photo>> http_get_Photos(
    {int perPage = 10, int pageNumber = 0, String? searchQuery}) async {
  var result = await http
      .get(Uri.parse(UnsplashedNetwork.Photo(perPage, pageNumber).GetUrl()));
  var decodeReesp = jsonDecode(result.body);
  return allFromJson(decodeReesp);
}
