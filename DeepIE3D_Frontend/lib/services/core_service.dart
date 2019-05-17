import 'dart:html';
import 'dart:async';
import 'package:angular_components/model/ui/icon.dart';
import 'package:deep_ie_3d/misc/evolution_chip.dart';
import 'package:deep_ie_3d/services/evolution_service.dart';
import 'package:deep_ie_3d/services/http_service.dart';
import 'package:deep_ie_3d/services/webgl_service.dart';
import 'package:pedantic/pedantic.dart';
import 'package:tuple/tuple.dart';

/// Core service for keeping objects and managing dynamic states
class CoreService {
  final HttpService _httpService;
  final WebGLService _webglService;
  final EvolutionService evolutionService;
  final List<EvolutionChip> evolutionChips = [];
  final List<int> selectedCanvases = [];
  final List<Icon> selectedIcons =
      List.generate(9, (_) => Icon("favorite_border"));
  final List<String> selectedColors = List.generate(9, (_) => "black");
  final Map<int, List<EvolutionChip>> canvasEvolutions = Map();
  String message = "INITIALIZING MODELS";
  bool _isLoading = true;
  set isLoading(bool val) => _isLoading = val;
  bool get isLoading => _isLoading;
  bool _advancedMode = false;
  set advancedMode(bool val) => _advancedMode = val;
  bool get advancedMode => _advancedMode;
  bool _novelty = false;
  set novelty(bool val) => _novelty = val;
  bool get novelty => _novelty;
  int iteration = 1;

  CoreService(this._httpService, this._webglService, this.evolutionService) {
    unawaited(
        evolutionService.initEvolutions(evolutionChips, canvasEvolutions));
  }

  /// Button trigger for toggling a canvas in Normal mode
  void toggleCanvas(int i) {
    if (!selectedCanvases.remove(i)) {
      selectedColors[i] = "#009688";
      selectedIcons[i] = Icon("favorite");
      selectedCanvases.add(i);
    } else {
      selectedColors[i] = "black";
      selectedIcons[i] = Icon("favorite_border");
    }
  }

  /// Disposes the large canvas engine when dialog is closed
  Future<void> disposeLargeCanvas() async =>
      unawaited(_webglService.reassembleLargeCanvas());

  /// Initializing the initial view
  ///
  /// Querying the server for each canvas
  Future<void> initializeDeepIE(String modelType, {bool initial = true}) async {
    isLoading = true;
    message = "INITIALIZING MODELS";
    List<CanvasElement> canvases = querySelectorAll("canvas");

    // If this ins't the first time initialized, refresh the canvases
    if (!initial) {
      unawaited(_webglService.reassembleCanvases());
    }

    for (int i = 0; i < 9; i++) {
      Tuple2<List<List<int>>, List<int>> tuple =
          await _httpService.initializeSingle(i, modelType);
      unawaited(_webglService.drawOnCanvas(
          canvases[i], tuple.item1, tuple.item2, false));
    }

    isLoading = false;
  }

  /// Initializing a single canvas
  Future<void> initializeLargeCanvas(int id) async {
    Future<Tuple2<List<List<int>>, List<int>>> futureCoords =
        _httpService.generateSingle(id);
    message = "RENDERING LARGE MODEL";
    isLoading = true;

    CanvasElement canvas = querySelector('#large-canvas-${id}');
    Tuple2<List<List<int>>, List<int>> tuple = await futureCoords;

    unawaited(
        _webglService.drawOnCanvas(canvas, tuple.item1, tuple.item2, true));

    isLoading = false;
  }

  /// Evolves the view
  ///
  /// First, queries the server for evolved Z vectors
  ///
  /// Second, queries the server for each canvas
  Future<void> evolve(double mutationRate) async {
    message = "EVOLUTION INITIALIZED";
    isLoading = true;
    iteration++;

    String evolutionSpecifications =
        evolutionService.createEvolutionSpecifications(
            evolutionChips, selectedCanvases, advancedMode);
    List<List<double>> zs = evolutionService.getZs();
    Future<void> futureEvolution = _httpService.evolve(
        evolutionSpecifications, zs, selectedCanvases, _novelty, mutationRate);

    unawaited(_webglService.reassembleCanvases());
    List<CanvasElement> canvases = querySelectorAll('canvas');
    await futureEvolution;

    for (int i = 0; i < 9; i++) {
      Tuple2<List<List<int>>, List<int>> tuple =
          await _httpService.generateSingle(i);
      unawaited(_webglService.drawOnCanvas(
          canvases[i], tuple.item1, tuple.item2, false));
    }

    evolutionChips.clear();
    canvasEvolutions.clear();
    selectedCanvases.clear();
    selectedColors.fillRange(0, 9, "black");
    selectedIcons.fillRange(0, 9, Icon("favorite_border"));

    unawaited(
        evolutionService.initEvolutions(evolutionChips, canvasEvolutions));

    isLoading = false;
  }

  /// Adds an evolution to be used in the next iteration
  ///
  /// See [EvolutionService] for further documentation
  Future<void> addEvolution(String evolutionType, List<int> ids) async {
    unawaited(evolutionService.addEvolution(
        evolutionType, ids, evolutionChips, canvasEvolutions));
  }

  /// Removes an evolution to be used in the next iteration
  ///
  /// See [EvolutionService] for further documentation
  Future<void> removeEvolution(EvolutionChip evolutionChip) async {
    unawaited(evolutionService.removeEvolution(
        evolutionChip, evolutionChips, canvasEvolutions));
  }

  /// Downloads the desired model as a .binvox file
  Future<void> downloadBinvox(int id) async {
    unawaited(_httpService.downloadBinvox(
        id + 1, iteration, _advancedMode ? "advanced" : "normal"));
  }

  /// Downloads the desired model as a .png file
  Future<void> takeScreenshot(int id) async {
    Blob file = await _webglService.getFrameAsBlob(id);
    AnchorElement downloadLink = AnchorElement(href: Url.createObjectUrl(file));
    downloadLink.download =
        "model${id + 1}_i=${iteration}_mode=${_advancedMode ? "advanced" : "normal"}.png";
    MouseEvent event = MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }

  // Downloads the desired model as an .stl file
  Future<void> downloadSTL(int id) async {
    Blob file = await _webglService.getSTLAsBlob(id);
    AnchorElement downloadLink = AnchorElement(href: Url.createObjectUrl(file));
    downloadLink.download =
        "model${id + 1}_i=${iteration}_mode=${_advancedMode ? "advanced" : "normal"}.stl";
    MouseEvent event = MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }
}
