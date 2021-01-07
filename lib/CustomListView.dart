import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'generated/l10n.dart';

enum CustomListViewLinsentFlag { refresh, nextPage, passItem }

class CustomListView<T> extends StatefulWidget {
  final List<Object> data;
  final int pageMax;
  final bool pullRefresh;
  final Widget header;
  final Widget footer;
  final bool alwaysScroll;
//  int pageCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(int index, CustomListViewLinsentFlag flag) lisent;
  final updateStream = StreamController<dynamic>();
  final Widget sliderTop;
  final int pageNo;

  // Function(List _data) updateData;
  // Function(int _pageIndex) updatePageMax;
  final Function(double px) onscroll;
  final ScrollController scrollController;
  CustomListView(
      {@required this.itemBuilder,
      @required this.data,
//    @required this.pageCount,
      this.pullRefresh = true,
      this.lisent,
      @required this.pageMax,
      @required this.pageNo,
      this.footer,
      this.header,
      this.sliderTop,
      this.alwaysScroll = true,
      this.onscroll,
      this.scrollController})
      : super();
  @override
  State<StatefulWidget> createState() => _CustomListViewState<T>();
}

class _CustomListViewState<T> extends State<CustomListView> {
  ScrollController _scrollController;
  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    this.pageNum = widget.pageNo;
    if (widget.scrollController == null)
      _scrollController = ScrollController();
    else
      _scrollController = widget.scrollController;

    _scrollController.addListener(() {
      if (widget.lisent == null) return;
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll == pixels && widget.pageMax > pageNum) {
//        上拉刷新做处理
        print('load more ...');
        pageNum += 1;
        widget.lisent(pageNum, CustomListViewLinsentFlag.nextPage);
      } else if (widget.onscroll != null) {
        widget.onscroll(pixels);
      }
    });
    widget.updateStream.stream.listen((event) {
      this.pageSet(event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.updateStream.close();
  }

  void pageSet(int pageNo) {
    this.pageNum = pageNo;
  }

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
          Text(S.of(context) == null ? "更多" : S.of(context).listLoadMore)
        ],
      )),
    );
  }

  Widget _loadFinalWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
          child: Text(S.of(context) == null ? '完' : S.of(context).listNoMore)),
    );
  }

  Widget _addView(Widget child) {
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget _getSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //普通数据显示
          return CupertinoButton(
            child: widget.itemBuilder(context, index),
            padding: EdgeInsets.all(0),
            onPressed: () {
              widget.lisent(index, CustomListViewLinsentFlag.passItem);
            },
          );
          //          return Text("fdgfh");
        },
        childCount: widget.data.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // widget.updateData = (List _data) {
    //   setState(() {
    //     widget.data = _data;
    //   });
    // };
    // widget.updatePageMax = (int _pageMax) {
    //   setState(() {
    //     widget.pageMax = _pageMax;
    //   });
    // };

    var list = <Widget>[];
    if (widget.sliderTop != null) list.add(widget.sliderTop);
    if (widget.pullRefresh && Platform.isIOS)
      list.add(CupertinoSliverRefreshControl(
          onRefresh: () =>
              widget.lisent(1, CustomListViewLinsentFlag.refresh)));
    if (widget.header != null) list.add(_addView(widget.header));

    list.add(_getSliver());
    if (widget.footer != null)
      list.add(SliverToBoxAdapter(
        child: widget.footer,
      ));

    if (widget.data.length == 0) {
      //没有数据
      list.add(_addView(_noData()));
    } else if (widget.pageMax > 1) {
      //没有下一页
      if (pageNum >= widget.pageMax)
        list.add(_addView(_loadFinalWidget()));
      else
        list.add(_addView(_loadMoreWidget()));
    }

    if (Platform.isIOS) {
      return CustomScrollView(
        slivers: list,
        physics:
            widget.alwaysScroll ? const AlwaysScrollableScrollPhysics() : null,
        controller: _scrollController,
      );
    } else {
      if (widget.pullRefresh)
        return RefreshIndicator(
          onRefresh: () {
            pageNum = 1;
            return widget.lisent(pageNum, CustomListViewLinsentFlag.refresh);
          },
          child: CustomScrollView(
            slivers: list,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
          ),
        );
      else
        return CustomScrollView(
          slivers: list,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
        );
    }
  }
}
