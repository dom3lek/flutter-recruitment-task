//
// Don't modify this file please!
//
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';

const _fakeDelay = Duration(milliseconds: 500);

typedef ProductFunction = bool Function(Product product);

abstract class ProductsRepository {
  Future<ProductsPage> getProductsPage(
    GetProductsPage param,
    GetProductsPageFilter productsPageFilter,
  );
}

class MockedProductsRepository implements ProductsRepository {
  @override
  Future<ProductsPage> getProductsPage(
    GetProductsPage param,
    GetProductsPageFilter productsPageFilter,
  ) async {
    final path = 'assets/mocks/products_pages/${param.pageNumber}.json';
    final data = await rootBundle.loadString(path);
    final json = jsonDecode(data);
    final page = ProductsPage.fromJson(json);

    final List<ProductFunction> filters = getFilters(productsPageFilter);

    if (filters.isNotEmpty) {
      List<Product> filteredProducts = [];

      for (final product in page.products) {
        if (filters.every((filter) => filter(product))) {
          filteredProducts.add(product);
        }
      }

      final pageWithFilteresProducts = ProductsPage(
        totalPages: page.totalPages,
        pageNumber: page.pageNumber,
        pageSize: page.pageSize,
        products: filteredProducts,
      );

      return Future.delayed(_fakeDelay, () => pageWithFilteresProducts);
    }

    return Future.delayed(_fakeDelay, () => page);
  }
}

List<ProductFunction> getFilters(GetProductsPageFilter productsPageFilter) {
  final List<ProductFunction> filters = [];

  if (productsPageFilter.minPrice != null) {
    filters.add((product) =>
        product.offer.regularPrice.amount > productsPageFilter.minPrice!);
  }

  if (productsPageFilter.maxPrice != null &&
      productsPageFilter.maxPrice! < 5000) {
    filters.add((product) =>
        product.offer.regularPrice.amount < productsPageFilter.maxPrice!);
  }

  if (productsPageFilter.selectedTags.isNotEmpty) {
    filters.add(
      (product) => productsPageFilter.selectedTags.any(
        (selectedTag) {
          final foundTag =
              product.tags.firstWhereOrNull((tag) => tag.label == selectedTag);

          return foundTag != null ? true : false;
        },
      ),
    );
  }

  if (productsPageFilter.isFavorites != null) {
    filters
        .add((product) => product.isFavorite == productsPageFilter.isFavorites);
  }

  return filters;
}
