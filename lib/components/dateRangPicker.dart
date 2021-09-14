import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangPicker extends StatefulWidget {
  const DateRangPicker({Key? key}) : super(key: key);
  @override
  DateRangPickerState createState() => DateRangPickerState();
}

/// State for MyApp
class DateRangPickerState extends State<DateRangPicker> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  var date;

  @override
  void initState() {
    date =
        "${DateTime.now().subtract(const Duration(days: 5)).toString().split(' ').first} to ${DateTime.now().toString().split(' ').first}";
    super.initState();
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            "${args.value.startDate.toString().split(' ').first} to ${args.value.endDate != null ? args.value.endDate.toString().split(' ').first : args.value.startDate.toString().split(' ').first}";
        // debugPrint('args.value.length : ${args.value.length.toString()}');
        // DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
        //     ' - ' +
        //     DateFormat('dd/MM/yyyy')
        //         .format(args.value.endDate ?? args.value.startDate)
        //         .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${_range.isNotEmpty ? _range : date}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text('Select'),
              onPressed: () {
                // debugPrint('_range : $_range');
                // debugPrint('date : $date');
                Get.back<String>(result: _range.isNotEmpty ? _range : date);
                // widget.onSelected?.call(_range == '' ? _range : date);
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   top: 0,
            //   height: 80,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Text('Selected date: ' + _selectedDate),
            //       Text('Selected date count: ' + _dateCount),
            //       Text('Selected range: ' + _range),
            //       Text('Selected ranges count: ' + _rangeCount)
            //     ],
            //   ),
            // ),
            Positioned(
              left: 8,
              top: 0,
              right: 8,
              bottom: 0,
              child: SfDateRangePicker(
                  // enableMultiView: true,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 5)),
                      DateTime.now()),
                  view: DateRangePickerView.month,
                  headerHeight: 60,
                  headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            )
          ],
        ));
  }
}
