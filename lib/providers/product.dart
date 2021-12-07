import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imgURL;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imgURL,
    @required this.price,
    this.isFavourite = false,
  });

  void _setFavVal(bool newVal) {
    isFavourite = newVal;
    notifyListeners();
  }

  void toggleIsFav(String authToken, String userId) async {
    var oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse('url');

    try {
      final res = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      notifyListeners();

      if (res.statusCode >= 400) {
        _setFavVal(oldStatus);
      }
    } catch (err) {
      // print(err);
      _setFavVal(oldStatus);
    }
  }
}
