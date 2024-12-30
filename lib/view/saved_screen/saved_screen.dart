import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newapi_uisample/color_constant.dart';
import 'package:newapi_uisample/controller/saved_controller.dart';
import 'package:newapi_uisample/main.dart';
import 'package:newapi_uisample/view/home_screen/detail_screen/detail_screen.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
 
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<SavedController>().getSave();
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final savedScreenState = context.watch<SavedController>();
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Saved Articles", style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.w600,color: ColorConstant.mycolor),),
        backgroundColor:ColorConstant.secondaryColor,
        iconTheme: IconThemeData(
          color: ColorConstant.mycolor,
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(savedScreenState.savedItems.length, (index) => 
              
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: InkWell(
                onTap: () { Navigator.push(context,MaterialPageRoute(builder: (context) => DetailScreen(title:savedScreenState.savedItems[index]["title"] , description: savedScreenState.savedItems[index]["description"], imageUrl: savedScreenState.savedItems[index]["image"], publishedAt: savedScreenState.savedItems[index]["publishedAt"], author:savedScreenState.savedItems[index]["author"] , content: savedScreenState.savedItems[index]["content"],url: savedScreenState.savedItems[index]["url"],),));},
                 child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorConstant.mycolor
                               ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CachedNetworkImage(imageUrl: savedScreenState.savedItems[index]["image"])
                    ),
                    SizedBox(width: 10,),
                     Expanded(
                       child: Text(
                           savedScreenState.savedItems[index]["title"], 
                           style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600),
                           maxLines: 2,
                           ),
                     ),
                        SizedBox(width: 5),
                    
                      
                      IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              context.read<SavedController>().removeSave(savedScreenState.savedItems[index]["id"]);
                            },
                          ),
                    ]
                  ),
                               ),
               ),
             ),
            )
          )
          ),
      ),
      
    );
  }
}