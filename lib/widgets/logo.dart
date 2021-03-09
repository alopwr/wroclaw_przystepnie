import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Image.asset(
            "assets/kolorywro.png",
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: FittedBox(
            child: Text(
              "Wrocław Przystępnie",
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        )
      ],
    );
  }
}
