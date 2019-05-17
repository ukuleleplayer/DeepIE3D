import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:deep_ie_3d/components/large_canvas_dialog/large_canvas_dialog_component.dart';
import 'package:deep_ie_3d/components/menu/menu_component.dart';
import 'package:deep_ie_3d/components/spinner/spinner_component.dart';
import 'package:deep_ie_3d/misc/evolution_chip.dart';
import 'package:deep_ie_3d/services/core_service.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:pedantic/pedantic.dart';

/// A grid containing the canvases used for rendering 3D models
///
/// Also contains the buttons used for operating the canvases
@Component(
  selector: 'canvas-grid',
  templateUrl: 'canvas_grid_component.html',
  directives: [
    SpinnerComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    MenuComponent,
    LargeCanvasDialogComponent,
    NgIf,
    NgFor,
  ],
  styleUrls: ['canvas_grid_component.scss.css'],
)
class CanvasGridComponent implements AfterViewInit {
  final CoreService coreService;
  final List<int> indices = List.generate(9, (int i) => i);

  List<MenuModel<MenuItem>> canvasMenus;
  List<MenuModel<MenuItem>> crossoverMenus;

  // Populate crossover and menu dropdown
  CanvasGridComponent(this.coreService) {
    crossoverMenus = List.generate(
        9,
        (int i) => MenuModel<MenuItem>([
              MenuItemGroup<MenuItem>([
                i + 1 == 1
                    ? MenuItem("-")
                    : MenuItem("1", action: () => crossover(i, 0)),
                i + 1 == 2
                    ? MenuItem("-")
                    : MenuItem("2", action: () => crossover(i, 1)),
                i + 1 == 3
                    ? MenuItem("-")
                    : MenuItem("3", action: () => crossover(i, 2)),
                i + 1 == 4
                    ? MenuItem("-")
                    : MenuItem("4", action: () => crossover(i, 3)),
                i + 1 == 5
                    ? MenuItem("-")
                    : MenuItem("5", action: () => crossover(i, 4)),
                i + 1 == 6
                    ? MenuItem("-")
                    : MenuItem("6", action: () => crossover(i, 5)),
                i + 1 == 7
                    ? MenuItem("-")
                    : MenuItem("7", action: () => crossover(i, 6)),
                i + 1 == 8
                    ? MenuItem("-")
                    : MenuItem("8", action: () => crossover(i, 7)),
                i + 1 == 9
                    ? MenuItem("-")
                    : MenuItem("9", action: () => crossover(i, 8)),
              ])
            ], icon: Icon('shuffle')));
    canvasMenus = List.generate(
        9,
        (int i) => MenuModel<MenuItem>([
              MenuItemGroup<MenuItem>([
                MenuItem("Download .binvox file (view locally)",
                    action: () => downloadBinvox(i)),
                MenuItem("Download .stl file (3D printing/Minecraft)",
                    action: () => downloadSTL(i)),
                MenuItem("Download .png file (take a picture)",
                    action: () => takeScreenshot(i)),
              ])
            ], icon: Icon('menu')));
  }

  @override
  Future<void> ngAfterViewInit() async {
    unawaited(coreService.initializeDeepIE("Plane"));
  }

  /// Button trigger for downloading canvas [id] as a .binvox file
  Future<void> downloadBinvox(int id) async {
    unawaited(coreService.downloadBinvox(id));
  }

  /// Button trigger for downloading canvas [id] as an .stl file
  Future<void> downloadSTL(int id) async {
    unawaited(coreService.downloadSTL(id));
  }

  /// Button trigger for taking a screenshot of canvas [id]
  Future<void> takeScreenshot(int id) async {
    unawaited(coreService.takeScreenshot(id));
  }

  /// Button trigger for keeping a canvas, [id], in next evolution
  Future<void> keep(int id) async {
    unawaited(coreService.addEvolution("keep", [id]));
  }

  /// Button trigger for mutating two canvas, [id1] & [id2], in next evolution
  Future<void> crossover(int id1, int id2) async {
    unawaited(coreService.addEvolution("crossover", [id1, id2]));
  }

  /// Button trigger for mutating a canvas, [id], in next evolution
  Future<void> mutate(int id) async {
    unawaited(coreService.addEvolution("mutate", [id]));
  }

  /// Determines which icon to show based on the evolution type a canvas is involved in
  Icon determineIcon(EvolutionChip evolutionChip) {
    String evolutionTypeString = evolutionChip.getEvolutionTypeString();

    switch (evolutionTypeString) {
      case "Keep":
        return Icon("lock");
        break;
      case "Mutate":
        return Icon("tune");
        break;
      case "Crossover":
        return Icon("shuffle");
        break;
      default:
        return Icon("fiber_new");
    }
  }
}
