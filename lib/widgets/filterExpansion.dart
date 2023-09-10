import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:primos_app/providers/filter/isDateRange_provider.dart';
import 'package:primos_app/providers/filter/isSingleDate_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDatepicker.dart';

// provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter/selectedDate_provider.dart';
import '../providers/filter/isExpanded_provider.dart';

class FilterExpansion extends ConsumerWidget {
  const FilterExpansion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedProvider);

    void onDateSelected1(DateTime? date) {
      // selectedDate1.setDate(date);
      ref.read(isReset.notifier).state = false;
      ref.read(selectedDate1Provider.notifier).state = date;
    }

    void onDateSelected2(DateTime? date) {
      // selectedDate2.setDate(date);
      ref.read(isReset.notifier).state = false;
      ref.read(selectedDate2Provider.notifier).state = date;
    }

    // bool isExpanded = false;
    String headerText = "Filter Options";

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool currentlyExpanded) {
            ref.read(isExpandedProvider.notifier).state = !currentlyExpanded;
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(headerText),
                );
              },
              body: ListTile(
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        //DATE RANGE PICKER
                        children: [
                          const Text("From "),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 120,
                              child: StyledDatepicker(
                                  onDateSelected: onDateSelected1,
                                  isReset: ref.watch(isReset)),
                            ),
                          ),
                          const Text(" to "),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 120,
                              child: StyledDatepicker(
                                  onDateSelected: onDateSelected2,
                                  isReset: ref.watch(isReset)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                noShadow: true,
                                btnText: "RESET DATE",
                                onClick: () {
                                  ref
                                      .read(isSingleDateProvider.notifier)
                                      .state = false;
                                  ref.read(isDateRangeProvider.notifier).state =
                                      false;

                                  ref
                                      .read(selectedDate1Provider.notifier)
                                      .state = null;
                                  ref
                                      .read(selectedDate2Provider.notifier)
                                      .state = null;
                                  ref.read(isReset.notifier).state = true;
                                }),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                noShadow: true,
                                btnText: "FILTER",
                                onClick: () {
                                  if (ref.watch(selectedDate1Provider) ==
                                          null ||
                                      ref.watch(selectedDate2Provider) ==
                                          null) {
                                    Fluttertoast.showToast(
                                      msg: "Please select a date",
                                      gravity: ToastGravity.TOP,
                                    );
                                  } else {
                                    ref
                                        .read(isDateRangeProvider.notifier)
                                        .state = true;
                                  }
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              isExpanded: isExpanded,
            )
          ],
        ),
      ),
    );
  }
}
