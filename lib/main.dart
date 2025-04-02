import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  // await dotenv.load();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('ja'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      child: ProviderScope(
        child: MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: FontFamily.unkemptBold,
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: ColorName.lightGrey,
              selectionHandleColor: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 50,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.hannah,
                fontFamilyFallback: [FontFamily.unkemptBold, FontFamily.ssronet],
              ),
              backgroundColor: ColorName.homeMainBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.unkemptBold,
                    fontFamilyFallback: [FontFamily.ssronet],
                  ),
                ),
              )
            ),
            scaffoldBackgroundColor: ColorName.homeMainBackground,
            dialogTheme: const DialogTheme(
              titleTextStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.unkemptBold,
                fontFamilyFallback: [FontFamily.ssronet],
                color: Colors.black,
              ),
              contentTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: FontFamily.unkemptBold,
                fontFamilyFallback: [FontFamily.ssronet],
                color: Colors.black,
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              labelMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.inter,
                height: 1.2,
              ),
              labelSmall: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.normal,
                height: 5/4,
                fontFamily: FontFamily.inter,
                color: Color(0xAA000000),
              ),
            ),
            cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
              primaryColor: Colors.black,
              brightness: Brightness.dark,
            ),

          ),
          routerConfig: Routes.getRouter,
        ),
      ),
    );
  }
}
