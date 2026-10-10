import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/search/search_page.dart';
import 'package:flutter/material.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Material(
        color: const Color(0xFFF8F8F8),
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          ),
          customBorder: const StadiumBorder(),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE7E7E7), width: 1.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.grey, size: 25),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Cari makanan, kandang, mainan...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey, fontSize: 15),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.tune, color: AppColors.grey, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
