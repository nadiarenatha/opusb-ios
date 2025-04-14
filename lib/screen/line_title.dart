import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 30,
            // getTextStyles: (value) => const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 10,
            //     color: Color(0XFF000000)),
            // getTitles: (value) {
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  // return '15/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("15/04/2024"),
                  );
                case 1:
                  // return '16/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("16/04/2024"),
                  );
                case 2:
                  // return '17/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("17/04/2024"),
                  );
                case 3:
                  // return '18/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("18/04/2024"),
                  );
                case 4:
                  // return '19/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("19/04/2024"),
                  );
                case 5:
                  // return '20/04/2024';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("20/04/2024"),
                  );
                case 6:
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    angle: 0.0,
                    child: const Text("21/04/2024"),
                  );
              }
              // return '';
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                angle: 0.0,
                child: const Text(""),
              );
            },
            // margin: 20
          ),
        ),
      );
}
