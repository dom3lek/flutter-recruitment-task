import 'package:equatable/equatable.dart';

class GetProductsPageFilter extends Equatable {
  final double? minPrice;

  final double? maxPrice;

  final List<String> selectedTags;

  final bool? isFavorites;

  const GetProductsPageFilter({
    this.minPrice,
    this.maxPrice,
    this.selectedTags = const [],
    this.isFavorites,
  });

  GetProductsPageFilter copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? selectedTags,
    bool? isFavorites,
  }) {
    return GetProductsPageFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedTags: selectedTags ?? this.selectedTags,
      isFavorites: isFavorites ?? this.isFavorites,
    );
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, selectedTags, isFavorites];
}
