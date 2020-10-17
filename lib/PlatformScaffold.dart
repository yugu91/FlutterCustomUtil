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
  final List<NavigatorObserver> navigatorObservers;
  /// 默认[英语,中文] 再默认上新增
//  final List<Locale> local;
  /// 默认语言，null则为 support 第一个
  final Locale defaultLocal;
  /// 当前语言
  final Locale nowLocale;
  /// 返回当前LOCALE
  final Function(Locale local) callBackLocal;
  PlatformApp({
    @required this.title,
    @required this.theme,
    @required this.home,
    @required this.router,
    this.delegate,
    this.defaultLocal, //非英语环境需要在xcode加入中文支持选项
    this.nowLocale,
    this.navigatorObservers,
//    this.local,
    this.callBackLocal,
  }) : super(
            title: title,
            home: home,
            navigatorObservers:navigatorObservers,
            locale:defaultLocal,
            localizationsDelegates: delegate == null
                ? [
                    //此处
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ]
                : [
                    delegate,
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (local,support) {
              Locale myLocale;
              if (nowLocale == null) {
                myLocale = local;
              } else {
                myLocale = nowLocale;
              }
              Locale l = S.delegate.resolution(
                  fallback: defaultLocal,
                  withCountry: false//myLocale.countryCode != null && myLocale.countryCode != ""
              )(
                  myLocale,
                  S.delegate.supportedLocales
              );
              if(callBackLocal != null)
                callBackLocal(l);
              return l;
            },
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
    extends BasePlatformWidget<Widget, CupertinoNavigationBar> {
  final Widget title;
  final Widget leading;
  final Color backgroundColor;
  final Widget trailing;
  final bool showBackButton;
  final Color backButtonColor;
  final bool showCloseButton;
  final Function() backTap;
  final double elevation;
  final double height;
  final String heroTag;
  PlatformAppBar(
      {this.title,
      this.leading,
      this.backgroundColor,
      this.trailing,
      this.showBackButton = false,
      this.showCloseButton = false,
      this.backButtonColor,
      this.elevation = 4.0,
        this.height,
      this.heroTag = "appbar",
      this.backTap});

  @override
  Widget createAndroidWidget(BuildContext context) {
    var leftBt;
    if (leading != null)
      leftBt = leading;
    else if (showBackButton || showCloseButton)
      leftBt = IconButton(
        icon:
          showCloseButton ? PlatformIcon.getIcon(PlatformIconEnum.close,color: backButtonColor) : Icon(Icons.arrow_back_ios,
          color: backButtonColor != null
              ? backButtonColor
              : Theme.of(context).backgroundColor,
        ),
        onPressed: () => backTap(),
      );
    var appBar = AppBar(
        leading: leftBt,
        title: title,
        elevation:elevation,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 4, bottom: 4, right: 15),
            child: trailing,
          )
        ],
        backgroundColor: this.backgroundColor == null
            ? CupertinoTheme.of(context).primaryColor
            : this.backgroundColor);
    if(height != null){
      return PreferredSize(
        child: appBar,
        preferredSize: Size.fromHeight(height),
      );
    }else{
      return appBar;
    }
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
      heroTag: heroTag,
      transitionBetweenRoutes: false,
      padding: EdgeInsetsDirectional.only(start: 0,bottom: 0),
      border: elevation == 0 ? Border.all(width: elevation,color:Colors.transparent) : null,
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
  final TextStyle placeHolderStyle;
  final InputDecoration androidDecoration;
  final BoxDecoration iosDecoration;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final TextInputType inputType;
  final int maxLines;
  final bool expands;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onSubmitted;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  PlatformTextField({
    this.controller,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.placeholder,
    this.placeHolderStyle,
    this.androidDecoration,
    this.iosDecoration,
    this.borderSide,
    this.borderRadius,
    this.maxLines = 1,
    this.expands = false,
    this.inputType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.obscureText = false,
    this.autofocus = false,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode
  });

  @override
  TextField createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    var _androidDecoration = androidDecoration;
    if(_androidDecoration == null)
      _androidDecoration = InputDecoration(
        contentPadding: EdgeInsets.all(10.0)
      );
    if (placeholder != null) {
      _androidDecoration = _androidDecoration.copyWith(
        hintText: placeholder,
        hintStyle: placeHolderStyle
      );
    }
    
    if (suffix != null)
      _androidDecoration = _androidDecoration.copyWith(suffix: suffix);

    if (prefix != null)
      _androidDecoration = _androidDecoration.copyWith(prefix: prefix);

    if (borderSide != null || borderRadius != null) 
      _androidDecoration = _androidDecoration.copyWith(
        border: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
        focusedBorder: OutlineInputBorder(
            borderSide: borderSide, borderRadius: borderRadius),
      );
    else if(borderSide == null){
      _androidDecoration = _androidDecoration.copyWith(
        border: InputBorder.none
      );
    }
    
    return TextField(
      controller: controller,
      decoration: _androidDecoration,
      onTap: onTap,
      onSubmitted: onSubmitted,
      textAlign: textAlign,
      textInputAction: this.textInputAction,
      maxLines: maxLines != 1 ? maxLines : (inputType == TextInputType.multiline ? 0 : 1) ,
      readOnly: readOnly,
      focusNode: focusNode,
      expands: expands,
      onChanged: (s) => onTap != null ? onTap() : null,
      keyboardType: inputType,
      autofocus:autofocus,
      style: textStyle != null ? textStyle : CupertinoTheme.of(context).textTheme.textStyle.copyWith(textBaseline: TextBaseline.alphabetic),
      obscureText: inputType == TextInputType.visiblePassword || this.obscureText,
    );
  }

  @override
  CupertinoTextField createIosWidget(BuildContext context) {
    // TODO: implement createIosWidget
    var _iosDecoration = iosDecoration;
    if (borderSide != null || borderRadius != null) if (_iosDecoration != null)
      _iosDecoration.copyWith(
          border: Border(
              bottom: borderSide,
              top: borderSide,
              left: borderSide,
              right: borderSide),
          borderRadius: borderRadius);
    else
      _iosDecoration = BoxDecoration(
          border: Border(
              bottom: borderSide,
              top: borderSide,
              left: borderSide,
              right: borderSide),
          borderRadius: borderRadius);
    return CupertinoTextField(
      placeholder: placeholder,
      placeholderStyle: placeHolderStyle,
      decoration: _iosDecoration,
      textAlign: textAlign,
      suffix: suffix,
      prefix: prefix,
      focusNode:focusNode,
      textInputAction: this.textInputAction,
      onSubmitted: onSubmitted,
      onChanged: (s) => onTap != null ? onTap() : null,
      padding: EdgeInsets.all(10),
      maxLines: maxLines != 1 ? maxLines : (inputType == TextInputType.multiline ? 0 : maxLines),
      obscureText: inputType == TextInputType.visiblePassword || this.obscureText,
      expands: expands,
      onTap: onTap,
      autofocus: autofocus,
      style: textStyle != null ? textStyle : CupertinoTheme.of(context).textTheme.textStyle,
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
          return Icon(Icons.clear, color: color);
        default:
          return null;
      }
    }
  }
}

