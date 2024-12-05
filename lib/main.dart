import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/Home/View/Home%20View.dart';

import 'Home/View Model/home_cubit.dart';

void main() => runApp(LocationApp());

class LocationApp extends StatelessWidget {
  const LocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit(), child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    ));
  }
}
