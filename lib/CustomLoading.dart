
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoading extends StatelessWidget{
  final Widget child;
  final Widget loading;
  final Future future;
  CustomLoading({
   @required this.child,
    @required this.future,
   this.loading
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        FutureBuilder(
          future: future,
          builder: (context,state){
            if(state.connectionState == ConnectionState.waiting){
              return Positioned(
                left: 0,top: 0,bottom: 0,right: 0,
                child: this.loading != null ? this.loading : Center(
                  child: CircularProgressIndicator(),
                ),
              );
            };
            return SizedBox();
          },
        ),
        child
      ],
    );
  }

}