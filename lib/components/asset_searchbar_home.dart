import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class PitboxSearchbar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const PitboxSearchbar({
    Key? key,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari Class Lomba atau Kota',
        prefixIcon: Icon(Icons.search, color: AppColors.primaryText),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
      ),
      onSubmitted: (query) {
        onSearch(query);
      },
    );
  }
}
