import 'package:angular/angular.dart';

/// A spinner appearing everytime data is fetched from server
@Component(
  selector: 'app-spinner',
  templateUrl: 'spinner_component.html',
  directives: [NgIf],
  styleUrls: ['spinner_component.scss.css'],
)
class SpinnerComponent {
  bool _isLoading;
  @Input()
  set isLoading(bool value) => _isLoading = value;
  get isLoading => _isLoading;
  String _message;
  @Input()
  set message(String value) => _message = value;
  get message => _message;

  SpinnerComponent();
}
