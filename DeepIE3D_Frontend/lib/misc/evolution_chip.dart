/// A chip containing information of an evolution to be used in next iteration
class EvolutionChip {
  final EvolutionType evolutionType;
  final List<int> ids;
  const EvolutionChip(this.evolutionType, this.ids);

  /// Returns a beautified string representation of the evolution type
  String getEvolutionTypeString() => evolutionType.toString().split(".")[1];
}

/// Representing the four possible evolution types: Crossover, Keep, Mutate and New
enum EvolutionType { Crossover, Keep, Mutate, New }
