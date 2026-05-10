import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool canProcess;
  final bool isProcessing;
  final VoidCallback onProcess;
  final VoidCallback onClear;

  const ActionButtons({
    super.key,
    required this.canProcess,
    required this.isProcessing,
    required this.onProcess,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Process button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: (canProcess && !isProcessing)
                  ? const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    )
                  : null,
              color: (canProcess && !isProcessing) ? null : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: (canProcess && !isProcessing) ? onProcess : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isProcessing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Processando...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: canProcess ? Colors.white : const Color(0xFF475569),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Processar com IA',
                          style: TextStyle(
                            color: canProcess ? Colors.white : const Color(0xFF475569),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Clear button
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: isProcessing ? null : onClear,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF334155)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: isProcessing ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Limpar tudo',
                  style: TextStyle(
                    color: isProcessing ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
