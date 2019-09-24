import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';

enum CustomListViewLinsentFlag {
  refresh,
  nextPage,
  passItem
}

class CustomListView extends StatefulWidget {
  List<Object> data;
  int pageMax;
  final bool pullRefresh;
//  int pageCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(int index,CustomListViewLinsentFlag flag) lisent;
  CustomListView({
    @required this.itemBuilder,
    @required this.data,
//    @required this.pageCount,
    this.pullRefresh = true,
    this.lisent,
    this.pageMax = 1,
  }) : super();
  State nowState;
  @override
  State<StatefulWidget> createState() {
    nowState = _CustomListViewState();
    return nowState;
  }

  void updateData(List _data) {
    nowState.setState(() {
      data = _data;
    });
  }

  void updatePageMax(int _pageMax) {
    nowState.setState(() {
      pageMax = _pageMax;
    });
  }
}

class _CustomListViewState extends State<CustomListView> {
  final ScrollController _scrollController = ScrollController();
  int pageNum = 1;
  _CustomListViewState() {
    _scrollController.addListener(() {
      if (widget.lisent == null) return;
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll == pixels && widget.pageMax > pageNum) {
//        上拉刷新做处理
        print('load more ...');
        pageNum += 1;
        widget.lisent(pageNum, CustomListViewLinsentFlag.nextPage);
      }
    });
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
          Text("正在获取更多...")
        ],
      )),
    );
  }

  Widget _loadFinalWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(child: Text("已没有更多数据")),
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    if (widget.pullRefresh && Platform.isIOS) {
      list.add(CupertinoSliverRefreshControl(
        onRefresh: () => widget.lisent(1,CustomListViewLinsentFlag.refresh)
      ));
    }

    list.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (widget.data.length == 0) {
            //没有数据
            return _noData();
          } else if (pageNum >= widget.pageMax &&
              index == widget.data.length &&
              widget.pageMax > 1) {
            //没有下一页
            return _loadFinalWidget();
          } else if (index == widget.data.length) {
            //加载下一页
            return _loadMoreWidget();
          } else {
            //普通数据显示
            return CupertinoButton(
              child: widget.itemBuilder(context, index),
              padding: EdgeInsets.all(0),
              onPressed: (){
                widget.lisent(index, CustomListViewLinsentFlag.passItem);
              },
            );
            //          return Text("fdgfh");
          }
        },
        childCount:
            widget.pageMax > 1 ? widget.data.length + 1 : widget.data.length,
      ),
    ));
    
    if(Platform.isIOS) {
      return CustomScrollView(
        slivers: list,
        controller: _scrollController,
      );
    }else{
      return RefreshIndicator(
        onRefresh: ()=> widget.lisent(1,CustomListViewLinsentFlag.refresh),
        child: CustomScrollView(
          slivers: list,
          controller: _scrollController,
        ),
      );
    }
  }
}
