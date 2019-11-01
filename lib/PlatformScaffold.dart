import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'BasePlatformWidget.dart';
import 'generated/i18n.dart';

class PlatformApp extends CupertinoApp {
  final String title;
  final CupertinoThemeData theme;
  final Widget home;
  final Map<String, WidgetBuilder> router;
  final LocalizationsDelegate delegate;
  final List<Locale> local;
  final Locale defaultLocal;
  PlatformApp({
    @required this.title,
    @required this.theme,
    @required this.home,
    @required this.router,
    this.delegate,
    this.defaultLocal,
    this.local,
  }) : super(
            title: title,
            home: home,
            locale:defaultLocal,
            localizationsDelegates: delegate == null
                ? [
                    //此处
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
//              const FallbackCupertinoLocalisationsDelegate()
                  ]
                : [
                    delegate,
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
            supportedLocales: local != null
                ? local.contains(S.delegate.supportedLocales)
                : S.delegate.supportedLocales,
//            localeResolutionCallback:
//                S.delegate.resolution(fallback: defaultLocal),
            routes: router);
}

/**
 * 脚手架
 */
class PlatformScaffold
    extends BasePlatformWidget<Scaffold, CupertinoPageScaffold> {
  final PlatformAppBar appBar;
  final Widget body;
  final Color backgroundColor;
  State nowState;
  PlatformScaffold({
    this.appBar,
    @required this.body,
    this.backgroundColor,
  });

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar != null
          ? appBar.createAndroidWidget(context)
          : null,
      body: body,
      backgroundColor: backgroundColor != null
          ? backgroundColor
          : CupertinoTheme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  CupertinoPageScaffold createIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
      appBar != null ? appBar.createIosWidget(context) : null,
      child: body,
      backgroundColor: backgroundColor != null
          ? backgroundColor
          : CupertinoTheme.of(context).scaffoldBackgroundColor,
    );
  }
}

/**
 * AppBar
 */
class PlatformAppBar
    extends BasePlatformWidget<AppBar, CupertinoNavigationBar> {
  final Widget title;
  final Widget leading;
  final Color backgroundColor;
  final Widget trailing;
  final bool showBackButton;
  final Color backButtonColor;
  final Function() backTap;
  PlatformAppBar(
      {this.title,
      this.leading,
      this.backgroundColor,
      this.trailing,
      this.showBackButton = false,
      this.backButtonColor,
      this.backTap});

  @override
  AppBar createAndroidWidget(BuildContext context) {
    var leftBt;
    if (leading != null)
      leftBt = leading;
    else if (showBackButton)
      leftBt = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: backButtonColor != null
              ? backButtonColor
              : Theme.of(context).backgroundColor,
        ),
        onPressed: () => backTap(),
      );
    return new AppBar(
        leading: leftBt,
        title: title,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 15),
            child: trailing,
          )
        ],
        backgroundColor: this.backgroundColor == null
            ? CupertinoTheme.of(context).primaryColor
            : this.backgroundColor);
  }

  @override
  CupertinoNavigationBar createIosWidget(BuildContext context) {
    var leftBt;
    if (leading != null)
      leftBt = leading;
    else if (showBackButton)
      leftBt = CupertinoNavigationBarBackButton(
        onPressed: () => backTap(), //Navigator.pop(context),
        color: backButtonColor != null
            ? backButtonColor
            : CupertinoTheme.of(context).primaryContrastingColor,
      );
    return new CupertinoNavigationBar(
      leading: leftBt,
      middle: title,
      trailing: trailing,
      backgroundColor: this.backgroundColor == null
          ? CupertinoTheme.of(context).primaryColor
          : this.backgroundColor,
    );
  }
}

/**
 * TextField
 */
