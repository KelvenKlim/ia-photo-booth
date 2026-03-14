import 'package:flutter/material.dart';
import '../models/api_models.dart';

class ConfigFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController instructionsController;
  final String selectedTheme;
  final String selectedSize;
  final ValueChanged<String?> onThemeChanged;
  final ValueChanged<String?> onSizeChanged;
  final bool enabled;

  const ConfigFormCard({
    super.key,
    required this.emailController,
    required this.instructionsController,
    required this.selectedTheme,
    required this.selectedSize,
    required this.onThemeChanged,
    required this.onSizeChanged,
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
                Icon(Icons.settings, color: Color(0xFF7C3AED), size: 20),
                SizedBox(width: 8),
                Text(
                  'Configurações',
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
              'E-mail (opcional)',
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

            // Theme
            Text(
              'Tema',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedTheme,
              onChanged: enabled ? onThemeChanged : null,
              dropdownColor: const Color(0xFF1E293B),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: const Color(0xFF94A3B8),
              decoration: inputDecoration.copyWith(
                prefixIcon: const Icon(Icons.palette_outlined, color: Color(0xFF94A3B8), size: 18),
              ),
              items: kThemes
                  .map((t) => DropdownMenuItem(value: t.value, child: Text(t.label)))
                  .toList(),
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
            const SizedBox(height: 16),

            // Size
            Text(
              'Tamanho da imagem',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedSize,
              onChanged: enabled ? onSizeChanged : null,
              dropdownColor: const Color(0xFF1E293B),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: const Color(0xFF94A3B8),
              decoration: inputDecoration.copyWith(
                prefixIcon: const Icon(Icons.aspect_ratio, color: Color(0xFF94A3B8), size: 18),
              ),
              items: kSizes
                  .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
