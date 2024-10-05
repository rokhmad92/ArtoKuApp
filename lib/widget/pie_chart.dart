import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';

class MyPieChart extends StatelessWidget {
  final LaporanBloc bloc;

  const MyPieChart({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LaporanBloc, LaporanState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LaporanLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LaporanPieChartState) {
          return Column(
            children: [
              if (state.dataChart.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 5,
                      sections: state.dataChart.asMap().entries.map((entry) {
                        final item = entry.value;
                        return PieChartSectionData(
                          value: item['value'].toDouble(),
                          color: item['color'],
                          title: '${item['value']}%',
                          titleStyle: const TextStyle(color: Colors.white),
                          showTitle: true,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: state.dataChart.asMap().entries.map((entry) {
                    final item = entry.value;
                    return _buildLegend(
                        color: item['color'], text: item['title']);
                  }).toList(),
                ),
              ),
            ],
          );
        }

        return const Center();
      },
    );
  }

  Widget _buildLegend({required Color color, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
