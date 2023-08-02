import 'package:flutter/material.dart';

/* create this in the parent widget and pass it as parameter
DateTime? selectedDate;

  void onDateSelected(DateTime? date) {
    setState(() {
      isReset = false;
      selectedDate = date;
    });
  }

?implementation with riverpod is different
  */

class StyledDatepicker extends StatefulWidget {
  final void Function(DateTime? date)
      onDateSelected; //to send selectedDate to parent widget
  final bool isReset;

  const StyledDatepicker(
      {super.key, required this.onDateSelected, this.isReset = false});

  @override
  State<StyledDatepicker> createState() => _StyledDatepickerState();
}

class _StyledDatepickerState extends State<StyledDatepicker> {
  DateTime initalDate = DateTime.now();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    if (widget.isReset) {
      selectedDate = null;
    }
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(
            EdgeInsets.all(8),
          ),
          backgroundColor: MaterialStatePropertyAll(Colors.grey.shade300),
          iconColor: MaterialStatePropertyAll(
            Colors.grey.shade700,
          ),
          foregroundColor: MaterialStatePropertyAll(Colors.grey.shade700),
          elevation:
              const MaterialStatePropertyAll(0), //this removes box shadow
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: () async {
          final DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: initalDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(3000));

          if (dateTime != null) {
            setState(
              () {
                selectedDate = dateTime;
              },
            );
            widget.onDateSelected(dateTime);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? "${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}"
                    : 'Select Date',
                overflow: TextOverflow.ellipsis,
              ),
            ), // <-- Text
            const Icon(
              // <-- Icon
              Icons.date_range,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