class PlatformTextField
    extends BasePlatformWidget<TextField, CupertinoTextField> {
  final TextEditingController controller;
  final Widget suffix;
  final Widget prefix;
  final bool readOnly;
  final Function() onTap;
  final String placeholder;
  InputDecoration androidDecoration;
  BoxDecoration iosDecoration;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final TextInputType inputType;
  final int maxLines;
  final bool expands;
  PlatformTextField({
    this.controller,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.placeholder,
    this.androidDecoration,
    this.iosDecoration,
    this.borderSide,
    this.borderRadius,
    this.maxLines = 1,
    this.expands = false,
    this.inputType = TextInputType.text
  });

  @override
  TextField createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    if(androidDecoration == null)
      androidDecoration = InputDecoration(
        contentPadding: EdgeInsets.all(10.0)
      );
    if (placeholder != null)
      androidDecoration = androidDecoration.copyWith(hintText: placeholder);
    
    if (suffix != null)
      androidDecoration = androidDecoration.copyWith(suffix: suffix);

    if (prefix != null)
      androidDecoration = androidDecoration.copyWith(prefix: prefix);

    if (borderSide != null || borderRadius != null) 
      androidDecoration = androidDecoration.copyWith(
        border: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
        focusedBorder: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
      );
    
    return TextField(
      controller: controller,
      decoration: androidDecoration,
      onTap: onTap,
      maxLines: maxLines != 1 ? maxLines : (inputType == TextInputType.multiline ? 0 : 1) ,
      readOnly: readOnly,
      expands: expands,
      keyboardType: inputType,
      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(textBaseline: TextBaseline.alphabetic),
      obscureText: inputType == TextInputType.visiblePassword ,
    );
  }

  @override
  CupertinoTextField createIosWidget(BuildContext context) {
    // TODO: implement createIosWidget
    if (borderSide != null || borderRadius != null) if (iosDecoration != null)
      iosDecoration.copyWith(
          border: Border(
              bottom: borderSide,
              top: borderSide,
              left: borderSide,
              right: borderSide),
          borderRadius: borderRadius);
    else
      iosDecoration = BoxDecoration(
          border: Border(
              bottom: borderSide,
              top: borderSide,
              left: borderSide,
              right: borderSide),
          borderRadius: borderRadius);
    return CupertinoTextField(
      placeholder: placeholder,
      decoration: iosDecoration,
      suffix: suffix,
      prefix: prefix,
      padding: EdgeInsets.all(10),
      maxLines: maxLines != 1 ? maxLines : (inputType == TextInputType.multiline ? 0 : maxLines),
      obscureText: inputType == TextInputType.visiblePassword ,
      expands: expands,
      onTap: onTap,
      style: CupertinoTheme.of(context).textTheme.textStyle,
      readOnly: readOnly,
      controller: controller,
      keyboardType: inputType,
    );
  }
}

enum PlatformIconEnum {
  back,
  delete,
  add,
  right_arrow,
  left_arrow,
  close,
}

/**
 * icon
 */
class PlatformIcon {
  static Icon getIcon(PlatformIconEnum icon, {Color color = Colors.white}) {
    if (Platform.isIOS) {
      switch (icon) {
        case PlatformIconEnum.add:
          return Icon(
            CupertinoIcons.add,
            color: color,
          );
        case PlatformIconEnum.back:
          return Icon(CupertinoIcons.back, color: color);
        case PlatformIconEnum.delete:
          return Icon(CupertinoIcons.delete, color: color);
        case PlatformIconEnum.right_arrow:
          return Icon(CupertinoIcons.forward, color: color);
        case PlatformIconEnum.left_arrow:
          return Icon(CupertinoIcons.back, color: color);
        case PlatformIconEnum.close:
          return Icon(CupertinoIcons.clear_thick_circled, color: color);
        default:
          return null;
      }
    } else {
      switch (icon) {
        case PlatformIconEnum.add:
          return Icon(Icons.add, color: color);
        case PlatformIconEnum.back:
          return Icon(Icons.arrow_back, color: color);
        case PlatformIconEnum.delete:
          return Icon(Icons.delete, color: color);
        case PlatformIconEnum.right_arrow:
          return Icon(Icons.arrow_forward_ios, color: color);
        case PlatformIconEnum.left_arrow:
          return Icon(Icons.arrow_back_ios, color: color);
        case PlatformIconEnum.close:
          return Icon(Icons.cancel, color: color);
        default:
          return null;
      }
    }
  }
}

