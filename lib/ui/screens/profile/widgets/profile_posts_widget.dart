import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttergram/domain/entity/post.dart';
import 'package:fluttergram/resources/resources.dart';
import 'package:fluttergram/ui/utils/show_post.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class ProfilePostsWidget extends StatelessWidget {
  const ProfilePostsWidget({
    Key? key,
    required this.posts,
    required this.isPostOrientationGrid,
  }) : super(key: key);

  final List<Post> posts;
  final bool isPostOrientationGrid;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              Svgs.noContent,
              height: 300.0,
              fit: BoxFit.scaleDown,
            ),
            const Text(
              'No content',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    return isPostOrientationGrid
        ? GridView.count(
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: posts
                .map(
                  (post) => GridTile(
                    child: GestureDetector(
                      onTap: () => showPost(context, post.postId, post.ownerId),
                      child: CachedNetworkImageWidget(
                        url: post.mediaUrl,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        : Column(
            children: posts.map((post) => PostListWidget(post: post)).toList(),
          );
  }
}
