import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';

sealed class HomeState extends Equatable {
  const HomeState({this.getProductsPageFilter = const GetProductsPageFilter()});

  final GetProductsPageFilter getProductsPageFilter;
}

class Loading extends HomeState {
  const Loading({
    required super.getProductsPageFilter,
  });

  @override
  List<Object> get props => [getProductsPageFilter];
}

class Loaded extends HomeState {
  const Loaded({
    required this.pages,
    required super.getProductsPageFilter,
  });

  final List<ProductsPage> pages;

  List<Product> get products =>
      pages.map((page) => page.products).expand((product) => product).toList();

  int indexOfProduct(String productId) =>
      products.indexWhere((product) => product.id == productId);

  @override
  List<Object> get props => [pages, getProductsPageFilter];
}

class Error extends HomeState {
  const Error({
    required this.error,
    required super.getProductsPageFilter,
  });

  final dynamic error;

  @override
  List<Object> get props => [error, getProductsPageFilter];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._productsRepository)
      : super(const Loading(getProductsPageFilter: GetProductsPageFilter()));

  final ProductsRepository _productsRepository;
  final List<ProductsPage> _pages = [];
  var _param = const GetProductsPage(pageNumber: 1);

  Future<void> getNextPage([GetProductsPageFilter? filter]) async {
    try {
      if (state.getProductsPageFilter != filter && filter != null) {
        _pages.clear();
        _param = const GetProductsPage(pageNumber: 1);
      }

      final totalPages = _pages.lastOrNull?.totalPages;

      if (totalPages != null && _param.pageNumber > totalPages) return;

      final newPage = await _productsRepository.getProductsPage(
          _param, filter ?? state.getProductsPageFilter);

      _param = _param.increasePageNumber();
      _pages.add(newPage);

      emit(
        Loaded(
          pages: _pages,
          getProductsPageFilter: filter ?? state.getProductsPageFilter,
        ),
      );
    } catch (e) {
      emit(
        Error(
          error: e,
          getProductsPageFilter: filter ?? state.getProductsPageFilter,
        ),
      );
    }
  }
}
