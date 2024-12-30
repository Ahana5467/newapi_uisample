

// // import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:newapi_uisample/model/carousel_model.dart';

class HomeCarouselController with ChangeNotifier {
  static List sourceList = [
    "ars-technica",
    "associated-press",       
    "bbc-news",    
    "bbc-sport",        
  ];

  int selectedSourceIndex = 0;
  CarouselModel? carouselModel;
  bool isCarousel = false;

  Future<void> getNewsCarousel({String? sources}) async {
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=$sources&apiKey=9a4a51dd1de9482f961c6e6aa30c61b8");

    try {
      isCarousel = true;
      notifyListeners();

      final response = await http.get(url);

      if (response.statusCode == 200) {
        carouselModel = carouselModelFromJson(response.body);
      } else {
        log("Failed to fetch news: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching news: $e");
    }

    isCarousel = false;
    notifyListeners();
  }

  Future<void> onSourceSelection({required int clickedIndex}) async {
    selectedSourceIndex = clickedIndex;

    // Fetch the valid source ID from sourceList
    final selectedSource = sourceList[selectedSourceIndex];

    await getNewsCarousel(sources: selectedSource);
    notifyListeners();
  }


  Future<void> searchNews(String query) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=$query&apiKey=9a4a51dd1de9482f961c6e6aa30c61b8",
    );

    try {
       isCarousel = true;
       notifyListeners();

      final response = await http.get(url);
      if (response.statusCode == 200) {
        carouselModel = carouselModelFromJson(response.body);
      } else {
        log("Failed to fetch search results: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching search results: $e");
    } 
      isCarousel = false;
      notifyListeners();
    
  }
}
