enum ModelType { Chair, Plane }

String getModelTypeString(ModelType modelType) {
  return modelType.toString().split('.')[1];
}
