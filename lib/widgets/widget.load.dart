import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
        SizedBox(height: 10),
        Text(
          'Aguarde, consultando...',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
