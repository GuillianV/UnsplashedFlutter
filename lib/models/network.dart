import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UnsplashedNetwork {
  String apiUrl = "https://api.unsplash.com";
  String clientId = dotenv.env['CLIENT_ID'] ?? "";

  int? itemPerPage;
  int? page;
  String? route;
  String usedUrl = "";

  UnsplashedNetwork();

  factory UnsplashedNetwork.Photo(int? itemPerPage, int? page) {
    UnsplashedNetwork unsplashedNetwork = UnsplashedNetwork();
    unsplashedNetwork.BuildBaseUrl("/photos");

    String querys = "?client_id=" + unsplashedNetwork.clientId;
    if (itemPerPage != null) {
      querys += "&page=" + page.toString();
    }
    if (page != null) {
      querys += "&per_page=" + itemPerPage.toString();
    }

    unsplashedNetwork.BuildQuerys(querys);
    return unsplashedNetwork;
  }

  factory UnsplashedNetwork.RandomPhoto() {
    UnsplashedNetwork unsplashedNetwork = UnsplashedNetwork();
    unsplashedNetwork.BuildBaseUrl("/photos/random");
    unsplashedNetwork.BuildQuerys("?client_id=" + unsplashedNetwork.clientId);
    return unsplashedNetwork;
  }

  void BuildBaseUrl(String? route) {
    if (route != null) {
      this.usedUrl = apiUrl + route;
    } else {
      this.usedUrl = apiUrl;
    }
  }

  void BuildQuerys(String? querys) {
    if (querys != null) {
      this.usedUrl += querys;
    }
  }

  String GetUrl() {
    return usedUrl;
  }
}
