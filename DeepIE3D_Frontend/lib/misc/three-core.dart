@JS()
library three_core;

import "package:js/js.dart";
import "dart:html" show CanvasElement, HtmlElement;
import "dart:web_gl" show RenderingContext;

@JS("THREE.DoubleSide")
external num get DoubleSide;

@JS("THREE.Camera")
class Camera extends Object3D {
  Camera.fakeConstructor$() : super.fakeConstructor$();
}

@JS("THREE.PerspectiveCamera")
class PerspectiveCamera extends Camera {
  PerspectiveCamera.fakeConstructor$() : super.fakeConstructor$();
  external factory PerspectiveCamera([num fov, num aspect, num near, num far]);
  external num get aspect;
  external set aspect(num v);
  external void updateProjectionMatrix();
}

@JS()
class EventDispatcher {
  EventDispatcher.fakeConstructor$();
  external factory EventDispatcher();
}

@JS("THREE.Face3")
class Face3 {
  Face3.fakeConstructor$();
  external factory Face3(num a, num b, num c,
      [dynamic normal_vertexNormals,
      dynamic color_vertexColors,
      num materialIndex]);
  external num get a;
  external set a(num v);

  /// Vertex B index.
  external num get b;
  external set b(num v);

  /// Vertex C index.
  external num get c;
  external set c(num v);

  /// Face normal.
  external Vector3 get normal;
  external set normal(Vector3 v);
}

@JS("THREE.Geometry")
class Geometry extends EventDispatcher {
  Geometry.fakeConstructor$() : super.fakeConstructor$();
  external factory Geometry();

  external List<Vector3> get vertices;
  external set vertices(List<Vector3> v);

  external List<Face3> get faces;
  external set faces(List<Face3> v);
  external void dispose();
}

@JS()
class Object3D extends EventDispatcher {
  Object3D.fakeConstructor$() : super.fakeConstructor$();
  external factory Object3D();

  external Vector3 get position;
  external set position(Vector3 v);
  external void lookAt(dynamic vector, [num y, num z]);

  external Object3D add(
      [Object3D object1,
      Object3D object2,
      Object3D object3,
      Object3D object4,
      Object3D object5]);
  external Object3D remove(
      [Object3D object1,
      Object3D object2,
      Object3D object3,
      Object3D object4,
      Object3D object5]);
  external Object3D clone([bool recursive]);
}

@JS()
class Light extends Object3D {
  Light.fakeConstructor$() : super.fakeConstructor$();
  external factory Light([dynamic hex, num intensity]);
}

@JS("THREE.AmbientLight")
class AmbientLight extends Light {
  AmbientLight.fakeConstructor$() : super.fakeConstructor$();

  external factory AmbientLight([dynamic color, num intensity]);
  external bool get castShadow;
  external set castShadow(bool v);
}

@JS("THREE.PointLight")
class PointLight extends Light {
  PointLight.fakeConstructor$() : super.fakeConstructor$();
  external factory PointLight(
      [dynamic color, num intensity, num distance, num decay]);
}

@anonymous
@JS("THREE.MaterialParameters")
abstract class MaterialParameters {
  external factory MaterialParameters(
      {num alphaTest,
      num blendDst,
      num blendDstAlpha,
      num blendEquation,
      num blendEquationAlpha,
      num blending,
      num blendSrc,
      num blendSrcAlpha,
      bool clipIntersection,
      bool clipShadows,
      bool colorWrite,
      num depthFunc,
      bool depthTest,
      bool depthWrite,
      bool fog,
      bool lights,
      String name,
      num opacity,
      num overdraw,
      bool polygonOffset,
      num polygonOffsetFactor,
      num polygonOffsetUnits,
      String precision,
      bool premultipliedAlpha,
      bool dithering,
      bool flatShading,
      num side,
      bool transparent,
      num vertexColors,
      bool visible});
}

@JS()
class Material extends EventDispatcher {
  Material.fakeConstructor$() : super.fakeConstructor$();
  external factory Material();
  external void dispose();
}

