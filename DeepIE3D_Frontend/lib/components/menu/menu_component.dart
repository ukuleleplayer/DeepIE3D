import 'package:angular/angular.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/model/menu/menu.dart';

/// A popup menu which is triggered on an icon
@Component(
  selector: 'popup-menu',
  providers: [popupBindings],
  directives: [
    MaterialMenuComponent,
  ],
  templateUrl: 'menu_component.html',
)
class MenuComponent {
  MenuModel<MenuItem> _menuGroup;

  @Input()
  set menuGroup(MenuModel<MenuItem> val) => _menuGroup = val;
  get menuGroup => _menuGroup;
}
