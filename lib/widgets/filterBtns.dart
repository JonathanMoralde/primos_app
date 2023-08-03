import 'package:flutter/material.dart';

import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/btnObject.dart';

class FilterBtns extends StatefulWidget {
  const FilterBtns({super.key});

  @override
  State<FilterBtns> createState() => _FilterBtnsState();
}

class _FilterBtnsState extends State<FilterBtns> {
  int _activeButtonIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
            itemCount: category.length, //from btnObject import
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final bool isActive = index == _activeButtonIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: StyledButton(
                  btnText: category[index].name,
                  onClick: () {
                    setState(() {
                      _activeButtonIndex = index;
                    });

                    category[index].onTap;
                  },
                  btnColor: isActive
                      ? const Color(0xFFFE3034)
                      : const Color(0xFFE2B563),
                ),
              );
            }),
      ),
    );
  }
}
