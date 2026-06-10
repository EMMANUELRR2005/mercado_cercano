import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../domain/entities/user_entity.dart';

/// Barra de navegación inferior según el rol del usuario.
///
/// - Comprador: Inicio / Mapa / Precios / Alertas.
/// - Vendedor: Inicio / Catálogo / Estadísticas / Perfil.
///
/// `badgeCounts` permite mostrar un contador por índice de tab
/// (ej. `{3: 2}` = 2 alertas pendientes en el tab 3).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts,
  });

  final UserRole role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Contadores opcionales por índice de tab.
  final Map<int, int>? badgeCounts;

  static const _buyerTabs = [
    (icon: Icons.home, label: 'Inicio'),
    (icon: Icons.map, label: 'Mapa'),
    (icon: Icons.trending_up, label: 'Precios'),
    (icon: Icons.notifications, label: 'Alertas'),
  ];

  static const _vendorTabs = [
    (icon: Icons.home, label: 'Inicio'),
    (icon: Icons.inventory_2, label: 'Catálogo'),
    (icon: Icons.bar_chart, label: 'Estadísticas'),
    (icon: Icons.person, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final tabs = role == UserRole.buyer ? _buyerTabs : _vendorTabs;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex.clamp(0, tabs.length - 1),
      onTap: onTap,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      items: [
        for (var i = 0; i < tabs.length; i++)
          BottomNavigationBarItem(
            icon: _buildIcon(tabs[i].icon, badgeCounts?[i]),
            label: tabs[i].label,
          ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int? count) {
    if (count == null || count <= 0) return Icon(icon);
    return Badge.count(
      count: count,
      backgroundColor: AppColors.errorRed,
      child: Icon(icon),
    );
  }
}
