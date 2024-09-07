import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/constants/constants.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';

const chipsToChoice = ['BIO', '%', 'VEGAN', 'VEGE', 'BEST'];

class HomeFiltersModalBottomSheet extends StatefulWidget {
  const HomeFiltersModalBottomSheet({
    required this.getProductsPageFilter,
    super.key,
  });

  final GetProductsPageFilter getProductsPageFilter;

  @override
  State<HomeFiltersModalBottomSheet> createState() =>
      _HomeFiltersModalBottomSheetState();
}

class _HomeFiltersModalBottomSheetState
    extends State<HomeFiltersModalBottomSheet> {
  late List<String> selectedTags;
  late bool isFavorites;
  late double tempMinPrice;
  late double tempMaxPrice;

  @override
  void initState() {
    selectedTags = List.from(widget.getProductsPageFilter.selectedTags);
    isFavorites = widget.getProductsPageFilter.isFavorites ?? false;
    tempMinPrice = widget.getProductsPageFilter.minPrice ?? minPrice;
    tempMaxPrice = widget.getProductsPageFilter.maxPrice ?? maxPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          const BigText('Type filter'),
          Wrap(
            spacing: 10,
            children: [
              for (final chip in chipsToChoice)
                ChoiceChip(
                  label: Text(chip),
                  selected: selectedTags.contains(chip),
                  onSelected: (value) {
                    onSelected(chip, value);
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          const BigText('Price range filter'),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(tempMinPrice, tempMaxPrice),
            min: tempMinPrice,
            max: tempMaxPrice,
            divisions: 100,
            labels: RangeLabels(
                tempMinPrice.toStringAsFixed(2),
                tempMaxPrice == tempMaxPrice
                    ? "100+"
                    : tempMaxPrice.toStringAsFixed(2)),
            onChanged: (value) {
              setState(() {
                tempMinPrice = value.start;
                tempMaxPrice = value.end;
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: isFavorites,
            onChanged: (value) {
              setState(() {
                isFavorites = value ?? false;
              });
            },
            title: const Text('Show only favorites?'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  GetProductsPageFilter(
                    minPrice: tempMinPrice,
                    maxPrice: tempMaxPrice,
                    selectedTags: selectedTags,
                    isFavorites: isFavorites,
                  ));
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void onSelected(String text, bool selected) {
    setState(() {
      if (selected) {
        selectedTags.add(text);
      } else {
        selectedTags.remove(text);
      }
    });
  }
}
