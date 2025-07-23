import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.lineScalePulseOut,
          colors: [Colors.blue, Colors.green, Colors.red],
          strokeWidth: 2.0,
          backgroundColor: Colors.white,
          pathBackgroundColor: Colors.black12,
        ),
      ),
    );
  }
}
