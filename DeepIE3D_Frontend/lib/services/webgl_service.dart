import 'dart:html';
import 'dart:async';
import 'package:deep_ie_3d/misc/three-core.dart' as THREE;

class WebGLService {
  List<THREE.WebGLRenderer> renderers = List();
  List<THREE.Scene> scenes = List();
  List<THREE.Mesh> meshes = List();
  List<THREE.OrbitControls> controlss = List();
  List<THREE.PerspectiveCamera> cameras = List();
  THREE.WebGLRenderer largeCanvasRenderer;
  THREE.Scene largeCanvasScene;
  THREE.Mesh largeCanvasMesh;
  THREE.OrbitControls largeCanvasControls;
  THREE.PerspectiveCamera largeCanvasCamera;

  /// Draw the given [coords] as voxels on the given [canvas]
  ///
  /// Tries to be as minimal and optimal as possible
  Future<void> drawOnCanvas(CanvasElement canvas, List<List<int>> coords,
      List<int> cameraExtremas, bool largeCanvas) async {
    THREE.WebGLRenderer renderer = THREE.WebGLRenderer(
        THREE.WebGLRendererParameters(
            canvas: canvas, alpha: true, preserveDrawingBuffer: true));
    largeCanvas ? largeCanvasRenderer = renderer : renderers.add(renderer);

    renderer.setSize(canvas.width, canvas.height);
    renderer.setClearColor(0xffffff, 0);

    THREE.Scene scene = THREE.Scene();
    largeCanvas ? largeCanvasScene = scene : scenes.add(scene);

    THREE.PerspectiveCamera camera =
        THREE.PerspectiveCamera(20, canvas.width / canvas.height, 0.1, 1000);
    camera.position.setX(-35 * 2.25);
    camera.position.setY(65 * 2.25);
    camera.position.setZ(-35 * 2.25);

    THREE.OrbitControls controls = THREE.OrbitControls(camera, canvas);
    largeCanvas ? largeCanvasControls = controls : controlss.add(controls);

    camera.lookAt(THREE.Vector3(
        cameraExtremas[3] / 2, cameraExtremas[4] / 2, cameraExtremas[5] / 2));

    controls.target = (THREE.Vector3(
        cameraExtremas[3] / 2, cameraExtremas[4] / 2, cameraExtremas[5] / 2));
    controls.maxDistance = 400;
    controls.minDistance = 10;
    controls.rotateSpeed = 0.5;

    scene.add(THREE.AmbientLight(0x444444));

    THREE.PointLight light1 = THREE.PointLight();
    light1.position.setX(16);
    light1.position.setY(16);
    light1.position.setZ(32);
    scene.add(light1);

    THREE.PointLight light2 = THREE.PointLight();
    light2.position.setX(-16);
    light2.position.setY(-16);
    light2.position.setZ(-32);
    scene.add(light2);
    THREE.AmbientLight light3 = THREE.AmbientLight(0x404040, 0.5);
    scene.add(light3);

    THREE.Geometry geometry = THREE.Geometry();

    int counter = 0;
    for (var coord in coords) {
      counter += 36;

      // X1
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      // X2
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      // Y1
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      // Y2
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      // Z1
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], 1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], 1.0 + coord[2]));
      // Z2
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices
          .add(THREE.Vector3(-1.0 + coord[0], 1.0 + coord[1], -1.0 + coord[2]));
      geometry.vertices.add(
          THREE.Vector3(-1.0 + coord[0], -1.0 + coord[1], -1.0 + coord[2]));

      // Not correct normals, but they work when double sided..
      THREE.Vector3 norm_x1 = THREE.Vector3(0, -1, 0);
      THREE.Vector3 norm_x2 = THREE.Vector3(0, 1, 0);
      THREE.Vector3 norm_y1 = THREE.Vector3(0, 0, -1);
      THREE.Vector3 norm_y2 = THREE.Vector3(0, 0, 1);
      THREE.Vector3 norm_z1 = THREE.Vector3(-1, 0, 0);
      THREE.Vector3 norm_z2 = THREE.Vector3(1, 0, 0);

      // X1
      geometry.faces
          .add(THREE.Face3(counter - 36, counter - 35, counter - 34, norm_x1));
      geometry.faces
          .add(THREE.Face3(counter - 33, counter - 32, counter - 31, norm_x1));
      // X2
      geometry.faces
          .add(THREE.Face3(counter - 30, counter - 29, counter - 28, norm_x2));
      geometry.faces
          .add(THREE.Face3(counter - 27, counter - 26, counter - 25, norm_x2));
      // Y1
      geometry.faces
          .add(THREE.Face3(counter - 24, counter - 23, counter - 22, norm_y1));
      geometry.faces
          .add(THREE.Face3(counter - 21, counter - 20, counter - 19, norm_y1));
      // Y2
      geometry.faces
          .add(THREE.Face3(counter - 18, counter - 17, counter - 16, norm_y2));
      geometry.faces
          .add(THREE.Face3(counter - 15, counter - 14, counter - 13, norm_y2));
      // Z1
      geometry.faces
          .add(THREE.Face3(counter - 12, counter - 11, counter - 10, norm_z1));
      geometry.faces
          .add(THREE.Face3(counter - 9, counter - 8, counter - 7, norm_z1));
      // Z2
      geometry.faces
          .add(THREE.Face3(counter - 6, counter - 5, counter - 4, norm_z2));
      geometry.faces
          .add(THREE.Face3(counter - 3, counter - 2, counter - 1, norm_z2));
    }

    THREE.MeshLambertMaterial material = THREE.MeshLambertMaterial(
        THREE.MeshLambertMaterialParameters(
            color: 0x009688, side: THREE.DoubleSide));
    THREE.Mesh mesh = THREE.Mesh(geometry, material);
    largeCanvas ? largeCanvasMesh = mesh : meshes.add(mesh);
    largeCanvas ? largeCanvasCamera = camera : cameras.add(camera);

    scene.add(mesh);

    renderer.render(scene, camera);

    void animate(num delta) {
      window.animationFrame.then(animate);

      renderer.render(scene, camera);
    }

    animate(1);
  }

  /// Disposes all canvases - used when evolution is initiated
  Future<void> reassembleCanvases() async {
    for (int i = 0; i < 9; i++) {
      renderers[i].renderLists.dispose();
      renderers[i].dispose();
      scenes[i].remove(meshes[i]);
      scenes[i] = null;
      meshes[i].geometry.dispose();
      meshes[i].material.dispose();
      meshes[i] = null;
      controlss[i].dispose();
    }
    renderers = List();
    scenes = List();
    meshes = List();
    controlss = List();
    cameras = List();
  }

  /// Dispose the large canvas - used when a large canvas dialog is closed
  Future<void> reassembleLargeCanvas() async {
    largeCanvasRenderer.renderLists.dispose();
    largeCanvasRenderer.dispose();
    largeCanvasScene.remove(largeCanvasMesh);
    largeCanvasScene = null;
    largeCanvasMesh.geometry.dispose();
    largeCanvasMesh.material.dispose();
    largeCanvasMesh = null;
    largeCanvasControls.dispose();
    largeCanvasCamera = null;
  }

  /// Takes a screenshot of the chosen canvas
  Future<Blob> getFrameAsBlob(int id) async {
    CanvasElement tempCanvas = CanvasElement(width: 900, height: 900);
    THREE.Scene tempScene = scenes[id].clone(true);
    THREE.PerspectiveCamera tempCamera = cameras[id].clone(true);
    THREE.WebGLRenderer tempRenderer = THREE.WebGLRenderer(
        THREE.WebGLRendererParameters(
            canvas: tempCanvas, alpha: true, preserveDrawingBuffer: true));
    tempRenderer.render(tempScene, tempCamera);

    Blob file = await tempRenderer.domElement.toBlob("image/png", 1.0);
    tempRenderer.renderLists.dispose();
    tempRenderer.dispose();
    tempScene = null;
    tempCanvas = null;
    tempCamera = null;

    return file;
  }

  /// Generate an STL file and turn it into a blob
  Future<Blob> getSTLAsBlob(int id) async {
    String stlString = generateSTL(meshes[id].geometry);

    return Blob([stlString], 'text/plain');
  }

  /// Stringify a vertex (its vector)
  String stringifyVertex(vec) {
    return "vertex ${vec.x} ${vec.y} ${vec.z} \n";
  }

  /// Stringify a vector
  String stringifyVector(vec) {
    return "${vec.x} ${vec.y} ${vec.z}";
  }

  /// Given a THREE.Geometry, create an STL string
  String generateSTL(THREE.Geometry geometry) {
    List<THREE.Vector3> vertices = geometry.vertices;
    List<THREE.Face3> faces = geometry.faces;

    String stl = "solid pixel\n";
    for (int i = 0; i < faces.length; i++) {
      stl += ("facet normal ${stringifyVector(faces[i].normal)} \n");
      stl += ("outer loop \n");
      stl += stringifyVertex(vertices[faces[i].a]);
      stl += stringifyVertex(vertices[faces[i].b]);
      stl += stringifyVertex(vertices[faces[i].c]);
      stl += ("endloop \n");
      stl += ("endfacet \n");
    }
    stl += ("endsolid");

    return stl;
  }
}
