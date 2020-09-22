import 'dart:io';

import 'package:custom_util_plugin/CustomListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'generated/i18n.dart';

class SingleListView extends StatefulWidget {
  List<Object> data;
  int pageMax;
  final bool pullRefresh;
  final IndexedWidgetBuilder itemBuilder;
  final Future<bool> Function(int index, CustomListViewLinsentFlag flag) lisent;
  Function(List _data) updateData;
  Function(int _pageIndex) updatePageMax;

  final ScrollController scrollController;
  SingleListView(
      {@required this.itemBuilder,
      @required this.data,
//    @required this.pageCount,
      this.pullRefresh = true,
      this.lisent,
      this.pageMax = 1,
      this.scrollController})
      : super();
  State nowState;
  @override
  State<StatefulWidget> createState() {
    nowState = _State();
    return nowState;
  }
}

class _State extends State<SingleListView> {
  // ScrollController _scrollController;
  int pageNum = 1;
  bool loading = false;
//   @override
//   void initState() {
//     super.initState();
//     if (widget.scrollController == null)
//       _scrollController = ScrollController();
//     else
//       _scrollController = widget.scrollController;
//
//     _scrollController.addListener(() {
//       if (widget.lisent == null) return;
//       var maxScroll = _scrollController.position.maxScrollExtent;
//       var pixels = _scrollController.position.pixels;
//
//       if (maxScroll == pixels && widget.pageMax > pageNum) {
// //        上拉刷新做处理
//         print('load more ...');
//         pageNum += 1;
//         widget.lisent(pageNum, CustomListViewLinsentFlag.nextPage);
//       }
//     });
//   }

  Widget _noData() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
//          child: FlatButton.icon(onPressed: null, icon: Icon(Icons.announcement), label: Text("暂无数据"))
//        child: Text(
//          ic
//        ),
          ),
    );
  }

  Widget _loadMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 20.0),
//                child: CircularProgressIndicator(),
          ),
          Text(S.of(context).listLoadMore)
        ],
      )),
    );
  }

  Widget _loadFinalWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(child: Text(S.of(context).listNoMore)),
    );
  }

  Widget _getList() {
    var length = widget.data.length;
    if(length == 0)
      length = 1;
    else if(Platform.isIOS)
      length += 2;
    else
      length += 1;
    return ListView.builder(
      padding: EdgeInsets.zero,
        // primary: true,
          shrinkWrap: true,
        // controller: _scrollController,
        itemBuilder: (context, index) {
          if (widget.data.length == 0)
            return _noData();
            var _index = index;
            if(Platform.isIOS)
              _index -= 1;
          if (widget.data.length == index)
            if (pageNum >= widget.pageMax)
              return _loadFinalWidget();
            else {
              if(!loading) {
                print("load more");
                loading = true;
                widget.lisent(0, CustomListViewLinsentFlag.nextPage).then((
                    value) {
                  loading = false;
                });
              }
              return _loadMoreWidget();
            }

          return GestureDetector(
            onTap: () =>
                widget.lisent(_index, CustomListViewLinsentFlag.passItem),
            child: widget.itemBuilder(context, _index),
          );
        },
        itemCount: widget.data.length == 0 ? 1 : widget.data.length + 1);
  }

  @override
  Widget build(BuildContext context) {
    widget.updateData = (List _data) {
      setState(() {
        widget.data = _data;
      });
    };
    widget.updatePageMax = (int _pageMax) {
      setState(() {
        widget.pageMax = _pageMax;
      });
    };
    if (Platform.isIOS) {
      return _getList();
    } else {
      if (widget.pullRefresh)
        return RefreshIndicator(
          onRefresh: () => widget.lisent(1, CustomListViewLinsentFlag.refresh),
          child: _getList(),
        );
      else
        return _getList();
    }
  }
}
