import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: FontFamily.unkemptBold,
        ),
        routerConfig: Routes.getRouter,
        routeInformationParser: Routes.getRouter.routeInformationParser,
        routerDelegate: Routes.getRouter.routerDelegate,
      ),
    );
  }
}
