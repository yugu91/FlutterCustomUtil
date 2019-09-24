import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'BasePlatformWidget.dart';

class PlatformApp extends CupertinoApp{
  final String title;
  final CupertinoThemeData theme;
  final Widget home;
  final Map<String, WidgetBuilder> router;
  PlatformApp({
    @required this.title,
    @required this.theme,
    @required this.home,
    @required this.router,
  }) : super(
    title: title,
    home: home,
    localizationsDelegates: [                             //此处
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('zh', 'CH'),
      const Locale('en', 'US'), // English
    ],
    routes: router
  );
}

/**
 * 脚手架
 */
class PlatformScaffold
    extends BasePlatformWidget<Scaffold, CupertinoPageScaffold> {


  PlatformScaffold({this.appBar, this.body});

  final PlatformAppBar appBar;
  final Widget body;

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar.createAndroidWidget(context),
      body: body,
    );
  }

  @override
  CupertinoPageScaffold createIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appBar.createIosWidget(context),
      child: body,
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
  PlatformAppBar({
    this.title,
    this.leading,
    this.backgroundColor,
    this.trailing,
    this.showBackButton = false,
    this.backButtonColor,
    this.backTap
  });

  @override
  AppBar createAndroidWidget(BuildContext context) {
    var leftBt;
    if(leading != null)
      leftBt = leading;
    else if(showBackButton)
      leftBt = IconButton(
        icon: Icon(
          Icons.close,
          color: backButtonColor != null ? backButtonColor : Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: () => backTap(),
      );
    return new AppBar(
      leading: leftBt ,
      title: title,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8,bottom: 8, right: 15),
          child: trailing,
        )
      ],
      backgroundColor: this.backgroundColor == null ? CupertinoTheme.of(context).primaryColor : this.backgroundColor
    );
  }

  @override
  CupertinoNavigationBar createIosWidget(BuildContext context) {
    var leftBt;
    if(leading != null)
      leftBt = leading;
    else if(showBackButton)
      leftBt = CupertinoNavigationBarBackButton(
        onPressed: () => backTap(),//Navigator.pop(context),
        color: backButtonColor != null ? backButtonColor : CupertinoTheme.of(context).scaffoldBackgroundColor,
      );
    return new CupertinoNavigationBar(
      leading: leftBt,
        middle: title,
        trailing: trailing,
      backgroundColor: this.backgroundColor == null ? CupertinoTheme.of(context).primaryColor : this.backgroundColor,
    );
  }
}

/**
 * TextField
 */
class PlatformTextField extends BasePlatformWidget<TextField, CupertinoTextField> {
  final TextEditingController controller;
  final Widget suffix;
  final Widget prefix;
  final bool readOnly;
  final Function() onTap;
  final String placeholder;
  InputDecoration androidDecoration;
  final BoxDecoration iosDecoration;
  PlatformTextField({
    this.controller,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.placeholder,
    this.androidDecoration,
    this.iosDecoration,
  });

  @override
  TextField createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    if(placeholder != null)
      if(androidDecoration != null)
          androidDecoration.copyWith(hintText: placeholder);
      else
        androidDecoration = InputDecoration(hintText: placeholder);
    if(suffix != null)
      if(androidDecoration != null)
        androidDecoration.copyWith(suffix: prefix);
      else
        androidDecoration = InputDecoration(prefixIcon: suffix);
    if(prefix != null)
      if(androidDecoration != null)
        androidDecoration.copyWith(prefix: prefix);
      else
        androidDecoration = InputDecoration(prefix: suffix);
    return TextField(
      controller: controller,
      decoration: androidDecoration,
      onTap: onTap,
      readOnly: readOnly,

    );
  }

  @override
  CupertinoTextField createIosWidget(BuildContext context) {
    // TODO: implement createIosWidget
    return CupertinoTextField(
      placeholder: placeholder,
      decoration: iosDecoration == null ? BoxDecoration(
        border: Border(
              bottom: BorderSide(color: CupertinoTheme.of(context).barBackgroundColor),
              top: BorderSide(color: CupertinoTheme.of(context).barBackgroundColor),
              left: BorderSide(color: CupertinoTheme.of(context).barBackgroundColor),
              right: BorderSide(color: CupertinoTheme.of(context).barBackgroundColor)
            ),
            borderRadius: BorderRadius.all(Radius.circular(4))
          )
        : iosDecoration,
      suffix: suffix,
      prefix: prefix,
      onTap: onTap,
      readOnly: readOnly,

    );
  }

}

enum PlatformIconEnum {
  back,
  delete,
  add,
}

/**
 * icon
 */
class PlatformIcon{
  static Icon getIcon(PlatformIconEnum icon){
    if(Platform.isIOS){
      switch(icon){
        case PlatformIconEnum.add:
          return Icon(CupertinoIcons.add);
        case PlatformIconEnum.back:
          return Icon(CupertinoIcons.back);
        case PlatformIconEnum.delete:
          return Icon(CupertinoIcons.delete);
        default:
          return null;
      }
    }else{
      switch(icon){
        case PlatformIconEnum.add:
          return Icon(Icons.add);
        case PlatformIconEnum.back:
          return Icon(Icons.arrow_back);
        case PlatformIconEnum.delete:
          return Icon(Icons.delete);
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
  PlatformButton({
    this.onPressed,
    this.child,
    this.color,
    this.padding,
    this.disabledColor,
    this.minSize,
    this.borderRadius,
    this.textTheme
  });

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