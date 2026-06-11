import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {

final String text;
final VoidCallback onTap;

const GradientButton({
super.key,
required this.text,
required this.onTap,
});

@override
Widget build(BuildContext context) {

return GestureDetector(

  onTap: onTap,

  child: Container(

    height: 58,

    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(18),

      gradient: const LinearGradient(
        colors: [
          Color(0xFF2F6BFF),
          Color(0xFF17C6E5),
        ],
      ),
    ),

    child: Center(

      child: Text(
        text,

        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
  ),
);

}
}
