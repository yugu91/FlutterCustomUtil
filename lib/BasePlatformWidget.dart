import 'dart:io';

import 'package:flutter/widgets.dart';

/**
 * 会根据平台，去适配所在平台的小部件
 * Flutter中包含了适用于IOS和Android的两套原生小部件，名为Cupertino和Material
 */
abstract class BasePlatformWidget<A extends Widget, I extends Widget>
    extends StatelessWidget {
  A createAndroidWidget(BuildContext context);

  I createIosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    /**如果是IOS平台，返回ios风格的控件
     * Android和其他平台都返回materil风格的控件
     */
    if (Platform.isIOS) {
      return createIosWidget(context);
    }
    return createAndroidWidget(context);
  }
}