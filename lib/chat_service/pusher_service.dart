import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  Future<void> init() async {
    try {
      await _pusher.init(
        apiKey: 'f3f7cde24c3519ab0c3e',
        cluster: 'ap2',
      );
      await _pusher.connect();
    } catch (e) {
      print("Error initializing Pusher: $e");
    }
  }

  void subscribe(String channelName, Function(String) onMessageReceived) {
    _pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        onMessageReceived(event.data);
      },
    );
  }

  void unsubscribe(String channelName) {
    _pusher.unsubscribe(channelName: '');
  }

  Future<void> dispose() async {
    await _pusher.disconnect();
  }
}
