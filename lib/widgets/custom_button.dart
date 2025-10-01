import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   const CustomButton({
    this.onTap,
    super.key,
    required this.centerText,
  });
  final String centerText;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            centerText,
            style: TextStyle(
              color: Color(0xFF37515F),
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
