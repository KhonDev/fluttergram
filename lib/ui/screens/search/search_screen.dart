import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/search/search_view_model.dart';
import 'package:fluttergram/ui/screens/search/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final _searchResults =
        context.select((SearchViewModel m) => m.searchResults);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.8),
      appBar: const SearchAppBarWidget(),
      body: _searchResults == null
          ? const NoContentWidget()
          : const SearchResultsWidget(),
    );
  }
}
