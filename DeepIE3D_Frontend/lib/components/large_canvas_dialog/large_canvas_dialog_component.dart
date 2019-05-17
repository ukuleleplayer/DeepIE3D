import 'package:angular/angular.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:deep_ie_3d/services/core_service.dart';
import 'package:pedantic/pedantic.dart';

/// A dialog showing a large version of a canvas
@Component(
  selector: 'large-canvas-dialog',
  providers: [overlayBindings],
  directives: [
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
  ],
  templateUrl: 'large_canvas_dialog_component.html',
  styleUrls: ['large_canvas_dialog_component.scss.css'],
)
class LargeCanvasDialogComponent {
  final CoreService coreService;
  bool isOpen = false;

  int _canvasId;
  @Input()
  set canvasId(int value) => _canvasId = value;
  get canvasId => _canvasId;

  LargeCanvasDialogComponent(this.coreService);

  /// Close the dialog and dispose the rendering engine
  Future<void> closeDialog() async {
    isOpen = false;
    unawaited(coreService.disposeLargeCanvas());
  }

  /// Open the dialog and initialize the rendering engine
  Future<void> openDialog() async {
    isOpen = true;
    unawaited(coreService.initializeLargeCanvas(canvasId));
  }
}
