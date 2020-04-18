import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberCard extends StatelessWidget {
  const PhoneNumberCard({
    @required this.controller,
    @required this.errorMessage,
    @required this.appBar,
    @required this.submit,
    @required this.accept,
    @required this.setAccept,
    @required this.showError,
  });

  final TextEditingController controller;
  final String errorMessage;
  final AppBar appBar;
  final Function submit;
  final bool accept;
  final Function setAccept;
  final bool showError;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Numer telefonu",
                      style: Theme.of(context).textTheme.subtitle),
                  PhoneFieldHint(
                    controller: controller,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: accept,
                        onChanged: setAccept,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text("Akceptuje "),
                      GestureDetector(
                        child: const Text(
                          "regulamin.",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () async {
                          var url = 'https://www.nasa.gov';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            showDialog(
                              context: context,
                              child: AlertDialog(
                                content: Text("Nie udało się otworzyć $url."),
                                actions: <Widget>[
                                  FlatButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                  showError
                      ? Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Musisz zaakceptować regulamin.",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Theme.of(context).errorColor),
                          ),
                        )
                      : Container()
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                child: Text('Wyślij kod'),
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
