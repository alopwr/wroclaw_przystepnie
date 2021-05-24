import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({IconData icon, this.label, this.color, this.onPressed}) {
    this.icon = Icon(
      icon,
      color: Colors.white,
    );
  }
  CircleButton.withAnimatedIcon(
      {AnimatedIcon this.icon, this.label, this.color, this.onPressed});

  Widget icon;
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
            height: (16 * 2 + 24).toDouble(),
            width: (16 * 2 + 24).toDouble(),
            // padding: const EdgeInsets.all(16.0),
            child: Center(child: icon),
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8.0)
                ]),
          ),
          const SizedBox(height: 12.0),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: double.infinity),
              child: Text(
                label,
                // overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
