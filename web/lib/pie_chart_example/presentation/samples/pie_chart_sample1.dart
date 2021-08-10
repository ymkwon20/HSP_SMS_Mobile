import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web/pie_chart_example/presentation/samples/indicator.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({Key? key}) : super(key: key);

  @override
  _PieChartSample1State createState() => _PieChartSample1State();
}

class _PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Indicator(
                  color: const Color(0xFF0293EE),
                  text: "One",
                  isSquare: false,
                  size: touchedIndex == 0 ? 18 : 16,
                  textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xfff8b250),
                  text: "Two",
                  isSquare: false,
                  size: touchedIndex == 1 ? 18 : 16,
                  textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff845bef),
                  text: "Three",
                  isSquare: false,
                  size: touchedIndex == 2 ? 18 : 16,
                  textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff13d38e),
                  text: "Four",
                  isSquare: false,
                  size: touchedIndex == 3 ? 18 : 16,
                  textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;

                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    }),
                    startDegreeOffset: 180,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 1,
                    centerSpaceRadius: 0,
                    sections: showSections(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final opacity = isTouched ? 1.0 : 0.6;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee).withOpacity(opacity),
            value: 25,
            title: '',
            radius: 80,
            titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff044d7c)),
            titlePositionPercentageOffset: 0.55,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250).withOpacity(opacity),
            value: 25,
            title: '',
            radius: 65,
            titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff90672d)),
            titlePositionPercentageOffset: 0.55,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef).withOpacity(opacity),
            value: 25,
            title: '',
            radius: 60,
            titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4c3788)),
            titlePositionPercentageOffset: 0.6,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e).withOpacity(opacity),
            value: 25,
            title: '',
            radius: 70,
            titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xff0c7f55)),
            titlePositionPercentageOffset: 0.55,
          );
        default:
          throw Error();
      }
    });
  }
}