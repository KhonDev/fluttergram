import 'package:flutter/material.dart';

import 'package:fluttergram/domain/entity/activity_feed.dart';

import 'package:fluttergram/ui/screens/activity_feed/activity_feed_view_model.dart';
import 'package:fluttergram/ui/screens/activity_feed/widgets/widgets.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.read<ActivityFeedViewModel>();
    return Scaffold(
      appBar: const CustomAppBarWidget(
        isTimeLine: false,
        text: 'Activity Feed',
      ),
      body: StreamBuilder(
        stream: _model.feedsStream,
        builder: (context, AsyncSnapshot snapshot) {
          List feeds = _model.feeds
              .map((doc) => ActivityFeed.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) => ActivityFeedItemWidget(
              feed: feeds[index],
            ),
          );
        },
      ),
    );
  }
}
