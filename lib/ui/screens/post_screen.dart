import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/post.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String userId;
  const PostScreen({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String postDescription = '';
  bool isLoading = false;
  late Post post;

  void getPosts() async {
    setState(() => isLoading = true);
    var data = await FirebaseReference.postDB
        .doc(widget.userId)
        .collection('userPosts')
        .doc(widget.postId)
        .get();
    post = Post.fromDocument(data);
    postDescription = post.description;
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        text: postDescription,
      ),
      body: isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: PostListWidget(post: post),
            ),
    );
  }
}