/**
 * Button
 */
class PlatformButton extends BasePlatformWidget<Widget, CupertinoButton> {
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
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      this.textTheme});

  @override
  Widget createAndroidWidget(BuildContext context) {
    const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.all(16);
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    // final Color primaryColor = themeData.primaryColor;
    final Color backgroundColor = color == null
        ? Colors.transparent
        : CupertinoDynamicColor.resolve(color, context);

    final TextStyle textStyle = themeData.textTheme.textStyle.copyWith(color: themeData.primaryContrastingColor);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding:padding == null ? _kBackgroundButtonPadding : padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
          child: DefaultTextStyle(
            style: textStyle,
            child: child,
          )
        ),
      ),
    );
//    var bt = ButtonTheme(
//      minWidth: 0,
//      height: 2,
//      child:Button(
//        onPressed: onPressed,
//        child: child,
//        color: color,
//        disabledColor: disabledColor,
//        padding: padding == null ? EdgeInsets.all(0) : padding,
//        textTheme: textTheme,
//      ) ,
//    ) ;
//    return bt;
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
  final int value;
  final double childHeight;
  final Function(int value) onChanged;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final bool hideUnderLine;
  final double widthForAndroid;
  PlatformPicker(
    this.data, {
    @required this.onChanged,
    this.hidText,
    this.value,
    this.childHeight = 60,
    this.borderSide,
    this.borderRadius,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.hideUnderLine = false,
    this.widthForAndroid
  });

  @override
  DropdownButton<int> createAndroidWidget(BuildContext context) {
    // TODO: implement createAndroidWidget
    List<DropdownMenuItem<int>> _data = [];
    for (var i = 0; i < data.length; i++)
      _data.add(DropdownMenuItem<int>(child:
        widthForAndroid != null && widthForAndroid > 0 ?
          SizedBox(width: widthForAndroid,child: Center(child: Text(data[i])))
          : Center(child: Text(data[i])),
          value: i));

    return DropdownButton<int>(
      items: _data,
      style: textStyle,
      underline: hideUnderLine ? SizedBox(height: 0,) : null,
      hint: this.hidText != null ? Center(child: Text(this.hidText),)  : null,
      onChanged: (value) => onChanged(value),
      value: this.value,
    );
  }

  @override
  PlatformTextField createIosWidget(BuildContext context) {
    // TODO: implement createIosWidget
    var _controller = TextEditingController();
    int tmpValue;
    List<Widget> _data = [];
    for (var i = 0; i < data.length; i++)
      _data
          .add(DropdownMenuItem(child: Center(child: Text(data[i])), value: i));
    var _value = value;
    if(_data.length > 0) {
      if (_value == null)
        _value = 0;
      tmpValue = _value;
      _controller.text = data[tmpValue];
    }
//    jt.quarterTurns = 180;
    return PlatformTextField(
      borderRadius: borderRadius,
      borderSide: borderSide,
      placeholder: this.hidText,
      controller: _controller,
      textAlign: textAlign,
      readOnly: true,
      textStyle: textStyle,
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
          scrollController:FixedExtentScrollController(
            initialItem: _value
          ),
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
                              _controller.text = data[tmpValue];
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
