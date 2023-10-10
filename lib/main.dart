import 'package:app/core/blocs/application_cubit_observer.dart';
import 'package:app/core/navigator/router_navigator.dart';
import 'package:app/features/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/firebase/firebase_options.dart';

import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterBranchSdk.validateSDKIntegration();
  Bloc.observer = ApplicationCubitObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey=stripePublishableKey;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garbo',
      theme: ThemeData(
          fontFamily: GoogleFonts.getFont('Libre Baskerville').fontFamily,
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
          )),
      home: const SplashScreen(),
      navigatorKey: RouterNavigator.navigatorKey,
      navigatorObservers: [RouterNavigator.routeObserver],
      onGenerateRoute: RouterNavigator.generateRoute,
    );
  }
}
