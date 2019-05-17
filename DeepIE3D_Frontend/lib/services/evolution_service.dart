import 'dart:html';

import 'package:deep_ie_3d/misc/evolution_chip.dart';

class EvolutionService {
  /// Gets a specified Z from the session storage of the browser
  List<double> _getZ(int i) {
    String Z = window.sessionStorage["z${i}"];
    List<double> doubleZ = List();
    for (String s in Z.substring(1, Z.length - 1).split(", ")) {
      doubleZ.add(double.parse(s));
    }
    return doubleZ;
  }

  // Gets all Zs in session storage
  List<List<double>> getZs() {
    return List.generate(9, (int i) => _getZ(i));
  }

  /// Adds an evolution to be used in the next iteration
  ///
  /// Will try to replace a "new" evolution if possible, else
  /// it defaults to replace the last added evolution.
  Future<void> addEvolution(
      String evolutionType,
      List<int> ids,
      List<EvolutionChip> evolutionChips,
      Map<int, List<EvolutionChip>> canvasEvolutions) async {
    int newIndex = evolutionChips.indexWhere(
        (EvolutionChip chip) => chip.evolutionType == EvolutionType.New);

    EvolutionChip toBeRemoved =
        newIndex != -1 ? evolutionChips[newIndex] : evolutionChips[0];

    EvolutionChip toBeAdded = evolutionType == "mutate"
        ? EvolutionChip(EvolutionType.Mutate, ids)
        : evolutionType == "keep"
            ? EvolutionChip(EvolutionType.Keep, ids)
            : EvolutionChip(EvolutionType.Crossover, ids);

    evolutionChips.remove(toBeRemoved);
    evolutionChips.add(toBeAdded);
    for (int id in toBeRemoved.ids) {
      canvasEvolutions[id].remove(toBeRemoved);
    }
    for (int id in toBeAdded.ids) {
      canvasEvolutions[id].add(toBeAdded);
    }
  }

  /// Removes an evolution to be used in the next iteration
  ///
  /// The removed evolution will always be replaced by a "new" evolution
  Future<void> removeEvolution(
      EvolutionChip evolutionChip,
      List<EvolutionChip> evolutionChips,
      Map<int, List<EvolutionChip>> canvasEvolutions) async {
    evolutionChips.remove(evolutionChip);
    for (int id in evolutionChip.ids) {
      canvasEvolutions[id].remove(evolutionChip);
    }
    evolutionChips.add(EvolutionChip(EvolutionType.New, []));
  }

  /// Initialize evolutions to be used in the next iteration (all new)
  Future<void> initEvolutions(List<EvolutionChip> evolutionChips,
      Map<int, List<EvolutionChip>> canvasEvolutions) async {
    for (int i = 0; i < 9; i++) {
      EvolutionChip toBeAdded = EvolutionChip(EvolutionType.New, []);
      canvasEvolutions[i] = List();
      evolutionChips.add(toBeAdded);
      for (int id in toBeAdded.ids) {
        canvasEvolutions[id].add(toBeAdded);
      }
    }
  }

  /// Creates an evolution specification
  ///
  /// This is sent to the server to perform the desired evolutions
  String createEvolutionSpecifications(List<EvolutionChip> evolutionChips,
      List<int> selectedCanvases, bool advancedMode) {
    StringBuffer evolutionSpecifications = StringBuffer();

    if (!advancedMode) {
      return "SIMPLE";
    }

    for (EvolutionChip ec in evolutionChips) {
      String evolutionTypeString = ec.getEvolutionTypeString();
      switch (evolutionTypeString) {
        case "Mutate":
          evolutionSpecifications.write("M[${ec.ids[0]}]");
          break;
        case "Crossover":
          evolutionSpecifications.write("C[${ec.ids[0]}][${ec.ids[1]}]");
          break;
        case "Keep":
          evolutionSpecifications.write("K[${ec.ids[0]}]");
          break;
        case "New":
          evolutionSpecifications.write("N");
          break;
        default:
      }
      evolutionSpecifications.write(",");
    }
    String evolutionSpecificationString = evolutionSpecifications.toString();

    return evolutionSpecificationString.substring(
        0, evolutionSpecificationString.length - 1);
  }
}
