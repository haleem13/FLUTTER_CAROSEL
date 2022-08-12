import 'dart:math';
import 'package:flutter/material.dart';
// kk
import '../../carousel.dart';

class SlideSwipe extends StatelessWidget {
  int currentPage;
  bool initial;
  final Carousel props;

  SlideSwipe(this.props);

  initiate(index) {
    try {
      currentPage = props.controller.initialPage.round();
    } catch (e) {
      print("exception here => $e");
    }
    double value;
    if (index == currentPage - 1 && initial) value = 1.0;
    if (index == currentPage && initial) value = 0.0;
    if (index == currentPage + 1 && initial) {
      value = 1.0;
      initial = false;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    currentPage = 0;
    initial = true;
    int count = props.children.length;
    Widget carouserBuilder = PageView.builder(
        scrollDirection: props.axis,
        controller: props.controller,
        itemCount: count,
        onPageChanged: (i) {
          props.updatePositionCallBack(i);
          if (props.onPageChange != null) {
            props.onPageChange(i);
          }
          currentPage = i;
        },
        itemBuilder: (context, index) => builder(index, props.controller));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: props.height,
          width: props.width,
          child: props.axis == Axis.horizontal
              ? carouserBuilder
              : Container(
                  child: carouserBuilder,
                ),
        ),
      ],
    );
  }

  builder(int index, PageController controller1) {
    return AnimatedBuilder(
      animation: controller1,
      builder: (context, child) {
        double value = 1.0;
        value = initial
            ? initiate(index) ?? controller1.page - index
            : controller1.page - index;
        value = (1 - (value.abs() * .13)).clamp(0.0, 1.0);
           double radius = 1;

        radius = value - 0.87;
        return Opacity(
          opacity: pow(value, 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: (props.height -
                          (props.axis == Axis.vertical
                              ? props.height / 5
                              : 0.0)) *
                      (props.axis == Axis.vertical ? 1.0 : value),
                  width: props.width * value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 6), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(radius * 80),
                      image: DecorationImage(
                          image: props.children[index], fit: BoxFit.cover),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
