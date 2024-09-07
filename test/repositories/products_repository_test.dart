import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ProductsRepository', () {
    late ProductsRepository productsRepository;

    setUp(() {
      productsRepository = MockedProductsRepository();
    });

    group('getProductsPage', () {
      test('should return filtered products ', () async {
        // arrange
        const productsPageFilter = GetProductsPageFilter(
          selectedTags: ['VEGE'],
        );

        final param = GetProductsPage(pageNumber: 1);

        // act
        final data =
            await productsRepository.getProductsPage(param, productsPageFilter);

        for (final product in data.products) {
          // assert

          expect(product.tags.any((tag) => tag.label == 'VEGE'), true);
        }

        expect(data.products.length, equals(3));
      });

      test('should return all products ', () async {
        // arrange
        const productsPageFilter = GetProductsPageFilter();

        final param = GetProductsPage(pageNumber: 1);

        // act
        final data =
            await productsRepository.getProductsPage(param, productsPageFilter);

        // assert
        expect(data.products.length, equals(20));
      });
    });
  });
}
