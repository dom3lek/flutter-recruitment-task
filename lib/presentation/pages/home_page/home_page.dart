import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/get_products_page_filter.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';
import 'package:flutter_recruitment_task/presentation/widgets/home_filters_bottom_sheet.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

const _mainPadding = EdgeInsets.all(16.0);

class HomePage extends StatelessWidget {
  HomePage({this.id, super.key});

  final String? id;

  final _listController = ListController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText('Products'),
        actions: const [_OpenFilterModalButton()],
      ),
      body: Padding(
        padding: _mainPadding,
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is Loaded && id != null) {
              final index = state.indexOfProduct(id!);

              if (index == -1) {
                context
                    .read<HomeCubit>()
                    .getNextPage(const GetProductsPageFilter());
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _listController.animateToItem(
                    index: index,
                    scrollController: _scrollController,
                    alignment: 0.5,
                    duration: (estimatedDistance) => kThemeAnimationDuration,
                    curve: (estimatedDistance) => Curves.easeInOut,
                  );
                });
              }
            }
          },
          listenWhen: (prev, curr) => prev is Loading && curr is Loaded,
          builder: (context, state) {
            return switch (state) {
              Error() => BigText('Error: ${state.error}'),
              Loading() => const BigText('Loading...'),
              Loaded() => _LoadedWidget(
                  state: state,
                  scrollController: _scrollController,
                  listController: _listController,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _OpenFilterModalButton extends StatelessWidget {
  const _OpenFilterModalButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final getProductsPageFilter =
            context.read<HomeCubit>().state.getProductsPageFilter;

        final newGetProductsPageFilter =
            await showModalBottomSheet<GetProductsPageFilter>(
          context: context,
          builder: (ctx) => SizedBox.expand(
            child: HomeFiltersModalBottomSheet(
                getProductsPageFilter: getProductsPageFilter),
          ),
        );

        if (context.mounted &&
            newGetProductsPageFilter != getProductsPageFilter &&
            newGetProductsPageFilter != null) {
          context.read<HomeCubit>().getNextPage(newGetProductsPageFilter);
        }
      },
      icon: const Icon(Icons.filter_alt),
    );
  }
}

class _LoadedWidget extends StatelessWidget {
  const _LoadedWidget({
    required this.state,
    required this.listController,
    required this.scrollController,
  });

  final Loaded state;
  final ListController listController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        _ProductsSliverList(
          state: state,
          listController: listController,
          scrollController: scrollController,
        ),
        const _GetNextPageButton(),
      ],
    );
  }
}

class _ProductsSliverList extends StatelessWidget {
  const _ProductsSliverList({
    required this.state,
    required this.listController,
    required this.scrollController,
  });

  final Loaded state;

  final ListController listController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SuperSliverList.separated(
      listController: listController,
      itemCount: state.products.length,
      itemBuilder: (context, index) => _ProductCard(state.products[index]),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(product.name),
            _Tags(product: product),
            // These widgets are to show that filtering works on UI based price and/or favorite
            if (product.isFavorite ?? false) const _Favorite(),
            _Price(product: product),
          ],
        ),
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
        '${product.offer.regularPrice.amount.toStringAsFixed(2)} ${product.offer.regularPrice.currency}');
  }
}

class _Favorite extends StatelessWidget {
  const _Favorite();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.star);
  }
}

class _Tags extends StatelessWidget {
  const _Tags({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: product.tags.map(_TagWidget.new).toList(),
    );
  }
}

class _TagWidget extends StatelessWidget {
  const _TagWidget(this.tag);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        color: MaterialStateProperty.all(tag.color.toColor()),
        label: Text(tag.label),
      ),
    );
  }
}

class _GetNextPageButton extends StatelessWidget {
  const _GetNextPageButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TextButton(
        onPressed: () {
          context.read<HomeCubit>().getNextPage();
        },
        child: const BigText('Get next page'),
      ),
    );
  }
}

extension _ColorExt on String {
  Color toColor() {
    String color = replaceFirst("#", '');

    if (color.length == 6 || color.length == 7) {
      color = 'FF$color';
    }

    return Color(int.parse(color, radix: 16));
  }
}
