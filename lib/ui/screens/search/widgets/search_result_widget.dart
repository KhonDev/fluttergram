import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/search/search_view_model.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<SearchViewModel>();
    return SizedBox(
      width: double.infinity,
      child: _model.isLoading
          ? const LoadingWidget()
          : ListView.builder(
              itemCount: _model.usersList.length,
              itemBuilder: (context, index) {
                final user = _model.usersList[index];
                return UserResultWidget(user: user);
              },
            ),
    );
  }
}
