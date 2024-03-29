import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Expander extends StatefulWidget {
  final String body;

  const Expander({Key key, this.body}) : super(key: key);
  @override
  _ExpanderState createState() => _ExpanderState();
}

class _ExpanderState extends State<Expander> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    if (!expanded)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: widget.body.split(" ").take(30).join(" "),
            styleSheet: MarkdownStyleSheet(textScaleFactor: 1.2),
          ),
          if (widget.body.split(" ").length > 30)
            TextButton.icon(
                onPressed: () => setState(() {
                      expanded = true;
                    }),
                icon: const Icon(Icons.keyboard_arrow_down),
                label: Text("Czytaj więcej"))
        ],
      );
    else
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: widget.body,
            styleSheet: MarkdownStyleSheet(textScaleFactor: 1.2),
          ),
          TextButton.icon(
              onPressed: () => setState(() {
                    expanded = false;
                  }),
              icon: const Icon(Icons.keyboard_arrow_up),
              label: Text("Zwiń opis"))
        ],
      );
  }
}
