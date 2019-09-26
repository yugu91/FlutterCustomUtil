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
  PlatformApp({
    @required this.title,
    @required this.theme,
    @required this.home,
    @required this.router,
    this.delegate,
    this.local,
  }) : super(
            title: title,
            home: home,
            localizationsDelegates: delegate == null
                ? [
                    //此处
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ]
                : [
                    delegate,
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
            supportedLocales: local != null
                ? local.contains(S.delegate.supportedLocales)
                : S.delegate.supportedLocales,
            localeResolutionCallback:
                S.delegate.resolution(fallback: const Locale('en', '')),
            routes: router);
}

/**
 * 脚手架
 */
class PlatformScaffold
    extends BasePlatformWidget<Scaffold, CupertinoPageScaffold> {
  PlatformScaffold({this.appBar, @required this.body, this.backgroundColor});

  final PlatformAppBar appBar;
  final Widget body;
  final Color backgroundColor;

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar != null ? appBar.createAndroidWidget(context) : null,
      body: body,
      backgroundColor: backgroundColor != null
          ? backgroundColor
          : CupertinoTheme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  CupertinoPageScaffold createIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appBar != null ? appBar.createIosWidget(context) : null,
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
          Icons.close,
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
  });

  @override
  TextField createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    if (placeholder != null) if (androidDecoration != null)
      androidDecoration.copyWith(hintText: placeholder);
    else
      androidDecoration = InputDecoration(hintText: placeholder);
    if (suffix != null) if (androidDecoration != null)
      androidDecoration.copyWith(suffix: prefix);
    else
      androidDecoration = InputDecoration(prefixIcon: suffix);
    if (prefix != null) if (androidDecoration != null)
      androidDecoration.copyWith(prefix: prefix);
    else
      androidDecoration = InputDecoration(prefix: suffix);

    if(borderSide != null || borderRadius != null)
      if(androidDecoration != null)
        androidDecoration.copyWith(border: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: borderRadius
        ));
      else
        androidDecoration = InputDecoration(border: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: borderRadius
        ));

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
    if(borderSide != null || borderRadius != null)
      if(iosDecoration != null)
        iosDecoration.copyWith(border: Border(
            bottom: borderSide,top: borderSide,left: borderSide,right: borderSide),
            borderRadius: borderRadius
        );
      else
        iosDecoration = BoxDecoration(
            border: Border(bottom: borderSide,top: borderSide,left: borderSide,right: borderSide),
            borderRadius: borderRadius
        );
    return CupertinoTextField(
      placeholder: placeholder,
      decoration: iosDecoration,
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
  right_arrow,
  left_arrow,
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
      this.disabledColor,
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
