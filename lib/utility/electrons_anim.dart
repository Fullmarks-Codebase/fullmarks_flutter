// Copyright 2020 Abhishek Dubey. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import 'create_atom.dart';

/// This widget creates and handles the animation
/// for each of the electrons in the [Atom].
class ElectronsAnim extends StatefulWidget {
  final Atom _atom;

  ElectronsAnim(this._atom);

  @override
  State<StatefulWidget> createState() => _ElectronsAnimState();
}

/// State creation of the electron's animation widget.
class _ElectronsAnimState extends State<ElectronsAnim> {
  /// Controllers for each electron.

  /// Animation type as [double] for each electron.
  Animation<double> _animation1, _animation2;

  /// Current position of electrons from top of the position
  /// in electron stacks.
  double _animX1, _animX2;

  /// Current position of electrons from left of the position
  /// in electron stacks.
  double _animY1, _animY2;

  /// Booleans for determining the state of electron's animation.
  bool _isAnimHalfDone1, _isAnimHalfDone2 = false;

  /// This function is the heart of the animation as it calculates
  /// the position of electrons from the left in the electron stack.
  ///
  /// This is a derived mathematical equation from the general equation
  /// of vertical ellipse. Electrons follow this path to revolve around
  /// the nucleus.
  ///                       x²    y²
  /// General Equation ->   ─  +  ─  = 1
  ///                       b²    a²
  double _animY(isAnimHalfDone, animX) {
    return isAnimHalfDone
        ? -1 *
                sqrt(pow(widget._atom.orbitAnimEndHeightFactor, 2) -
                    pow(animX - widget._atom.orbitAnimEndHeightFactor, 2)) +
            widget._atom.orbitAnimEndHeightFactor
        : sqrt(pow(widget._atom.orbitAnimEndHeightFactor, 2) -
                pow(animX - widget._atom.orbitAnimEndHeightFactor, 2)) +
            widget._atom.orbitAnimEndHeightFactor;
  }

  /// Handles first electron's animation.
  void _anim1(bool didUpdate) {
    _animation1 =
        Tween<double>(begin: 0.0, end: widget._atom.orbitAnimEndHeight).animate(
            CurvedAnimation(
                parent: widget._atom.controller1, curve: Curves.easeInOut))
          ..addListener(() {
            _animX1 = _animation1.value;
            _animY1 = _animY(_isAnimHalfDone1, _animX1);
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              _isAnimHalfDone1 = false;
            }
            if (status == AnimationStatus.reverse) {
              _isAnimHalfDone1 = true;
            }
          });
    widget._atom.controller1.repeat(reverse: true);
  }

  /// Handles second electron's animation.
  void _anim2(bool didUpdate) {
    _animation2 =
        Tween<double>(begin: 0.0, end: widget._atom.orbitAnimEndHeight).animate(
            CurvedAnimation(
                parent: widget._atom.controller2, curve: Curves.easeInOut))
          ..addListener(() {
            _animX2 = _animation2.value;
            _animY2 = _animY(_isAnimHalfDone2, _animX2);
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              _isAnimHalfDone2 = false;
            }
            if (status == AnimationStatus.reverse) {
              _isAnimHalfDone2 = true;
            }
          });
    widget._atom.controller2.repeat(reverse: true);
  }

  @override
  void initState() {
    super.initState();
    _anim1(false);
    _anim2(false);
  }

  // Widget electron() {
  //   return Center(
  //     child: Container(
  //       height: widget._atom.electronSize,
  //       width: widget._atom.electronSize,
  //       decoration: BoxDecoration(
  //         color: Colors.red,
  //         shape: BoxShape.circle,
  //       ),
  //     ),
  //   );
  // }

  Widget electronStack1() {
    return Center(
      child: Transform.rotate(
        angle: pi,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          padding: MediaQuery.of(context).size.width > 400
              ? EdgeInsets.only(
                  top: 21,
                  left: 21,
                )
              : EdgeInsets.zero,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: _animX1,
                left: _animY1,
                child: Transform.rotate(
                  angle: -pi,
                  child: Container(
                    height: widget._atom.electronSize *
                        (MediaQuery.of(context).size.width > 400 ? 4 : 3),
                    width: widget._atom.electronSize *
                        (MediaQuery.of(context).size.width > 400 ? 4 : 3),
                    child: widget._atom.electronsWidget1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget electronStack2() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        padding: MediaQuery.of(context).size.width > 400
            ? EdgeInsets.only(
                top: 21,
                left: 21,
              )
            : EdgeInsets.zero,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: _animX2,
              left: _animY2,
              child: Container(
                height: widget._atom.electronSize *
                    (MediaQuery.of(context).size.width > 400 ? 4 : 3),
                width: widget._atom.electronSize *
                    (MediaQuery.of(context).size.width > 400 ? 4 : 3),
                child: widget._atom.electronsWidget2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build implementation of each electron stacks.
  /// All stacks are [Center] positioned and [Colors.transparent]
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          electronStack1(),
          electronStack2(),
        ],
      ),
    );
  }
}
