import 'package:flutter/material.dart';

class RoundedButtonLaporan extends StatelessWidget{
      final VoidCallback press;
      final String text;
      final Color color, textColor;
  const RoundedButtonLaporan(
    {Key? key, 
    required this.press, required this.color, required this.textColor, required this.text
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 15, horizontal: 40)),
                elevation: MaterialStateProperty.all<double>(10.0),
                backgroundColor: MaterialStateProperty.all<Color>(color)),
            onPressed: press, child: Text(text),
            ),
        ),
      ),
    );
  }

}