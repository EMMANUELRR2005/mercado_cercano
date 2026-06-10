import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';

/// Barra de vigencia de un producto publicado (24 h de vida).
///
/// - Verde: quedan más de 6 h.
/// - Ámbar: entre 2 y 6 h.
/// - Rojo: menos de 2 h (y parpadea si quedan menos de 30 min).
///
/// Se refresca solo cada minuto con un [Timer.periodic].
class ProductExpiryStepper extends StatefulWidget {
  const ProductExpiryStepper({super.key, required this.expiresAt});

  final DateTime expiresAt;

  @override
  State<ProductExpiryStepper> createState() => _ProductExpiryStepperState();
}

class _ProductExpiryStepperState extends State<ProductExpiryStepper>
    with SingleTickerProviderStateMixin {
  static const _totalDuration =
      Duration(hours: AppConstants.productExpiryHours);

  Timer? _ticker;
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0.35,
      upperBound: 1.0,
    );
    // Refrescar la barra y el texto cada minuto.
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
    _syncBlink();
  }

  @override
  void didUpdateWidget(ProductExpiryStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiresAt != widget.expiresAt) _syncBlink();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  Duration get _remaining {
    final diff = widget.expiresAt.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Activa el parpadeo solo cuando quedan menos de 30 minutos.
  void _syncBlink() {
    final critical =
        _remaining > Duration.zero && _remaining.inMinutes < 30;
    if (critical && !_blinkController.isAnimating) {
      _blinkController.repeat(reverse: true);
    } else if (!critical && _blinkController.isAnimating) {
      _blinkController.stop();
      _blinkController.value = 1.0;
    }
  }

  Color get _barColor {
    final remaining = _remaining;
    if (remaining.inHours >= 6) return AppColors.successGreen;
    if (remaining.inHours >= 2) return AppColors.accentAmber;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    _syncBlink();
    final remaining = _remaining;
    final progress =
        (remaining.inSeconds / _totalDuration.inSeconds).clamp(0.0, 1.0);
    final color = _barColor;

    return FadeTransition(
      opacity: _blinkController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                Formatters.formatExpiryCountdown(widget.expiresAt),
                style: AppTextStyles.labelMedium.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
