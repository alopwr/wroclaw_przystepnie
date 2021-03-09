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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Numer telefonu",
                    style: Theme.of(context).textTheme.subtitle),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Theme.of(context).primaryColor,
                    ),
                    child: PhoneFormFieldHint(
                      controller: controller,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: accept,
                      onChanged: setAccept,
                      activeColor: Theme.of(context).primaryColorDark,
                    ),
                    const Text("Akceptuje "),
                    GestureDetector(
                      child: Text(
                        "regulamin.",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () async {
                        var url = 'https://www.nasa.gov';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("Nie udało się otworzyć $url."),
                              actions: <Widget>[
                                TextButton(
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
                if (showError)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Musisz zaakceptować regulamin.",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                  )
              ],
            ),

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
                  'Wyślij kod',
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
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
