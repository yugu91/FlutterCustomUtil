import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'generated/i18n.dart';
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
  final Widget header;
  final Widget footer;
//  int pageCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(int index,CustomListViewLinsentFlag flag) lisent;

  final Widget sliderTop;

  Function(List _data) updateData;
  Function(int _pageIndex) updatePageMax;
  CustomListView({
    @required this.itemBuilder,
    @required this.data,
//    @required this.pageCount,
    this.pullRefresh = true,
    this.lisent,
    this.pageMax = 1,
    this.footer,
    this.header,
    this.sliderTop
  }) : super();
  State nowState;
  @override
  State<StatefulWidget> createState() {
    nowState = _CustomListViewState();
    return nowState;
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

  Widget _addView(Widget child){
    return SliverToBoxAdapter(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.updateData = (List _data){
      setState(() {
        widget.data = _data;
      });
    };
    widget.updatePageMax = (int _pageMax){
      setState(() {
        widget.pageMax = _pageMax;
      });
    };

    var list = <Widget>[];
    if(widget.sliderTop != null)
      list.add(widget.sliderTop);
    if (widget.pullRefresh && Platform.isIOS)
      list.add(CupertinoSliverRefreshControl(
        onRefresh: () => widget.lisent(1,CustomListViewLinsentFlag.refresh)
      ));
    if(widget.header != null)
      list.add(_addView(widget.header));
    list.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
            //普通数据显示
            return CupertinoButton(
              child: widget.itemBuilder(context, index),
              padding: EdgeInsets.all(0),
              onPressed: (){
                widget.lisent(index, CustomListViewLinsentFlag.passItem);
              },
            );
            //          return Text("fdgfh");
        },
        childCount: widget.data.length,
      ),
    ));
//    if(widget.footer != null)
//      list.add(widget.footer);

    if (widget.data.length == 0) {
      //没有数据
      list.add(_addView(_noData()));
    } else if (widget.pageMax > 1) {
      //没有下一页
      if(pageNum >= widget.pageMax)
        list.add(_addView(_loadFinalWidget()));
      else
        list.add(_addView(_loadMoreWidget()));
    }

    if(Platform.isIOS) {
      return CustomScrollView(
        slivers: list,
        controller: _scrollController,
      );
    }else{
      if(widget.pullRefresh)
        return RefreshIndicator(
          onRefresh: ()=> widget.lisent(1,CustomListViewLinsentFlag.refresh),
          child: CustomScrollView(
            slivers: list,
            controller: _scrollController,
          ),
        );
      else
        return CustomScrollView(
          slivers: list,
          controller: _scrollController,
        );
    }
  }
}
