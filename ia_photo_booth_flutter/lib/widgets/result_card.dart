import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'fullscreen_image_viewer.dart';

class ResultCard extends StatefulWidget {
  final File originalImage;
  final String resultBase64;
  final String promptUsed;

  const ResultCard({
    super.key,
    required this.originalImage,
    required this.resultBase64,
    required this.promptUsed,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool _showPrompt = false;

  @override
  Widget build(BuildContext context) {
    final resultImage = MemoryImage(base64Decode(widget.resultBase64));
    final originalImage = FileImage(widget.originalImage);

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
                Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 20),
                SizedBox(width: 8),
                Text(
                  'Resultado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Images row
            Row(
              children: [
                // Original
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Original',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => showFullscreenImage(
                            context, originalImage, 'original-fullscreen'),
                        child: Hero(
                          tag: 'original-fullscreen',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              widget.originalImage,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              color: Colors.black.withAlpha(51),
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Result
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'IA',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withAlpha(51),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF7C3AED).withAlpha(77),
                              ),
                            ),
                            child: const Text(
                              'NOVO',
                              style: TextStyle(
                                color: Color(0xFF7C3AED),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => showFullscreenImage(
                            context, resultImage, 'result-fullscreen'),
                        child: Hero(
                          tag: 'result-fullscreen',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: resultImage,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Prompt accordion
            GestureDetector(
              onTap: () => setState(() => _showPrompt = !_showPrompt),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Ver prompt utilizado',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ),
                    Icon(
                      _showPrompt ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF94A3B8),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            if (_showPrompt) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Text(
                  widget.promptUsed,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    height: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
