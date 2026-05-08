import 'package:flutter/material.dart';

class CustomInfiniteScrollList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final Widget? loadingWidget;
  final Widget? emptyWidget;

  const CustomInfiniteScrollList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.loadingWidget,
    this.emptyWidget,
  });

  @override
  State<CustomInfiniteScrollList> createState() => _CustomInfiniteScrollListState();
}

class _CustomInfiniteScrollListState extends State<CustomInfiniteScrollList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0 && !widget.isLoading) {
      return widget.emptyWidget ?? const Center(child: Text("No data found"));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.loadingWidget ?? const CircularProgressIndicator(),
            ),
          );
        }
        return widget.itemBuilder(context, index);
      },
    );
  }
}
