import 'package:flutter/material.dart';
import 'package:newapi_uisample/color_constant.dart';
import 'package:newapi_uisample/view/home_screen/home_screen.dart';
import 'package:newapi_uisample/view/saved_screen/saved_screen.dart';

class BottomNavigationbarSCreen extends StatefulWidget {
  const BottomNavigationbarSCreen({super.key});

  @override
  State<BottomNavigationbarSCreen> createState() => _BottomNavigationbarSCreenState();
}

class _BottomNavigationbarSCreenState extends State<BottomNavigationbarSCreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorConstant.secondaryColor ,
        selectedItemColor:ColorConstant.mycolor ,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; 
          });
        },
        items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home,color: ColorConstant.mycolor,),
            label: 'Home',backgroundColor:ColorConstant.mycolor ,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add_outlined,color: ColorConstant.mycolor,),
            label: 'Saved',backgroundColor:ColorConstant.mycolor,
          ),
      ]),
      body: screens[currentIndex],
    );
  }
}