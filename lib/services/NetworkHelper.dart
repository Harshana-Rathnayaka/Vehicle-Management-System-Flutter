import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class Network {
  final String url = "http://0.0.0.0:8000";

  postData(values, endpoint) async {
    var fullUrl = url + endpoint;

    return await http.post(fullUrl, body: values);
  }

  checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
  }
}
