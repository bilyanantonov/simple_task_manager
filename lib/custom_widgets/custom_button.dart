import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final double fontSize;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double width;
  final double height;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const CustomButton(
      {Key key,
      @required this.buttonText,
      this.fontSize: 16,
      this.buttonColor: Colors.teal,
      this.textColor: Colors.white,
      this.radius: 16,
      @required this.width,
      this.height: 50,
      this.buttonIcon,
      @required this.onPressed})
      : assert(buttonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          width: width,
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
