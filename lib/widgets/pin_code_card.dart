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
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            // if (!place.wrongOrder)
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(2, 2),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Kod SMS", style: Theme.of(context).textTheme.subtitle),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                        colorBuilder: PinListenColorBuilder(
                            Theme.of(context).primaryColor, Colors.black38),
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    currentCode: code,
                    onCodeChanged: setCode,
                    // onCodeSubmitted: (_) => widget.submit(),
                  ),
                ),
              ],
            ),
            Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  'Zaloguj się',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                onPressed: submit,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(30),
                // ),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                // color: Theme.of(context).primaryColor,
                // textColor: Theme.of(context).primaryTextTheme.button.color,
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
