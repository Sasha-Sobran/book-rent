import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/core/get_it.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected && _channel != null) {
      return;
    }

    try {
      final appCubit = GetItService().instance<AppCubit>();
      final token = appCubit.state.token;
      if (token == null) {
        return;
      }

      final appEnv = GetItService().instance<AppEnv>();
      final wsUrl = appEnv.apiUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');
      final uri = Uri.parse('$wsUrl/ws/notifications?token=$token');

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _subscription = _channel!.stream.listen(
        (message) {
          try {
            if (message is String) {
              final data = json.decode(message) as Map<String, dynamic>;
              _messageController.add(data);
            }
          } catch (e) {
            // Ignore invalid messages
          }
        },
        onError: (error) {
          _isConnected = false;
          _reconnect();
        },
        onDone: () {
          _isConnected = false;
          _reconnect();
        },
      );

      _startPingTimer();
    } catch (e) {
      _isConnected = false;
    }
  }

  void _startPingTimer() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add('ping');
        } catch (e) {
          timer.cancel();
          _isConnected = false;
          _reconnect();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

