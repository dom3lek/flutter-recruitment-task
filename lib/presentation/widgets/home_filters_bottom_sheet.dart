import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/constants/constants.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/presentation/widgets/favorite_filter.dart';
import 'package:flutter_recruitment_task/presentation/widgets/price_range_filter.dart';
import 'package:flutter_recruitment_task/presentation/widgets/tags_filter.dart';

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
          TagsFilter(
            onSelected: onSelected,
            selectedTags: selectedTags,
          ),
          const SizedBox(height: 16),
          PriceRangeFilter(
            onChanged: onPriceChanged,
            tempMinPrice: tempMinPrice,
            tempMaxPrice: tempMaxPrice,
          ),
          const SizedBox(height: 16),
          FavoritesFilter(
            onIsFavoritesChanged: onIsFavoritesChanged,
            isFavorites: isFavorites,
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
                ),
              );
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

  void onPriceChanged(double min, double max) {
    setState(() {
      tempMinPrice = min;
      tempMaxPrice = max;
    });
  }

  void onIsFavoritesChanged(bool? value) {
    if (value != null) {
      setState(() {
        isFavorites = value;
      });
    }
  }
}
