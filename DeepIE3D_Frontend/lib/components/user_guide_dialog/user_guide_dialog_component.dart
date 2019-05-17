import 'package:angular/angular.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_icon/material_icon.dart';

/// A dialog showing a user guide of how to use DeepIE3D
@Component(
  selector: 'user-guide-dialog',
  providers: [overlayBindings],
  directives: [
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
  ],
  templateUrl: 'user_guide_dialog_component.html',
  styleUrls: ['user_guide_dialog_component.scss.css'],
)
class UserGuideDialogComponent {
  bool isOpen = false;

  UserGuideDialogComponent();
}
