import 'package:http/http.dart' as http;
import 'package:machintest/track_online_users.dart';

class Repo{
  Future<TrackOnlineUsers> fetchApi(String link) async {
    var response = await http.get(
      Uri.parse(link),
      headers: {},
    );
    return trackOnlineUsersFromJson(response.body);
  }
}