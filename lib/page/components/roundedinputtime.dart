import 'package:flutter/material.dart';
import 'package:perisai_nusantara_app/page/components/textfieldcontainer.dart';

class RoundedInputTime extends StatefulWidget {
  final String hintText;
  final double width;
  final ValueChanged<String> onTimeChanged;

  RoundedInputTime(
      {Key? key,
      required this.hintText,
      required this.onTimeChanged,
      required this.width})
      : super(key: key);
  @override
  _RoundedInputTimeState createState() => _RoundedInputTimeState();
}

class _RoundedInputTimeState extends State<RoundedInputTime> {
  late TextEditingController _controllerTime;
  late String _hour, _minute, _time;
  DateTime now = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _controllerTime = TextEditingController();
    _controllerTime.text = DateTime.now().hour.toString() +
        ' : ' +
        DateTime.now().minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: widget.width,
      child: TextField(
        // focusNode: widget.focusNode,
        controller: _controllerTime,
        cursorColor: Colors.indigo.shade300,
        decoration: InputDecoration(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.red.shade600,
          ),
          labelText: widget.hintText,
          border: InputBorder.none,
        ),
        onTap: () => _selectTime(context),
        readOnly: true,
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _controllerTime.text = _time;
        widget.onTimeChanged(_controllerTime.text);
      });
  }
}
