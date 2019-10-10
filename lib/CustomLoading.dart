
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoading extends StatelessWidget{
  final Widget child;
  final Widget loading;
  final Future future;
  final bool isViewChild;
  CustomLoading({
    @required this.child,
    @required this.future,
    this.loading,
    this.isViewChild = true
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var list = <Widget>[
      FutureBuilder(
        future: future,
        builder: (context,state){
          if(state.connectionState == ConnectionState.waiting){
            return Positioned(
              left: 0,top: 0,bottom: 0,right: 0,
              child: this.loading != null ? this.loading : Container(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          };
          if(isViewChild)
            return SizedBox();
          else
            return child;
        },
      ),
    ];
    if(isViewChild)
      list.add(child);
    return Stack(
      children: list,
    );
  }

}