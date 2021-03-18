import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/utility/supported_data.dart';
import 'package:fullmarks/widgets/DisplayMath.dart';

class EquationFeaturesScreen extends StatefulWidget {
  @override
  _EquationFeaturesScreenState createState() => _EquationFeaturesScreenState();
}

class _EquationFeaturesScreenState extends State<EquationFeaturesScreen> {
  var largeSections = {
    'Delimiter Sizing',
    'Environment',
    'Unicode Mathematical Alphanumeric Symbols',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    final entries = supportedData.entries.toList();
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Equation Features",
          textColor: Colors.white,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: supportedData.length,
            itemBuilder: (context, i) => Column(
              children: <Widget>[
                Text(
                  entries[i].key,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                GridView.builder(
                  padding: EdgeInsets.all(
                    16,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: entries[i].value.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        largeSections.contains(entries[i].key) ? 250 : 125,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int j) {
                    return GestureDetector(
                      child: DisplayMath(
                        expression: entries[i].value[j],
                      ),
                      onTap: () {
                        Navigator.pop(context, entries[i].value[j]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
