
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker{
  final Function(DateTime) lisent;
  final DateTime now;
  final DateTime minDate;
  final DateTime maxDate;
  CustomDatePicker(
    BuildContext context,
    {
      @required this.lisent,
      this.now,
      this.minDate,
      this.maxDate,
    }
  ){
    if(Platform.isIOS)
      iosDatePicker(context);
    else
      androidDatePicker(context);
  }

  void iosDatePicker(BuildContext context){
    showCupertinoModalPopup(context: context,
        builder: (_){
          return SizedBox(
            child:CupertinoDatePicker(
              onDateTimeChanged: (val){
                lisent(val);
              },
              initialDateTime: now == null ? DateTime.now() : now,
              mode: CupertinoDatePickerMode.date,
              minimumDate: minDate,
              maximumYear: maxDate.year,
              minimumYear: minDate.year,
            ),
            height: 300,
          );
        }
    );
  }
  void androidDatePicker(BuildContext context){
    showDatePicker(
        context: context,
        initialDate: now == null ? DateTime.now() : now ,
        firstDate: minDate,
        lastDate: maxDate
    ).then((val){
      lisent(val);
    });
  }
}