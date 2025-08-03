import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:fractal/index.dart';
import 'package:http/http.dart' as http;

Future<Object?> ai(MP m, FSocketAPI s) async {
  const String apiKey = 'sk-0364a70b5b414068bac27cda56038a21';
  const String apiBaseUrl = 'https://api.deepseek.com/v1';

  final body = {
    for (var key in ['model', 'max_tokens', 'messages', 'tools'])
      if (m[key] case Object ob) key: ob,
  };
  body['stream'] = true;
  final String deepSeekEndpointPath = '/chat/completions';
  final String deepSeekUrl = '$apiBaseUrl$deepSeekEndpointPath';

  int streamKey = m['stream'];
  sink(MP m) {
    s.sink({
      ...m,
      'sb': streamKey,
    });
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
    'Accept': 'text/event-stream',
    'Connection': 'keep-alive',
    'Cache-Control': 'no-cache',
  };

  final client = http.Client();
  http.StreamedResponse res;

  try {
    final rq = http.Request('POST', Uri.parse(deepSeekUrl));
    rq.headers.addAll(headers);
    rq.body = json.encode(body);

    res = await client.send(rq);

    if (res.statusCode != HttpStatus.ok) {
      final errorBody = await res.stream.bytesToString();
      sink({
        'error': 'AI API Error',
        'status': res.statusCode,
        'details': errorBody
      });
      client.close();
      return null;
    }

    await for (var dataChunk in res.stream) {
      final String chunkString = utf8.decode(dataChunk);
      final lines = chunkString.split('\n');

      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') {
            sink({'status': 'DONE'});
            break;
          }
          if (data.isNotEmpty) {
            try {
              final Map<String, dynamic> jsonObject = json.decode(data);
              final List<dynamic>? choices = jsonObject['choices'];

              if (choices != null && choices.isNotEmpty) {
                final Map<String, dynamic>? delta = choices[0]['delta'];
                final String? finishReason = choices[0]['finish_reason'];

                if (delta != null) {
                  if (delta['content'] case Object o) {
                    sink({'content': o});
                  } else if (delta['reasoning_content'] case String txt) {
                    sink({'reason': txt});
                  }
                  if (delta.containsKey('tool_calls')) {
                    sink({'tool_calls': delta['tool_calls']});
                  }
                }
                if (finishReason != null) {
                  sink({'finish_reason': finishReason});
                }
              }
            } catch (e) {
              print('Error parsing JSON from AI stream: $e, Data: $data');
              sink({
                'error': 'JSON parsing error',
                'details': e.toString(),
                'raw_data': data
              });
            }
          }
        }
      }
    }
    client.close();
  } catch (e) {
    s.sink({'error': 'Proxy processing error', 'details': e.toString()});
    client.close();
  }
  return null;
}
