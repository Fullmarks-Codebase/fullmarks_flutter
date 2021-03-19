// Copyright 2020 Abhishek Dubey. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'electrons_anim.dart';

/// This widget creates a basic atom structure.
class Atom extends StatefulWidget {
  /// Size of atom's box.
  final double size;

  /// Size of the atom's container.
  /// Value is same as that of [size].
  final double containerSize;

  /// Size of atom's electron.
  ///
  /// Size factor - 0.0698
  final double electronSize;

  /// Maximum height upto which electron's
  /// should travel in atom's container.
  /// This value is decided by keeping electron's
  /// radius and orbit's border width in mind.
  /// Calculation - orbitAnimEndHeight = containerSize - electronSize
  ///
  /// Size factor - 0.9302
  final double orbitAnimEndHeight;

  /// Maximum width upto which electron's
  /// should travel in atom's container.
  /// This value is decided by keeping electron's
  /// radius and orbit's border width in mind.
  /// Calculation - orbitAnimEndHeightFactor = orbitAnimEndHeight / 2.0
  ///
  /// Size factor - 0.4651
  final double orbitAnimEndHeightFactor;

  /* Widgets */

  /// A Widget that get's displayed at center
  /// instead of nucleus according to user's choice.
  ///
  /// Note: If both the [nucleusColor] and [centerWidget]
  /// are set then [centerWidget] gets the preference.
  final Widget centerWidget;

  Widget electronsWidget1;
  Widget electronsWidget2;
  AnimationController controller1, controller2;

  Atom({
    Key key,
    @required this.size,
    @required this.electronsWidget1,
    @required this.electronsWidget2,
    @required this.centerWidget,
    @required this.controller1,
    @required this.controller2,
  })  : containerSize = size,
        electronSize = (0.0698 * size),
        orbitAnimEndHeight = (0.9302 * size),
        orbitAnimEndHeightFactor = (0.4651 * size),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _AtomState();
}

/// State creation of atom's widget.
class _AtomState extends State<Atom> {
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Center(
            child: widget.centerWidget == null
                ? Container()
                : Transform.scale(
                    scale: 0.00465 * widget.containerSize,
                    child: widget.centerWidget,
                  ),
          ),
          ElectronsAnim(widget),
        ],
      ),
    );
  }
}
