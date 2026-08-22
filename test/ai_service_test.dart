import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tryit/models/chat_message.dart';
import 'package:tryit/services/ai_service.dart';

void main() {
  test('sends only user and assistant messages accepted by the proxy', () async {
    late Map<String, Object?> requestBody;
    final service = AiService(
      client: MockClient((request) async {
        requestBody = jsonDecode(request.body) as Map<String, Object?>;
        return http.Response.bytes(
          utf8.encode(jsonEncode({'content': 'تحدٍّ صغير'})),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    final response = await service.reply([
      ChatMessage(
        id: '1',
        text: 'علّمني الرسم',
        isUser: true,
        createdAt: DateTime(2026),
      ),
    ]);

    expect(response, 'تحدٍّ صغير');
    expect(requestBody.keys, ['messages']);
    final messages = requestBody['messages']! as List<Object?>;
    expect(messages, hasLength(1));
    expect((messages.single! as Map<String, Object?>)['role'], 'user');
  });

  test('maps rate limiting to a recoverable AI failure', () async {
    final service = AiService(
      client: MockClient((_) async => http.Response('{}', 429)),
    );

    expect(
      () => service.reply([
        ChatMessage(
          id: '1',
          text: 'ابدأ',
          isUser: true,
          createdAt: DateTime(2026),
        ),
      ]),
      throwsA(
        isA<AiException>().having(
          (error) => error.failure,
          'failure',
          AiFailure.rateLimited,
        ),
      ),
    );
  });
}
