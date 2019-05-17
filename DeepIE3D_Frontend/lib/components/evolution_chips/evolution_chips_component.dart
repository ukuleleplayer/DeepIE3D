import 'package:angular/angular.dart';
import 'package:angular_components/material_chips/material_chip.dart';
import 'package:angular_components/material_chips/material_chips.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:deep_ie_3d/misc/evolution_chip.dart';
import 'package:deep_ie_3d/services/core_service.dart';

/// Chips holding information about next evolutionary iteration
@Component(
    selector: 'evolution-chips',
    templateUrl: 'evolution_chips_component.html',
    directives: [
      displayNameRendererDirective,
      MaterialChipComponent,
      MaterialChipsComponent,
      MaterialIconComponent,
      NgFor,
      NgIf,
    ],
    styleUrls: [
      'evolution_chips_component.scss.css'
    ])
class EvolutionChipsComponent {
  final CoreService coreService;

  EvolutionChipsComponent(this.coreService);

  /// An ItemRenderer for an evolution chip
  ///
  /// Displays the evolution type and the evolution subjects involved
  ItemRenderer<EvolutionChip> renderEvolutionChip = (dynamic evolutionChip) {
    String evolutionType = evolutionChip.getEvolutionTypeString();
    switch (evolutionType) {
      case "Keep":
      case "Mutate":
        return "${evolutionType} ${evolutionChip.ids[0] + 1}";
        break;
      case "New":
        return "${evolutionType}";
        break;
      case "Crossover":
        return "${evolutionType} ${evolutionChip.ids[0] + 1} X ${evolutionChip.ids[1] + 1}";
        break;
      default:
        return "";
    }
  };

  /// The evolution type of [evolutionChip]
  String getEvolutionType(EvolutionChip evolutionChip) {
    return evolutionChip.evolutionType.toString().split('.')[1];
  }
}
