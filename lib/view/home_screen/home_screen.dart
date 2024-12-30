import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newapi_uisample/color_constant.dart';
import 'package:newapi_uisample/controller/home_carousel_controller.dart';
import 'package:newapi_uisample/controller/home_screen_controller.dart';
import 'package:newapi_uisample/view/home_screen/detail_screen/detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
   
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
       await context.read<HomeScreenController>().getNewsCategory();
       await context.read<HomeCarouselController>().getNewsCarousel();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final homeScreenState = context.watch<HomeScreenController>();

    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar:AppBar(
        backgroundColor: ColorConstant.secondaryColor,
        leading: Padding(
            padding: const EdgeInsets.only(top: 8,left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://images.pexels.com/photos/19384241/pexels-photo-19384241/free-photo-of-yana-kravchuk.jpeg"),
              radius: 22,
            ),
          ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text("FlashFeed",style:GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.mycolor) ,),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: ColorConstant.mycolor),
            onSelected: (selectedIndex) async {
              await context.read<HomeCarouselController>().onSourceSelection(clickedIndex: selectedIndex);
            },
            itemBuilder: (context) {
              return List.generate(
                HomeCarouselController.sourceList.length,
                (index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(
                    HomeCarouselController.sourceList[index],
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],

      ),
      body: homeScreenState.isLoading==true ? 
      Center(child:CircularProgressIndicator()) :
      
      
       SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(),
            SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("TOP CATEGORY",style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.mycolor),),
              ),
              SizedBox(height: 10),
              _buildCategorySection(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("TOP HEADLINES",style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.mycolor),),
              ),
              SizedBox(height: 10),
              //section carousel section
                _buildCarouselSection(),
              SizedBox(height: 20), 
              // section of categorynews
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Top News",style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.mycolor),),
              ),
              SizedBox(height: 20), 
              _buildAllCategorySection()
            ],
      ),
    )
    )
  );
}

  Padding _buildSearchSection() {
    return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: searchController,
                style: TextStyle(color: ColorConstant.mycolor),
                decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: ColorConstant.mycolor),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: ColorConstant.mycolor),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<HomeScreenController>().searchNews(value);
                  context.read<HomeCarouselController>().searchNews(value);
                }
              },
            ),
          );
  }

  Column _buildAllCategorySection() {
     final homeScreenState = context.watch<HomeScreenController>();
     if (homeScreenState.newsList?.articles == null) {
      return Column(
        children:  [
          Center(child: Text("No articles available")),
        ],
      );
    }
    String formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
    } catch (e) {
      return "";  // In case the date is invalid
    }
  }
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                homeScreenState.newsList!.articles!.length  , (index) =>
               Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailScreen(
                title: homeScreenState.newsList?.articles?[index].title ?? "",
                description: homeScreenState.newsList?.articles?[index].description ?? "",
                imageUrl: homeScreenState.newsList?.articles?[index].urlToImage ?? "",
                publishedAt: formatDate(homeScreenState.newsList?.articles?[index].publishedAt.toString() ?? ""),
                author: homeScreenState.newsList?.articles?[index].author ?? "",
                content:homeScreenState.newsList?.articles?[index].content ?? "" ,
                url: homeScreenState.newsList?.articles?[index].url ?? ""
              ),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstant.mycolor
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          child: CachedNetworkImage(
                            imageUrl: homeScreenState.newsList?.articles?[index].urlToImage?.toString() ?? "",
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 homeScreenState.newsList?.articles?[index].source?.name ?? "", 
                              style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600),),
                              SizedBox(height: 10),
                              Text(
                                 homeScreenState.newsList?.articles?[index].title ?? "",
                                style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                ),
                              SizedBox(height: 10),
                              Text(
                                 homeScreenState.newsList?.articles?[index].author ?? "", 
                              style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text( formatDate(homeScreenState.newsList?.articles?[index].publishedAt.toString() ?? ""),
                                  style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600),),
                                ],
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
                
              ),
            );
  }

  Widget _buildCarouselSection() {
   final homeCarouselState = context.watch<HomeCarouselController>();
  //  Check if carousel data is loading or null
  if (homeCarouselState.isCarousel || homeCarouselState.carouselModel?.articles == null) {
    return Center(child: CircularProgressIndicator());
  }

// Format the date using intl package
  String formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
    } catch (e) {
      return "";  // In case the date is invalid
    }
  }
    return  CarouselSlider(
              options: CarouselOptions(
              height: 270,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              autoPlayInterval: Duration(seconds: 3),
              ),
              items: List.generate(homeCarouselState.carouselModel!.articles!.length , (index) => InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailScreen(
                title: homeCarouselState.carouselModel!.articles![index].title ?? "",
                description: homeCarouselState.carouselModel!.articles![index].description ?? "",
                imageUrl: homeCarouselState.carouselModel!.articles![index].urlToImage ?? "",
                publishedAt: formatDate(homeCarouselState.carouselModel!.articles![index].publishedAt.toString()),
                author: homeCarouselState.carouselModel!.articles![index].author ?? "",
                content:homeCarouselState.carouselModel!.articles![index].content ?? "" ,
                url: homeCarouselState.carouselModel?.articles?[index].url ?? ""
              ),));
                },
                child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl:homeCarouselState.carouselModel!.articles![index].urlToImage ?? "",
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical:2),
                          child: Text(homeCarouselState.carouselModel?.articles?[index].source?.name ?? "", style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical:2),
                          child: Text(
                            homeCarouselState.carouselModel?.articles?[index].title ?? "",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical:2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Text(formatDate(homeCarouselState.carouselModel?.articles?[index].publishedAt.toString()),
                                  style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 10,)
                            ],
                          ),
                        )
                      ],
                    )
                ),
              )
              ),
          );
  }



  SingleChildScrollView _buildCategorySection() {
    return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                children: List.generate(HomeScreenController.categoryList.length, (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () async {
                       context.read<HomeScreenController>().onCategorySelection(clickedIndex: index);
                      
                    },
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorConstant.mycolor
                        ),
                      child: Center(child: Text(HomeScreenController.categoryList[index],style: TextStyle(fontWeight: FontWeight.w900,color: ColorConstant.secondaryColor,fontSize: 16),)),
                    ),
                  ),
                ),
                ),
              ),
            ),
          );
  }
}












