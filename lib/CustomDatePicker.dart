import 'dart:io';

import 'package:custom_util_plugin/PlatformScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker {
  final DateTime now;
  final DateTime minDate;
  final DateTime maxDate;
  final BuildContext context;
  DateTime tmpDate;
  CustomDatePicker(
    this.context, {
    this.now,
    this.minDate,
    this.maxDate,
  });

  Future<DateTime> show() {
    if (Platform.isIOS)
      return iosDatePicker(context);
    else
      return androidDatePicker(context);
  }

  Future<DateTime> iosDatePicker(BuildContext context) {
    // lisent(now == null ? DateTime.now() : now);
    return showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              color: CupertinoTheme.of(context).primaryContrastingColor,
              child: Column(children: [
                Row(
                  children: [
                    PlatformButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Text(
                        "取消",
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle,
                      ),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    PlatformButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        "确认",
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle
                            .copyWith(
                                color: CupertinoTheme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tmpDate);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: CupertinoDatePicker(
                    onDateTimeChanged: (val) {
                      tmpDate = val;
                    },
                    backgroundColor: Colors.white,
                    initialDateTime: now == null ? DateTime.now() : now,
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: minDate,
                    maximumYear: maxDate != null ? maxDate.year : null,
                    minimumYear: minDate != null ? minDate.year : 2010,
                  ),
                ),
              ]),
              height: 400,
            ));
  }

  Future<DateTime> androidDatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: now == null ? DateTime.now() : now,
        firstDate: minDate != null
            ? minDate
            : DateTime.now().add(Duration(days: -1500)),
        lastDate: maxDate);
  }
}
