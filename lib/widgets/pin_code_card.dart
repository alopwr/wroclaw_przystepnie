import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PinCodeCard extends StatelessWidget {
  const PinCodeCard(this.code, this.setCode, this.submit);
  final String code;
  final Function setCode;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Kod SMS", style: Theme.of(context).textTheme.subtitle),
                  PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                        colorBuilder: PinListenColorBuilder(
                            Theme.of(context).primaryColorDark, Colors.black),
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    currentCode: code,
                    onCodeChanged: setCode,
                    // onCodeSubmitted: (_) => widget.submit(),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                child: Text('Zaloguj się'),
                onPressed: submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
            Spacer(),
            // Text("App Signature : $signature"),
            // RaisedButton(
            //   child: Text('Get app signature'),
            //   onPressed: () async {
            //     signature = await SmsAutoFill().getAppSignature;
            //     setState(() {});
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
