import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/activity_feed.dart';
import 'package:fluttergram/ui/utils/show_post.dart';
import 'package:fluttergram/ui/utils/show_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItemWidget extends StatelessWidget {
  final ActivityFeed feed;
  const ActivityFeedItemWidget({
    Key? key,
    required this.feed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaPreview = feed.type == 'like' || feed.type == 'comment'
        ? GestureDetector(
            onTap: () => showPost(
              context,
              feed.postId,
              feed.userId,
            ),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(feed.mediaUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
        : null;

    final activityItemText = feed.type == 'like'
        ? 'liked your post'
        : feed.type == 'follow'
            ? 'is following you'
            : 'repleid ${feed.commentData}';
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      color: Colors.grey.shade300,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(feed.userAvatar),
        ),
        title: GestureDetector(
          onTap: () => showProfile(context, feed.userId),
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: feed.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' $activityItemText',
                ),
              ],
            ),
          ),
        ),
        subtitle: Text(
          timeago.format(feed.timestamp.toDate()),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: mediaPreview,
      ),
    );
  }
}
