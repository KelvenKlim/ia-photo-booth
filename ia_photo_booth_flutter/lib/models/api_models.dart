enum AppState { idle, photoReady, processing, success, error }

class Theme {
  final String value;
  final String label;
  const Theme({required this.value, required this.label});
}

class ImageSize {
  final String value;
  final String label;
  const ImageSize({required this.value, required this.label});
}

const List<Theme> kThemes = [
  Theme(value: 'Hamilton', label: 'Hamilton'),
  Theme(value: 'Colonial American', label: 'Colonial American'),
  Theme(value: 'Historical Portrait', label: 'Historical Portrait'),
  Theme(value: 'Vintage Studio', label: 'Vintage Studio'),
];

const List<ImageSize> kSizes = [
  ImageSize(value: '1024x1024', label: '1024×1024'),
  ImageSize(value: '1536x1024', label: '1536×1024'),
  ImageSize(value: '1024x1536', label: '1024×1536'),
];

class EditImageResponse {
  final String promptUsed;
  final String imageBase64;
  final String mimeType;

  EditImageResponse({
    required this.promptUsed,
    required this.imageBase64,
    required this.mimeType,
  });

  factory EditImageResponse.fromJson(Map<String, dynamic> json) {
    return EditImageResponse(
      promptUsed: json['prompt_used'] as String,
      imageBase64: json['image_base64'] as String,
      mimeType: json['mime_type'] as String,
    );
  }
}
