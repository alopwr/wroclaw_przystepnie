import 'package:flutter/material.dart';

class GlobalContextProvider extends StatefulWidget {
  GlobalContextProvider({this.child, key}) : super(key: key);
  final Widget child;

  @override
  GlobalContextProviderState createState() => GlobalContextProviderState();
}

class GlobalContextProviderState extends State<GlobalContextProvider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.widget.child,
    );
  }
}
