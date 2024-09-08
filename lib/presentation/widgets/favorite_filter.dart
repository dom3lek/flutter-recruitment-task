import 'package:flutter/material.dart';

class FavoritesFilter extends StatelessWidget {
  const FavoritesFilter({
    super.key,
    required this.onIsFavoritesChanged,
    required this.isFavorites,
  });

  final bool isFavorites;
  final Function(bool? value) onIsFavoritesChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isFavorites,
      onChanged: (value) {
        onIsFavoritesChanged(value);
      },
      title: const Text('Show only favorites?'),
    );
  }
}
