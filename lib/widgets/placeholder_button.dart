import 'package:flutter/material.dart';

class PlaceholderButton extends StatelessWidget {
  PlaceholderButton(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                height: 25,
                width: 25,
                child: Placeholder(
                  color: Colors.black.withOpacity(0.75),
                )),
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8.0)
                ]),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
              height: 12,
              width: 25,
              child: Placeholder(
                color: Colors.black.withOpacity(0.75),
              ))
        ],
      ),
    );
  }
}