@anonymous
@JS("THREE.MeshLambertMaterialParameters")
abstract class MeshLambertMaterialParameters implements MaterialParameters {
  external factory MeshLambertMaterialParameters(
      {dynamic color,
      dynamic emissive,
      num emissiveIntensity,
      Texture emissiveMap,
      Texture map,
      Texture lightMap,
      num lightMapIntensity,
      Texture aoMap,
      num aoMapIntensity,
      Texture specularMap,
      Texture alphaMap,
      Texture envMap,
      num combine,
      num reflectivity,
      num refractionRatio,
      bool wireframe,
      num wireframeLinewidth,
      String wireframeLinecap,
      String wireframeLinejoin,
      bool skinning,
      bool morphTargets,
      bool morphNormals,
      num alphaTest,
      num blendDst,
      num blendDstAlpha,
      num blendEquation,
      num blendEquationAlpha,
      num blending,
      num blendSrc,
      num blendSrcAlpha,
      bool clipIntersection,
      bool clipShadows,
      bool colorWrite,
      num depthFunc,
      bool depthTest,
      bool depthWrite,
      bool fog,
      bool lights,
      String name,
      num opacity,
      num overdraw,
      bool polygonOffset,
      num polygonOffsetFactor,
      num polygonOffsetUnits,
      String precision,
      bool premultipliedAlpha,
      bool dithering,
      bool flatShading,
      num side,
      bool transparent,
      num vertexColors,
      bool visible});
}

@JS("THREE.MeshLambertMaterial")
class MeshLambertMaterial extends Material {
  MeshLambertMaterial.fakeConstructor$() : super.fakeConstructor$();
  external factory MeshLambertMaterial(
      [MeshLambertMaterialParameters parameters]);
}

@anonymous
@JS()
abstract class Vector {}

@JS("THREE.Vector3")
class Vector3 implements Vector {
  Vector3.fakeConstructor$();
  external factory Vector3([num x, num y, num z]);
  external num get x;
  external set x(num v);
  external num get y;
  external set y(num v);
  external num get z;
  external set z(num v);
  external Vector3 setX(num x);
  external Vector3 setY(num y);
  external Vector3 setZ(num z);
}

@JS("THREE.Mesh")
class Mesh extends Object3D {
  Mesh.fakeConstructor$() : super.fakeConstructor$();
  external factory Mesh([dynamic geometry, dynamic material]);
  external Geometry get geometry;
  external set geometry(Geometry v);
  external MeshLambertMaterial get material;
  external set material(MeshLambertMaterial v);
}

@anonymous
@JS()
abstract class Renderer {
  external CanvasElement get domElement;
  external set domElement(CanvasElement v);
  external void render(Scene scene, Camera camera);
  external void setSize(num width, num height, [bool updateStyle]);
  external void dispose();
}

@anonymous
@JS()
abstract class WebGLRendererParameters {
  external factory WebGLRendererParameters(
      {CanvasElement canvas,
      RenderingContext context,
      String precision,
      bool alpha,
      bool premultipliedAlpha,
      bool antialias,
      bool stencil,
      bool preserveDrawingBuffer,
      String powerPreference,
      bool depth,
      bool logarithmicDepthBuffer});
}

@JS("THREE.WebGLRenderer")
class WebGLRenderer implements Renderer {
  WebGLRenderer.fakeConstructor$();
  external factory WebGLRenderer([WebGLRendererParameters parameters]);
  external void setSize(num width, num height, [bool updateStyle]);
  external void setClearColor(dynamic /*Color|String|num*/ color, [num alpha]);
  external void dispose();
  external CanvasElement get domElement;
  external set domElement(CanvasElement v);
  external void render(Scene scene, Camera camera,
      [dynamic renderTarget, bool forceClear]);
  external WebGLRenderLists get renderLists;
  external set renderLists(WebGLRenderLists v);
  external void setViewport([num x, num y, num width, num height]);
}

@JS()
class WebGLRenderLists {
  WebGLRenderLists.fakeConstructor$();
  external void dispose();
}

@JS("THREE.Scene")
class Scene extends Object3D {
  Scene.fakeConstructor$() : super.fakeConstructor$();
  external factory Scene();
}

@JS()
class Texture extends EventDispatcher {
  Texture.fakeConstructor$() : super.fakeConstructor$();
  external factory Texture(
      [dynamic image,
      num mapping,
      num wrapS,
      num wrapT,
      num magFilter,
      num minFilter,
      num format,
      num type,
      num anisotropy,
      num encoding]);
}

@JS("THREE.OrbitControls")
class OrbitControls {
  OrbitControls.fakeConstructor$();
  external factory OrbitControls(Camera object, [HtmlElement domElement]);
  external Vector3 get target;
  external set target(Vector3 v);

  external num get minDistance;
  external set minDistance(num v);
  external num get maxDistance;
  external set maxDistance(num v);
  external num get rotateSpeed;
  external set rotateSpeed(num v);

  external void dispose();
}
