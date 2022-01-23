import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/search/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchAppBarWidget extends StatefulWidget with PreferredSizeWidget {
  const SearchAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchAppBarWidget> createState() => _SearchAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarWidgetState extends State<SearchAppBarWidget> {
  final _controller = TextEditingController();

  void clearTextField() {
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Search for a user...',
              filled: true,
              isDense: true,
              prefixIcon: const Icon(
                Icons.account_box,
                size: 28.0,
              ),
              suffixIcon: IconButton(
                onPressed: clearTextField,
                icon: const Icon(Icons.clear),
              ),
            ),
            onFieldSubmitted: (query) =>
                context.read<SearchViewModel>().handleSearch(query),
          ),
        ),
      ),
    );
  }
}
