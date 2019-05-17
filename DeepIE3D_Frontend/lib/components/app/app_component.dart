import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:html';
import 'package:deep_ie_3d/services/core_service.dart';
import 'package:deep_ie_3d/services/evolution_service.dart';
import 'package:deep_ie_3d/services/http_service.dart';
import 'package:deep_ie_3d/services/webgl_service.dart';
import 'package:deep_ie_3d/components/canvas_grid/canvas_grid_component.dart';
import 'package:deep_ie_3d/components/button_rack/button_rack_component.dart';

/// Root component - contains the button rack and the canvas grid
@Component(
  selector: 'deep-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.scss.css'],
  directives: [
    CanvasGridComponent,
    ButtonRackComponent,
  ],
  providers: [
    ClassProvider(HttpService),
    ClassProvider(CoreService),
    ClassProvider(EvolutionService),
    ClassProvider(WebGLService),
    materialProviders,
  ],
)
class AppComponent implements OnInit {
  @override
  void ngOnInit() {
    MediaQueryList _mqlWidth = window.matchMedia("(min-width: 1300px)");
    MediaQueryList _mqlHeight = window.matchMedia("(min-height: 700px)");
    _mqlWidth.addListener(_onResizeWidth);
    _mqlHeight.addListener(_onResizeHeight);
    if (!_mqlWidth.matches || !_mqlHeight.matches) {
      querySelector("#mobileHide").style.display = "none";
      querySelector("#mobileShow").style.display = "flex";
    } else {
      querySelector("#mobileHide").style.display = "inline";
      querySelector("#mobileShow").style.display = "none";
    }
  }

  void _onResizeWidth(Event mqlEvent) {
    if (!(mqlEvent as MediaQueryListEvent).matches) {
      querySelector("#mobileHide").style.display = "none";
      querySelector("#mobileShow").style.display = "flex";
    } else {
      querySelector("#mobileHide").style.display = "inline";
      querySelector("#mobileShow").style.display = "none";
    }
  }

  void _onResizeHeight(Event mqlEvent) {
    if (!(mqlEvent as MediaQueryListEvent).matches) {
      querySelector("#mobileHide").style.display = "none";
      querySelector("#mobileShow").style.display = "flex";
    } else {
      querySelector("#mobileHide").style.display = "inline";
      querySelector("#mobileShow").style.display = "none";
    }
  }
}
