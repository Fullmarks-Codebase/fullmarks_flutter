import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TexrScreen extends StatefulWidget {
  @override
  _TexrScreenState createState() => _TexrScreenState();
}

class _TexrScreenState extends State<TexrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Positioned(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  "assets/q1.svg",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Expanded(
              child: Positioned(
                bottom: 0,
                left: 0,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  "assets/q2.svg",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
