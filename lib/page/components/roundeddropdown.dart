import 'package:flutter/material.dart';
import 'package:perisai_nusantara_app/page/components/textfieldcontainer.dart';

class RoundedDropdown extends StatefulWidget {
  final int value;
  final String hintText;
  // final IconData? icon;
  final List<DropdownMenuItem<int>> items;
  final void Function(int?) onChanged;
  const RoundedDropdown({
    Key? key,
    required this.value,
    required this.hintText,
    // this.icon,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RoundedDropdownState createState() => _RoundedDropdownState();
}

class _RoundedDropdownState extends State<RoundedDropdown> {
  @override
  Widget build(BuildContext context) {
    // avoid keyboard appearing
    //FocusScope.of(context).requestFocus(new FocusNode());
    return TextFieldContainer(
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(widget.hintText),
            value: widget.value,
            items: widget.items,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
