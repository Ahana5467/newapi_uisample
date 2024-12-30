

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:newapi_uisample/model/home_model.dart';

class HomeScreenController with ChangeNotifier{
  HomeModel? newsList;
  static List categoryList = [
    "All",
    "Business",
    "Entertainment",
    "General",
    "Science",
    "Sports",
    "Technology",
  ];
  int  selectedCategoryIndex = 0;
  bool isLoading = false;
  
 Future<void> getNewsCategory({String? category}) async {
  final url = Uri.parse(
    category == null || category == "All"
        ? "https://newsapi.org/v2/everything?q=all&apiKey=9a4a51dd1de9482f961c6e6aa30c61b8"
        : "https://newsapi.org/v2/everything?q=$category&apiKey=9a4a51dd1de9482f961c6e6aa30c61b8",
  );

    try{
      isLoading = true;
      notifyListeners();
   final response = await http.get(url);
   if(response.statusCode == 200){ 
    newsList = homeModelFromJson(response.body);
   }else{

   }
    }catch(e){
      log(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

Future<void> onCategorySelection({required int clickedIndex}) async{
  selectedCategoryIndex = clickedIndex;
  await getNewsCategory(category: selectedCategoryIndex == 0 ? null :categoryList[selectedCategoryIndex]);
  notifyListeners();
}


// Fetch news based on search query
  Future<void> searchNews(String query) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=$query&apiKey=9a4a51dd1de9482f961c6e6aa30c61b8",
    );

    try {
      // isLoading = true;
      // notifyListeners();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        newsList = homeModelFromJson(response.body);
      } else {
        log("Failed to fetch search results: ${response.statusCode}");
      }
    } catch (e) {
      log(e.toString());
    }
    //isLoading = false;
    notifyListeners();
  }


 
}






