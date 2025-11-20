import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:moonforge/core/services/gemini_service.dart';

/// Provider for Gemini AI service
class GeminiProvider extends ChangeNotifier {
  final GeminiService _service;
  bool _isGenerating = false;

  GeminiProvider(this._service);

  /// Whether the service is currently generating content
  bool get isGenerating => _isGenerating;

  /// Get the Gemini service
  GeminiService get service => _service;

  /// Set generating state
  void setGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  /// Initialize Gemini with API key
  static void initialize(String apiKey) {
    Gemini.init(apiKey: apiKey);
  }

  /// Check if Gemini is initialized
  static bool get isInitialized {
    try {
      Gemini.instance;
      return true;
    } catch (e) {
      return false;
    }
  }
}
