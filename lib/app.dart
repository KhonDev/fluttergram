import 'package:flutter/material.dart';
import 'package:fluttergram/ui/navigation/main_navigation.dart';
import 'package:fluttergram/ui/screens/activity_feed/activity_feed_view_model.dart';
import 'package:fluttergram/ui/screens/auth/auth_view_model.dart';
import 'package:fluttergram/ui/screens/loader/loader_view_model.dart';
import 'package:fluttergram/ui/screens/profile/profile_view_model.dart';
import 'package:fluttergram/ui/screens/search/search_view_model.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static final MainNavigation navigation = MainNavigation();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => LoaderViewModel(context),
          lazy: false,
        ),
        Provider(create: (context) => AuthViewModel(context)),
        Provider(create: (_) => ActivityFeedViewModel()),
        ChangeNotifierProvider(create: (context) => UploadViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(accentColor: Colors.teal),
          primarySwatch: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
          ),
        ),
        navigatorKey: navigatorKey,
        routes: navigation.routes,
        initialRoute: navigation.initialRoute,
      ),
    );
  }
}
