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
import 'package:what_the_banana/ui/banana_status_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // 시스템 상태바 숨김 — 커스텀 바나나 상단바로 대체(하단 내비는 유지).
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

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
              cursorColor: Colors.black,
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
              ),
            ),
            scaffoldBackgroundColor: ColorName.homeMainBackground,
            dialogTheme: const DialogThemeData(
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
          // 모든 화면 위에 커스텀 바나나 상단바를 얹음.
          builder: (context, child) {
            return Column(
              children: [
                const BananaStatusBar(),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          },
          routerConfig: Routes.getRouter,
        ),
      ),
    );
  }
}
