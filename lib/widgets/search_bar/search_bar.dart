import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_popup.dart';

class SearchIcon extends StatefulWidget {
  final String id;
  final Function(String search) onSearch;

  SearchIcon({
    required this.id,
    required this.onSearch,
  });

  @override
  _SearchIconState createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(SearchPopup(
          id: widget.id,
          onSearch: widget.onSearch,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(Icons.search),
      ),
    );
  }
}
