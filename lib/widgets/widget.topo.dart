import 'package:flutter/material.dart';

class Topo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://assets.muralswallpaper.com/product-banner/WM0017PI40W.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 15,
            ),
          ]),
    );
  }
}
