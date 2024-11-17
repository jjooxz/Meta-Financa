import 'package:flutter/material.dart';
import 'package:meta_financa/const.dart'; // Certifique-se de importar o arquivo const.dart
import 'package:flutter_glow/flutter_glow.dart';

class KBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const KBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenha a cor correta para a barra de navegação dependendo do tema atual
    final navBarColor = Theme.of(context).brightness == Brightness.light
        ? kNavBarColorLight
        : kNavBarColorDark;

    return SafeArea(
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: navBarColor, // Use a cor do tema
          borderRadius: BorderRadius.circular(56),
          boxShadow: [
            BoxShadow(
              color: navBarColor.withOpacity(0.6),
              offset: const Offset(0, 20),
              blurRadius: 40,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              icon: Icons.category_outlined,
              label: 'Categorias',
              isSelected: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),
            _buildNavItem(
              icon: Icons.history_outlined,
              label: 'Histórico',
              isSelected: currentIndex == 1,
              iconOnRight: true,
              onTap: () => onTabSelected(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool iconOnRight = false,
  }) {
    final children = [
      if (!iconOnRight) isSelected ? GlowIcon(icon, size: 32, color: Colors.white, blurRadius: 10,) : Icon(icon, size: 32, color: Colors.white70),
      if (!iconOnRight) const SizedBox(width: 8),
      isSelected ? GlowText(label, blurRadius: 10, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)) : Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
      if (iconOnRight) const SizedBox(width: 8),
      if (iconOnRight) isSelected ? GlowIcon(icon, size: 32, color: Colors.white, blurRadius: 10,) : Icon(icon, size: 32, color: Colors.white70),
    ];

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
