import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';

const chipsToChoice = ['BIO', '%', 'VEGAN', 'VEGE', 'BEST'];

class TagsFilter extends StatelessWidget {
  const TagsFilter({
    super.key,
    required this.selectedTags,
    required this.onSelected,
  });

  final List<String> selectedTags;
  final Function(String text, bool selected) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
