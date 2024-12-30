import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newapi_uisample/color_constant.dart';
import 'package:newapi_uisample/controller/saved_controller.dart';
import 'package:newapi_uisample/view/saved_screen/saved_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;
  final String author;
  final String content;
  final String url;
  const DetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.author,
    required this.content, required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        iconTheme: IconThemeData(
          color: ColorConstant.mycolor,
        ),
        actions: [
          IconButton(onPressed: () {
            Share.share('check out my website https://example.com');
          }, icon:Icon(Icons.share, color: ColorConstant.mycolor)),
          // Icon(Icons.share, color: ColorConstant.mycolor),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.bookmark_add_outlined, color: ColorConstant.mycolor),
            onPressed: () {
              context.read<SavedController>().addSave(title: title, image:imageUrl,context: context,description: description,publishedAt:publishedAt,content: content,author: author, url: url);
               Navigator.push(context, MaterialPageRoute(builder: (context) => SavedScreen(),));
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 18, color: ColorConstant.mycolor),
                maxLines: 2),
            SizedBox(height: 10),
            Row(
              children: [
                Text(author,
                    style: GoogleFonts.montserrat(fontSize: 12, color: ColorConstant.mycolor)),
                Spacer(),
                Text(publishedAt,
                    style: GoogleFonts.montserrat(fontSize: 12, color: ColorConstant.mycolor)),
              ],
            ),
            SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(description,
                style: GoogleFonts.montserrat(fontSize: 14, color: ColorConstant.mycolor)),
            SizedBox(height: 20),
            Text(content,
                style: GoogleFonts.montserrat(fontSize: 14, color: ColorConstant.mycolor)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    final Uri articleUrl = Uri.parse(url); // Parse the URL
                      if (await canLaunchUrl(articleUrl)) {
                        await launchUrl(articleUrl); // Launch the URL in the browser
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not open the article")),
                        );
                      }
                    },
                  child: Text("Read more",style: GoogleFonts.montserrat(fontSize: 14, color: Colors.blue,fontWeight: FontWeight.bold))),
                SizedBox(width: 20)
              ],
            )
          ],
        ),
      ),
    );
  }
}




