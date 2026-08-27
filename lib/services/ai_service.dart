import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app/app_config.dart';
import '../models/chat_message.dart';

enum AiFailure { offline, timeout, rateLimited, malformed, server }

class AiException implements Exception {
  const AiException(this.failure);
  final AiFailure failure;
}

class AiService {
  AiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> reply(List<ChatMessage> history) async {
    final uri = Uri.parse(AppConfig.groqDirectUrl);
    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConfig.groqApiKey}',
            },
            body: jsonEncode({
              'model': AppConfig.groqModel,
              'messages': [
                ...history
                    .take(12)
                    .map(
                      (message) => {
                        'role': message.isUser ? 'user' : 'assistant',
                        'content': message.text,
                      },
                    ),
              ],
            }),
          )
          .timeout(const Duration(seconds: 25));
      if (response.statusCode == 429) {
        throw const AiException(AiFailure.rateLimited);
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const AiException(AiFailure.server);
      }
      final body = jsonDecode(response.body);
      final text = _extractText(body);
      if (text == null || text.trim().isEmpty) {
        throw const AiException(AiFailure.malformed);
      }
      return text.trim();
    } on TimeoutException {
      throw const AiException(AiFailure.timeout);
    } on SocketException {
      throw const AiException(AiFailure.offline);
    } on http.ClientException {
      throw const AiException(AiFailure.offline);
    } on FormatException {
      throw const AiException(AiFailure.malformed);
    }
  }

  String? _extractText(Object? body) {
    if (body is! Map<String, Object?>) return null;
    final direct = body['content'] ?? body['message'] ?? body['response'];
    if (direct is String) return direct;
    final choices = body['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;
      if (first is Map) {
        final message = first['message'];
        if (message is Map && message['content'] is String) {
          return message['content'] as String;
        }
        if (first['text'] is String) return first['text'] as String;
      }
    }
    return null;
  }
}
