import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/constants/constants.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';

class PriceRangeFilter extends StatelessWidget {
  const PriceRangeFilter({
    super.key,
    required this.onChanged,
    required this.tempMinPrice,
    required this.tempMaxPrice,
  });

  final Function(double min, double max) onChanged;

  final double tempMinPrice;
  final double tempMaxPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BigText('Price range filter'),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(tempMinPrice, tempMaxPrice),
          min: tempMinPrice,
          max: tempMaxPrice,
          divisions: 100,
          labels: RangeLabels(
              tempMinPrice.toStringAsFixed(2),
              tempMaxPrice == minPrice
                  ? "100+"
                  : tempMaxPrice.toStringAsFixed(2)),
          onChanged: (value) {
            onChanged(value.start, value.end);
          },
        ),
      ],
    );
  }
}
