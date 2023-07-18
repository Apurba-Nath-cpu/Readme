import 'package:ebook_reader/utils/utils.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color? backgroundColor;
  final Color? borderColor;
  final String text;
  final Color? textColor;
  const FollowButton({
    Key? key,
    this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
      ),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor!,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          width: Dwidth * 0.88,
          height: 30,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