/**
 * Button
 */
class PlatformButton extends BasePlatformWidget<FlatButton, CupertinoButton> {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final Color disabledColor;
  final EdgeInsets padding;
  final double minSize;
  final BorderRadius borderRadius;
  final ButtonTextTheme textTheme;
  PlatformButton(
      {this.onPressed,
      this.child,
      this.color,
      this.padding,
      this.disabledColor = Colors.transparent,
      this.minSize,
      this.borderRadius,
      this.textTheme});

  @override
  FlatButton createAndroidWidget(BuildContext context) {
    var bt = FlatButton(
      onPressed: onPressed,
      child: child,
      color: color,
      disabledColor: disabledColor,
      padding: padding,
      textTheme: textTheme,
    );
    return bt;
  }

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return new CupertinoButton(
      child: child,
      onPressed: onPressed,
      disabledColor: disabledColor,
      color: color,
      padding: padding,
      minSize: minSize,
      borderRadius: borderRadius,
    );
  }
}

class PlatformPicker
    extends BasePlatformWidget<DropdownButton<int>, PlatformTextField> {
  final List<String> data;
  final String hidText;
  int value;
  final double childHeight;
  final Function(int value) onChanged;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  int tmpValue;
  PlatformPicker(
    this.data, {
    @required this.onChanged,
    this.hidText,
    this.value,
    this.childHeight = 60,
    this.borderSide,
    this.borderRadius,
  });

  @override
  DropdownButton<int> createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    List<DropdownMenuItem<int>> _data = [];
    for (var i = 0; i < data.length; i++)
      _data.add(DropdownMenuItem<int>(child: Center(child: Text(data[i]),) , value: i));

    return DropdownButton<int>(
      items: _data,
      hint: this.hidText != null ? Center(child: Text(this.hidText),)  : null,
      onChanged: (value) => onChanged(value),
      value: this.value,
    );
  }

  var controller = TextEditingController();

  @override
  PlatformTextField createIosWidget(BuildContext context) {
    // TODO: implement createIosWidget
    List<Widget> _data = [];
    for (var i = 0; i < data.length; i++)
      _data
          .add(DropdownMenuItem(child: Center(child: Text(data[i])), value: i));
    if(_data.length > 0) {
      if (value == null)
        value = 0;
      tmpValue = value;
    }
//    controller.text = data[tmpValue];
//    jt.quarterTurns = 180;
    return PlatformTextField(
      borderRadius: borderRadius,
      borderSide: borderSide,
      placeholder: this.hidText,
      controller: controller,
      readOnly: true,
      suffix: RotatedBox(
        quarterTurns: 135,
        child: Icon(
          CupertinoIcons.back,
          color: CupertinoTheme.of(context).textTheme.textStyle.color,
        ),
      ),
      onTap: () {
        final picker = CupertinoPicker(
          children: _data,
          backgroundColor: CupertinoTheme.of(context).primaryContrastingColor,
          onSelectedItemChanged: (num) {
            tmpValue = num;
            // onChanged(num);
            // controller.text = data[num];
          },
          itemExtent: childHeight,
        );
        showCupertinoModalPopup(
            context: context,
            builder: (ctx) {
              return Container(
                  color: CupertinoTheme.of(context).primaryContrastingColor,
                  height: 240,
                  child: Column(children: <Widget>[
                    Container(
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          PlatformButton(
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 14),
                            child: Text("取消",style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                color: CupertinoTheme.of(context).textTheme.textStyle.color,
                              fontSize: 16
                            ),),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          PlatformButton(
                            onPressed: () {
                              onChanged(tmpValue);
                              controller.text = data[tmpValue];
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 14),
                            child: Text(
                              "确定",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                  fontSize: 16,
                                  color: CupertinoTheme.of(context)
                                      .primaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: picker,
                    ),
                  ]));
            });
      },
    );
    // return
  }
}
