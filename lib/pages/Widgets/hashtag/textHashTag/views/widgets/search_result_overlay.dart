import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/widgets/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertagger/fluttertagger.dart';

import '../view_models/search_view_model.dart';
import 'hashtag_list_view.dart';

class SearchResultOverlay extends StatelessWidget {
  const SearchResultOverlay({
    Key? key,
    required this.tagController,
    required this.animation,
  }) : super(key: key);

  final FlutterTaggerController tagController;
  final Animation<Offset> animation;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SearchResultView>(
      valueListenable: searchViewModel.activeView,
      builder: (_, view, __) {
        if (view == SearchResultView.users) {
          return UserListView(
            tagController: tagController,
            animation: animation,
          );
        }
        if (view == SearchResultView.hashtag) {
          return HashtagListView(
            tagController: tagController,
            animation: animation,
          );
        }
        return const SizedBox();
      },
    );
  }
}
