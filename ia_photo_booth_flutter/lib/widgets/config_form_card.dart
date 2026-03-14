import 'package:flutter/material.dart';

class ConfigFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController instructionsController;
  final bool enabled;

  const ConfigFormCard({
    super.key,
    required this.emailController,
    required this.instructionsController,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      hintStyle: const TextStyle(color: Color(0xFF475569)),
    );

    return Card(
      color: const Color(0xFF0F1729),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.badge_outlined, color: Color(0xFF7C3AED), size: 20),
                SizedBox(width: 8),
                Text(
                  'Dados do Aluno',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            Text(
              'E-mail',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: emailController,
              enabled: enabled,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration.copyWith(
                hintText: 'seu@email.com',
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8), size: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Tema (somente leitura)
            Text(
              'Tema',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withAlpha(128),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined, color: Color(0xFF475569), size: 18),
                  const SizedBox(width: 12),
                  const Text(
                    'Hamilton',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                  ),
                  const Spacer(),
                  const Icon(Icons.lock_outline, color: Color(0xFF475569), size: 16),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Extra instructions
            Text(
              'Instruções extras (opcional)',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: instructionsController,
              enabled: enabled,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration.copyWith(
                hintText: 'Ex: adicione névoa, iluminação dramática...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
