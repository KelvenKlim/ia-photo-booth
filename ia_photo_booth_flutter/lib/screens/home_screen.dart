import 'dart:io';
import 'package:flutter/material.dart';
import '../models/api_models.dart' as models;
import '../services/api_service.dart';
import '../widgets/app_header.dart';
import '../widgets/action_buttons.dart';
import '../widgets/config_form_card.dart';
import '../widgets/image_upload_card.dart';
import '../widgets/processing_overlay.dart';
import '../widgets/result_card.dart';
import '../widgets/share_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _emailController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  final String _selectedTheme = 'Hamilton';
  final String _selectedSize = '1024x1024';
  File? _imageFile;
  models.AppState _appState = models.AppState.idle;
  String? _resultBase64;
  String? _resultMimeType;
  String? _promptUsed;

  bool get _canProcess =>
      _imageFile != null &&
      _emailController.text.contains('@') &&
      _appState != models.AppState.processing;

  bool get _isProcessing => _appState == models.AppState.processing;

  bool get _showResult =>
      _appState == models.AppState.success &&
      _resultBase64 != null &&
      _imageFile != null;

  Future<void> _handleProcess() async {
    if (!_canProcess || _imageFile == null) return;

    setState(() => _appState = models.AppState.processing);

    try {
      final response = await ApiService.editImage(
        image: _imageFile!,
        theme: _selectedTheme,
        extraInstructions: _instructionsController.text,
        size: _selectedSize,
      );
      setState(() {
        _resultBase64 = response.imageBase64;
        _resultMimeType = response.mimeType;
        _promptUsed = response.promptUsed;
        _appState = models.AppState.success;
      });

      // Scroll to result
      await Future.delayed(const Duration(milliseconds: 300));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() => _appState = models.AppState.error);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar imagem: $e'),
            backgroundColor: const Color(0xFFdc2626),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _handleClear() {
    setState(() {
      _imageFile = null;
      _appState = models.AppState.idle;
      _resultBase64 = null;
      _resultMimeType = null;
      _promptUsed = null;
    });
    _emailController.clear();
    _instructionsController.clear();
  }

  void _scrollToEmail() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      _emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _instructionsController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: AppHeader()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ConfigFormCard(
                    emailController: _emailController,
                    instructionsController: _instructionsController,
                    enabled: !_isProcessing,
                  ),
                  const SizedBox(height: 16),
                  ImageUploadCard(
                    imageFile: _imageFile,
                    onImageChanged: (f) {
                      setState(() {
                        _imageFile = f;
                        if (f != null && _appState == models.AppState.idle) {
                          _appState = models.AppState.photoReady;
                        } else if (f == null) {
                          _appState = models.AppState.idle;
                        }
                      });
                    },
                    enabled: !_isProcessing,
                  ),
                  const SizedBox(height: 20),
                  ActionButtons(
                    canProcess: _canProcess,
                    isProcessing: _isProcessing,
                    onProcess: _handleProcess,
                    onClear: _handleClear,
                  ),
                  const SizedBox(height: 16),
                  if (_isProcessing) ...[
                    const ProcessingOverlay(),
                    const SizedBox(height: 16),
                  ],
                  if (_showResult) ...[
                    ResultCard(
                      originalImage: _imageFile!,
                      resultBase64: _resultBase64!,
                      promptUsed: _promptUsed ?? '',
                    ),
                    const SizedBox(height: 16),
                    ShareButtons(
                      resultBase64: _resultBase64!,
                      mimeType: _resultMimeType ?? 'image/jpeg',
                      email: _emailController.text,
                      onRegenerate: _handleProcess,
                      onScrollToEmail: _scrollToEmail,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_appState == models.AppState.error) ...[
                    _ErrorCard(onRetry: _handleProcess),
                    const SizedBox(height: 16),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF7F1D1D)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFef4444), size: 40),
            const SizedBox(height: 12),
            const Text(
              'Ocorreu um erro ao processar a imagem',
              style: TextStyle(color: Color(0xFFef4444), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
