import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/view_models/home_view_model.dart';
import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/view_models/search_view_model.dart';
import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/widgets/comment_text_field.dart';
import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/widgets/post_widget.dart';
import 'package:afroevent/pages/Widgets/hashtag/textHashTag/views/widgets/search_result_overlay.dart';
import 'package:flutter/material.dart';

import 'package:fluttertagger/fluttertagger.dart';

import 'models/post.dart';



class HashTagHomeView extends StatefulWidget {
  const HashTagHomeView({Key? key}) : super(key: key);

  @override
  State<HashTagHomeView> createState() => _HashTagHomeViewState();
}

class _HashTagHomeViewState extends State<HashTagHomeView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  double overlayHeight = 380;

  late final homeViewModel = HomeViewModel();
  late final _controller = FlutterTaggerController(
    //Initial text value with tag is formatted internally
    //following the construction of FlutterTaggerController.
    //After this controller is constructed, if you
    //wish to update its text value with raw tag string,
    //call (_controller.formatTags) after that.
    text:
        "Hey @11a27531b866ce0016f9e582#brad#. It's time to #11a27531b866ce0016f9e582#Flutter#!",
  );
  late final _focusNode = FocusNode();

  void _focusListener() {
    if (!_focusNode.hasFocus) {
      _controller.dismissOverlay();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var insets = MediaQuery.of(context).viewInsets;
    return GestureDetector(
      onTap: () {
        _controller.dismissOverlay();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("The Squad"),
        ),
        bottomNavigationBar: FlutterTagger(
          controller: _controller,
          animationController: _animationController,
          onSearch: (query, triggerChar) {
            if (triggerChar == "@") {
              // searchViewModel.searchUser(query);
            }
            if (triggerChar == "#") {
              searchViewModel.searchHashtag(query);
            }
          },
          triggerCharacterAndStyles: const {
            "@": TextStyle(color: Colors.pinkAccent),
            "#": TextStyle(color: Colors.green),
          },
          tagTextFormatter: (id, tag, triggerCharacter) {
            return "$triggerCharacter$id#$tag#";
          },
          overlayHeight: overlayHeight,
          overlay: SearchResultOverlay(
            animation: _animation,
            tagController: _controller,
          ),
          builder: (context, containerKey) {
            return CommentTextField(
              focusNode: _focusNode,
              containerKey: containerKey,
              insets: insets,
              controller: _controller,
              onSend: () {
                FocusScope.of(context).unfocus();
                homeViewModel.addPost(_controller.formattedText);
                _controller.clear();
              },
            );
          },
        ),
        body: ValueListenableBuilder<List<Post>>(
          valueListenable: homeViewModel.posts,
          builder: (_, posts, __) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (_, index) {
                return PostWidget(post: posts[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
