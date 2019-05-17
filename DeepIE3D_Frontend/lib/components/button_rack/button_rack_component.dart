import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_slider/material_slider.dart';
import 'package:deep_ie_3d/components/evolution_chips/evolution_chips_component.dart';
import 'package:deep_ie_3d/components/user_guide_dialog/user_guide_dialog_component.dart';
import 'package:deep_ie_3d/misc/model_type.dart';
import 'package:deep_ie_3d/services/core_service.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:pedantic/pedantic.dart';

/// A button rack containing various buttons
@Component(
    selector: 'button-rack',
    templateUrl: 'button_rack_component.html',
    directives: [
      coreDirectives,
      MaterialSliderComponent,
      MaterialFabComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      EvolutionChipsComponent,
      MaterialToggleComponent,
      UserGuideDialogComponent,
      MaterialCheckboxComponent,
    ],
    styleUrls: [
      'button_rack_component.scss.css'
    ])
class ButtonRackComponent {
  final CoreService coreService;
  ButtonRackComponent(this.coreService);
  double mutationRate = 1.00;

  // Beautify mutation rate
  String precisionMutationRate() {
    String returnValue = mutationRate.toStringAsPrecision(2);
    int len = returnValue.length;
    if (len > 4) {
      return returnValue.substring(0, len - 1);
    } else if (len < 4) {
      return returnValue + "0";
    }
    return returnValue;
  }

  ModelType currentModelType = ModelType.Plane;
  String getModelType() => getModelTypeString(currentModelType);

  /// Button trigger for initializing evolution
  Future<void> evolve() async {
    unawaited(coreService.evolve(mutationRate));
  }

  // Show planes or chairs - easily extendable
  Future<void> switchModels() async {
    currentModelType =
        currentModelType == ModelType.Plane ? ModelType.Chair : ModelType.Plane;
    unawaited(coreService.initializeDeepIE(getModelTypeString(currentModelType),
        initial: false));
  }
}
