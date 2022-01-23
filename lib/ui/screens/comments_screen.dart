import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/utils/show_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fluttergram/domain/entity/comment.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String mediaUrl;

  const CommentsScreen({
    Key? key,
    required this.postId,
    required this.ownerId,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _commentsStream;

  @override
  void initState() {
    super.initState();
    _commentsStream = FirebaseReference.commentsDB
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void addComment() async {
    final _currenUser = UserService.currentUser;
    final textData = _commentController.text.trim();
    await FirebaseReference.commentsDB
        .doc(widget.postId)
        .collection('comments')
        .add({
      'userId': _currenUser.id,
      'username': UserService.currentUser.username,
      'avatar': UserService.currentUser.photoUrl,
      'comment': textData,
      'timestamp': DateTime.now(),
    });
    if (_currenUser.id != widget.ownerId) {
      FirebaseReference.activityDB
          .doc(widget.ownerId)
          .collection('feedItems')
          .doc(widget.postId)
          .set({
        'type': 'comment',
        'commentData': textData,
        'username': _currenUser.username,
        'userId': _currenUser.id,
        'userAvatar': _currenUser.photoUrl,
        'postId': widget.postId,
        'mediaUrl': widget.mediaUrl,
        'timestamp': DateTime.now(),
      });
    }

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        isTimeLine: false,
        text: 'Comments',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _commentsStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingWidget();
                }
                final List comments = snapshot.data.docs
                    .map((doc) => Comment.fromDocument(doc))
                    .toList();

                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'No comments',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) => CommentWidget(
                    commentData: comments[index],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 20.0 : 0.0),
            child: ListTile(
              title: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Write a message...',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  isDense: true,
                ),
              ),
              trailing: IconButton(
                onPressed: addComment,
                splashRadius: 25.0,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment commentData;
  const CommentWidget({
    Key? key,
    required this.commentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showProfile(context, commentData.userId),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(commentData.avatar),
      ),
      title: Text(commentData.comment),
      subtitle: Text(timeago.format(commentData.timestamp.toDate())),
    );
  }
}
