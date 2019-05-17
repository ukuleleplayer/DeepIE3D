import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';

class HttpService {
  final String _SERVER_URL = "http://127.0.0.1:5000";

  /// Queries the server for a single model and its Z vector + camera placement information
  Future<Tuple2<List<List<int>>, List<int>>> initializeSingle(
      int i, String modelType) async {
    Map<String, String> jsonBody = Map();
    jsonBody["model_type"] = modelType;
    window.sessionStorage["model_type"] = modelType;
    Response response = await BrowserClient().post(
      Uri.parse("${_SERVER_URL}/initialize_single/"),
      headers: {"content-type": "application/json"},
      body: json.encode(jsonBody),
    );

    Map<String, dynamic> decoded = json.decode(response.body);

    window.sessionStorage["z${i}"] = decoded["z"].toString();
    List<dynamic> coords = decoded["coords"];
    List<int> camera = List<int>.from(decoded["camera"]);

    List<List<int>> list = List();

    for (int j = 0; j < coords.length; j++) {
      list.add([coords[j][0], coords[j][1], coords[j][2]]);
    }

    return Tuple2<List<List<int>>, List<int>>(list, camera);
  }

  /// Queries the server for a single model using the already stored Z vector
  Future<Tuple2<List<List<int>>, List<int>>> generateSingle(int id) async {
    Map<String, dynamic> jsonBody = Map();
    String Z = window.sessionStorage["z${id}"];
    List<double> doubleZ = List();
    for (String s in Z.substring(1, Z.length - 1).split(", ")) {
      doubleZ.add(double.parse(s));
    }
    jsonBody["z"] = doubleZ;
    jsonBody["model_type"] = window.sessionStorage["model_type"];

    Response response = await BrowserClient().post(
      Uri.parse("${_SERVER_URL}/generate_single/"),
      headers: {"content-type": "application/json"},
      body: json.encode(jsonBody),
    );

    Map<String, dynamic> decoded = json.decode(response.body);
    List<dynamic> coords = decoded["coords"];
    List<int> camera = List<int>.from(decoded["camera"]);

    List<List<int>> list = List();
    for (int i = 0; i < coords.length; i++) {
      list.add([coords[i][0], coords[i][1], coords[i][2]]);
    }

    return Tuple2<List<List<int>>, List<int>>(list, camera);
  }

  /// Evolves all the Z vectors based on the desired evolutions configured by the user if any
  Future<void> evolve(String evolutionSpecifications, List<List<double>> zs,
      List<int> selectedCanvases, bool novelty, double mutationRate) async {
    Map<String, dynamic> jsonBody = Map();

    jsonBody["specifications"] =
        evolutionSpecifications + selectedCanvases.length.toString();
    jsonBody["novelty"] = novelty;
    jsonBody["mutation"] = mutationRate;

    for (int i = 0; i < zs.length; i++) {
      jsonBody["z${i}"] = zs[i];
    }

    for (int i = 0; i < selectedCanvases.length; i++) {
      jsonBody["selected${i}"] = selectedCanvases[i];
    }

    Response response = await BrowserClient().post(
      Uri.parse("${_SERVER_URL}/evolve/"),
      headers: {"content-type": "application/json"},
      body: json.encode(jsonBody),
    );

    Map<String, dynamic> decoded = json.decode(response.body);

    for (int i = 0; i < zs.length; i++) {
      window.sessionStorage["z${i}"] = decoded["z${i}"].toString();
    }
  }

  /// Downloads a desired model as a .binvox file
  Future<void> downloadBinvox(int id, int iteration, String mode) async {
    Map<String, dynamic> jsonBody = Map();
    String Z = window.sessionStorage["z${id}"];
    List<double> doubleZ = List();
    for (String s in Z.substring(1, Z.length - 1).split(", ")) {
      doubleZ.add(double.parse(s));
    }
    jsonBody["z"] = doubleZ;
    jsonBody["model_type"] = window.sessionStorage["model_type"];

    Response response = await BrowserClient().post(
      Uri.parse("${_SERVER_URL}/download_binvox/"),
      headers: {"content-type": "application/json"},
      body: json.encode(jsonBody),
    );

    Blob file = Blob([response.bodyBytes], "binvox");
    AnchorElement downloadLink = AnchorElement(href: Url.createObjectUrl(file));
    downloadLink.download = "model${id}_i=${iteration}_mode=${mode}.binvox";
    MouseEvent event = MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }
}
