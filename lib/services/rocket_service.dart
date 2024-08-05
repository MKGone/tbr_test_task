import 'dart:convert';
import 'package:http/http.dart' as http;

class RocketService {
  final String rocketApiUrl = 'https://api.spacexdata.com/v3/rockets';
  final String launchApiUrl = 'https://api.spacexdata.com/v3/launches';

  Future<List<Map<String, String>>> fetchRocketImages() async {
    final response = await http.get(Uri.parse(rocketApiUrl));

    if (response.statusCode == 200) {
      List<dynamic> rockets = json.decode(response.body);
      List<Map<String, String>> rocketImages = rockets.map((rocket) {
        return {
          'rocket_id': rocket['rocket_id'] as String,
          'image_url': rocket['flickr_images'][0] as String,
        };
      }).toList();
      return rocketImages;
    } else {
      throw Exception('Failed to load rockets');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLaunches(String rocketId) async {
    final response = await http.get(Uri.parse(launchApiUrl));

    if (response.statusCode == 200) {
      List<dynamic> launches = json.decode(response.body);
      List<Map<String, dynamic>> filteredLaunches = launches
          .where((launch) => launch['rocket']['rocket_id'] == rocketId)
          .map((launch) => {
                'date': launch['launch_date_utc'],
                'name': launch['mission_name'],
                'site': launch['launch_site']['site_name_long'],
                'wiki': launch['links']['wikipedia']
              })
          .toList();
      return filteredLaunches;
    } else {
      throw Exception('Failed to load launches');
    }
  }
}
