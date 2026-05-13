import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_service.dart';

class ShareButtons extends StatefulWidget {
  final String resultBase64;
  final String mimeType;
  final String email;
  final VoidCallback onRegenerate;
  final VoidCallback onScrollToEmail;

  const ShareButtons({
    super.key,
    required this.resultBase64,
    required this.mimeType,
    required this.email,
    required this.onRegenerate,
    required this.onScrollToEmail,
  });

  @override
  State<ShareButtons> createState() => _ShareButtonsState();
}

class _ShareButtonsState extends State<ShareButtons> {
  bool _sendingEmail = false;
  bool _downloading = false;

  bool get _hasValidEmail =>
      widget.email.isNotEmpty && widget.email.contains('@');

  Future<void> _downloadImage(BuildContext context) async {
    setState(() => _downloading = true);
    try {
      final bytes = base64Decode(widget.resultBase64);
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          'icbeu_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imagem salva em $filename'),
            backgroundColor: const Color(0xFF16a34a),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar imagem'),
            backgroundColor: Color(0xFFdc2626),
          ),
        );
      }
    } finally {
      setState(() => _downloading = false);
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      final bytes = base64Decode(widget.resultBase64);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/icbeu_photo_share.jpg');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/jpeg')],
        text: 'Minha foto com tema histórico - ICBEU IA Photo Zone',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao compartilhar imagem'),
            backgroundColor: Color(0xFFdc2626),
          ),
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    if (!_hasValidEmail) {
      widget.onScrollToEmail();
      return;
    }
    setState(() => _sendingEmail = true);
    try {
      await ApiService.sendEmail(
        toEmail: widget.email,
        imageBase64: widget.resultBase64,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E-mail enviado para ${widget.email}!'),
            backgroundColor: const Color(0xFF16a34a),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar e-mail: $e'),
            backgroundColor: const Color(0xFFdc2626),
          ),
        );
      }
    } finally {
      setState(() => _sendingEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.share, color: Color(0xFF7C3AED), size: 20),
                SizedBox(width: 8),
                Text(
                  'Compartilhar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ShareButton(
                    icon: Icons.email_outlined,
                    label: _sendingEmail ? 'Enviando...' : 'E-mail',
                    onTap: _sendingEmail ? null : () => _sendEmail(context),
                    loading: _sendingEmail,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ShareButton(
                    icon: Icons.download_outlined,
                    label: _downloading ? 'Salvando...' : 'Baixar',
                    onTap: _downloading ? null : () => _downloadImage(context),
                    loading: _downloading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ShareButton(
                    icon: Icons.ios_share,
                    label: 'Compartilhar',
                    onTap: () => _shareImage(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ShareButton(
                    icon: Icons.refresh,
                    label: 'Gerar novamente',
                    onTap: widget.onRegenerate,
                    accent: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool accent;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: accent
              ? const Color(0xFF7C3AED).withAlpha(26)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accent
                ? const Color(0xFF7C3AED).withAlpha(77)
                : const Color(0xFF334155),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loading
              ? [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]
              : [
                  Icon(
                    icon,
                    color: accent
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF94A3B8),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: accent
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
