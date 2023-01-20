import 'package:flutter/material.dart';
import 'package:perisai_nusantara_app/page/components/textfieldcontainer.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool invisible;
  final Function() onEyeTap;
  const RoundedPasswordField(
      {Key? key,
      required this.onChanged,
      this.hintText = 'Password',
      required this.invisible,
      required this.onEyeTap})
      : super(key: key);
  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: widget.invisible,
        onChanged: widget.onChanged,
        cursorColor: Colors.red.shade700,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: Colors.red.shade700,
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onEyeTap,
            child: Icon(
              (widget.invisible == true)
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.red.shade700,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
