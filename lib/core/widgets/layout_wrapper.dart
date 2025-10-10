import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MyStateful extends StatefulWidget  {
  const MyStateful({super.key});

  @override
  State<MyStateful> createState() => _MyStatefulState();
}

class _MyStatefulState extends State<MyStateful> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BooksCubit(),
        child: AutoRouter(), // The AutoRouter() widget used here
        // is required to render sub-routes
      ),
    );
  }
}
