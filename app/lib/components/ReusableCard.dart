import "package:flutter/material.dart";

class ReusableCard extends StatelessWidget {
  final Widget child;
  final double height ;
  final double padding ;
  const ReusableCard(this.child, this.height,this.padding);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: child,
        padding: EdgeInsets.all(padding),
        height: height,
        margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(31, 31, 57, 0.6),
                Color.fromRGBO(31, 31, 57, 1),

              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        )
    );
  }
}

