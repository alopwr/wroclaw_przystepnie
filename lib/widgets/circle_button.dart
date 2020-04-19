import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({this.icon, this.label, this.color, this.onPressed});

  final IconData icon;
  final String label;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8.0)
                ]),
          ),
          const SizedBox(height: 12.0),
          Text(label),
        ],
      ),
    );
  }
}
