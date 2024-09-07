import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/home_cubit.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/product_item.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late ProductsRepository productsRepository;
  late GetProductsPageFilter productsPageFilter;
  late GetProductsPage param1;
  late GetProductsPage param2;
  late ProductsPage firstProductsPage;
  late ProductsPage secondProductsPage;

  setUp(() {
    productsRepository = MockProductsRepository();
    productsPageFilter = const GetProductsPageFilter();
    param1 = const GetProductsPage(pageNumber: 1);
    param2 = const GetProductsPage(pageNumber: 2);

    firstProductsPage = ProductsPage(
      products: List.filled(10, product1),
      pageNumber: 1,
      pageSize: 10,
      totalPages: 2,
    );

    secondProductsPage = ProductsPage(
      products: List.filled(10, product2),
      pageNumber: 2,
      pageSize: 10,
      totalPages: 2,
    );
  });

  test('expects proper initial state', () {
    expect(
      HomeCubit(productsRepository).state,
      Loading(
        getProductsPageFilter: productsPageFilter,
      ),
    );
  });

  blocTest<HomeCubit, HomeState>(
    'expects HomeState to be Loaded when getNextPage is called',
    setUp: () {
      when(() => productsRepository.getProductsPage(param1, productsPageFilter))
          .thenAnswer(
        (_) async => firstProductsPage,
      );
    },
    build: () => HomeCubit(productsRepository),
    act: (cubit) => cubit.getNextPage(),
    expect: () => [
      Loaded(
        pages: [firstProductsPage],
        getProductsPageFilter: productsPageFilter,
      )
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'expects increased page number when getNextPage is called twice',
    setUp: () {
      when(() => productsRepository.getProductsPage(param1, productsPageFilter))
          .thenAnswer(
        (_) async => firstProductsPage,
      );

      when(() => productsRepository.getProductsPage(param2, productsPageFilter))
          .thenAnswer(
        (_) async => secondProductsPage,
      );
    },
    build: () => HomeCubit(productsRepository),
    act: (cubit) async {
      await cubit.getNextPage();
      await cubit.getNextPage();
    },
    verify: (_) {
      verify(() =>
              productsRepository.getProductsPage(param1, productsPageFilter))
          .called(1);
      verify(() =>
              productsRepository.getProductsPage(param2, productsPageFilter))
          .called(1);
    },
    expect: () => [
      Loaded(
        pages: [firstProductsPage, secondProductsPage],
        getProductsPageFilter: productsPageFilter,
      ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'expects HomeState to be Error when getNextPage is called and throws an error',
    setUp: () {
      when(() => productsRepository.getProductsPage(param1, productsPageFilter))
          .thenThrow('ERROR');
    },
    build: () => HomeCubit(productsRepository),
    act: (cubit) => cubit.getNextPage(),
    expect: () => [
      Error(
        error: 'ERROR',
        getProductsPageFilter: productsPageFilter,
      )
    ],
  );
}
