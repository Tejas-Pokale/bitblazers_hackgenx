import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AgePicker extends StatefulWidget {
   AgePicker({super.key});
  String date = 'no date selected';
  @override
  State<AgePicker> createState() => _AgePickerState();
}

class _AgePickerState extends State<AgePicker> {
  //String date = 'no date selected';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Select birthdate : ',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        // const SizedBox(
        //   width: 15,
        // ),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            onPressed: () {
              selectDate();
            },
            icon: const Icon(Icons.date_range_outlined),
            label: Text(
              widget.date,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void selectDate() async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        widget.date = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  String getSelectedDate(){
    return widget.date ;
  }
}
