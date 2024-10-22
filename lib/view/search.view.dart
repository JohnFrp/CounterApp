import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              if (_isFocused)
                TextButton(
                  onPressed: () {
                    // Clear search input or perform a cancel action
                    _controller.clear(); // Clear the search field
                    //_focusNode.unfocus(); // Remove focus from the TextField
                  },
                  child: const Text('Cancel'),
                ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ListView.separated(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: const Text(
                    "Tallies",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  tileColor: Colors.blueGrey,
                  onTap: () {
                    Navigator.of(context).pushNamed("tallySet");
                  },
                  leading: const Icon(Icons.star),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
