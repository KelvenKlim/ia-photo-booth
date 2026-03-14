import 'dart:async';
import 'package:flutter/material.dart';

class ProcessingOverlay extends StatefulWidget {
  const ProcessingOverlay({super.key});

  @override
  State<ProcessingOverlay> createState() => _ProcessingOverlayState();
}

class _ProcessingOverlayState extends State<ProcessingOverlay>
    with SingleTickerProviderStateMixin {
  static const _messages = [
    'Analisando sua foto...',
    'Aplicando o estilo histórico...',
    'Recriando os personagens...',
    'Ajustando detalhes faciais...',
    'Finalizando a obra de arte...',
    'Quase lá! Revisando qualidade...',
  ];

  int _messageIndex = 0;
  double _progress = 0.0;
  Timer? _messageTimer;
  Timer? _progressTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted && _progress < 0.95) {
        setState(() {
          final increment = (0.05 + (0.1 * (1 - _progress)));
          _progress = (_progress + increment).clamp(0.0, 0.95);
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0F1729),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF7C3AED), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            FadeTransition(
              opacity: _pulseAnimation,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withAlpha(77),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'IA está trabalhando na sua foto...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _messages[_messageIndex],
              style: TextStyle(
                color: const Color(0xFF7C3AED).withAlpha(204),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(_progress * 100).round()}%',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Este processo pode levar alguns segundos',
              style: TextStyle(
                color: const Color(0xFF94A3B8).withAlpha(128),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
