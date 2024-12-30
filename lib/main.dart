import 'package:flutter/material.dart';
import 'package:newapi_uisample/controller/home_carousel_controller.dart';
import 'package:newapi_uisample/controller/home_screen_controller.dart';
import 'package:newapi_uisample/controller/saved_controller.dart';
import 'package:newapi_uisample/view/bottom_navigationbar_screen/bottom_navigationbar_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedController.initDb();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) => HomeScreenController()),
        ChangeNotifierProvider(create:(context) => HomeCarouselController()),
        ChangeNotifierProvider(create:(context) => SavedController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomNavigationbarSCreen(),
      ),
    );
  }
}