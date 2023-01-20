import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/page/components/textfieldcontainer.dart';

class RoundedInputDate extends StatefulWidget {
  final ValueChanged<String> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  // final FocusNode focusNode;
  final String hintText;
  final double width;

  RoundedInputDate(
      {Key? key,
      required this.hintText,
      // required this.focusNode,
      required this.dateFormat,
      required this.lastDate,
      required this.firstDate,
      required this.initialDate,
      required this.onDateChanged,
      required this.width})
      : super(key: key);
  @override
  _RoundedInputDateState createState() => _RoundedInputDateState();
}

class _RoundedInputDateState extends State<RoundedInputDate> {
  late TextEditingController _controllerDate;
  late DateFormat _dateFormat;
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();

    _dateFormat = widget.dateFormat;

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextField(
        // focusNode: widget.focusNode,
        controller: _controllerDate,
        cursorColor: Colors.indigo.shade300,
        decoration: InputDecoration(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.red.shade600,
          ),
          labelText: widget.hintText,
          border: InputBorder.none,
        ),
        onTap: () => _selectDate(context),
        readOnly: true,
      ),
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      var formatter = new DateFormat('yyyy-MM-dd');

      // _controllerDate.text = _dateFormat.format(_selectedDate);
      _controllerDate.text = formatter.format(_selectedDate);
      widget.onDateChanged(_controllerDate.text);
    }

    // if (widget.focusNode != null) {
    //   widget.focusNode.nextFocus();
    // }
  }
}
