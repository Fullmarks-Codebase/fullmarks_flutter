// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_math/flutter_math.dart';

// class DisplayMath extends StatelessWidget {
//   final String expression;

//   DisplayMath({
//     Key key,
//     @required this.expression,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(expression, softWrap: true),
//           ),
//           Divider(
//             thickness: 1.0,
//             height: 1.0,
//           ),
//           Expanded(
//             child: Center(
//               child: Math.tex(
//                 expression,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
