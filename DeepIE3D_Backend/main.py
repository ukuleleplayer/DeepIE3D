from flask import Flask, jsonify, request, send_file
from flask_compress import Compress
from torch import Tensor
from generate import SuperGenerator
from utils import generate_z, create_coords_from_voxels, generate_binvox_file, calculate_camera
from evolution import mutate, crossover, simple_evolution, behavioral_novelty_search, novelty_search


# Constants
COMPRESS = Compress()
BEHAVIORAL = False
APP = Flask(__name__)
G = SuperGenerator()
CAMERA_PLANE = calculate_camera(
    [G.generate(generate_z(), 'Plane') for i in range(100)])
CAMERA_CHAIR = calculate_camera(
    [G.generate(generate_z(), 'Chair') for i in range(100)])


@APP.after_request
def add_cors(response):
    '''
    Add CORS header(s) to every response from valid sites

    Allow:
    - Origin from everywhere
    - Content-Type to be shown in headers
    - GET, POST and OPTIONS methos
    '''
    r = request.referrer[:-1]
    if r in ['http://localhost:8080', 'localhost:8080', 'https://localhost:8080',
             'https://adrianwesth.dk', 'https://www.adrianwesth.dk']:
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add('Access-Control-Allow-Headers',
                             'Content-Type,Authorization')
        response.headers.add('Access-Control-Allow-Methods',
                             'GET,POST,OPTIONS')

    return response


@APP.route('/initialize_single/', methods=['POST', 'OPTION'])
def initialize_single():
    '''
    Initialize the view:

    Respond with coords of nonzeros, Z vector and camera placement information
    '''
    model_type = request.get_json()['model_type']
    body = {}
    z = generate_z()
    voxels = G.generate(z, model_type)
    coords = create_coords_from_voxels(voxels)
    body['z'] = z.tolist()
    body['coords'] = coords
    body['camera'] = CAMERA_PLANE if model_type == 'Plane' else CAMERA_CHAIR

    return jsonify(body)


@APP.route('/generate_single/', methods=['POST', 'OPTION'])
def generate_single():
    '''
    Generate a single view:

    Respond with coords of nonzeros and camera placement information
    '''
    body = {}
    model_type = request.get_json()['model_type']
    z = request.get_json()['z']
    voxels = G.generate(Tensor(z), model_type)
    coords = create_coords_from_voxels(voxels)
    body['coords'] = coords
    body['camera'] = CAMERA_PLANE if model_type == 'Plane' else CAMERA_CHAIR

    return jsonify(body)


@APP.route('/download_binvox/', methods=['POST', 'OPTION'])
def download_binvox():
    '''
    Download a binvox file

    Sends file as octet-stream
    '''
    z = request.get_json()['z']
    model_type = request.get_json()['model_type']
    voxels = G.generate(Tensor(z), model_type)
    binvox = generate_binvox_file(voxels)

    return send_file(binvox, mimetype='application/octet-stream')


@APP.route('/evolve/', methods=['POST', 'OPTION'])
def evolve():
    '''
    Evolve the view using the requested evolutions:

    If the evolution is specified as simple, use an 1:1
    implementation of the original DeepIE

    Else, evolve based on the desired, user specification

    Some sort of novelty search is performed if novelty=True
    Behaviorla novelty search can be toggle in Constants, but is very slow

    The response is 9 Z vectors
    '''
    evolved, body = [], {}
    request_json = request.get_json()
    evolution_specifications = request_json['specifications']
    novelty = request_json['novelty']
    mutation_rate = request_json['mutation']

    if 'SIMPLE' in evolution_specifications:
        selected_canvases = []
        for i in range(int(evolution_specifications[6])):
            selected_canvases.append(request_json[f'selected{i}'])
        zs = [request_json[f'z{i}'] for i in range(9)]
        evolved = simple_evolution(
            selected_canvases, zs, G, novelty, BEHAVIORAL, mutation_rate)
    else:
        evolution_specifications = evolution_specifications.split(',')
        for specification in evolution_specifications:
            if specification[0] == 'M':
                evolved.append(
                    mutate(request_json[f'z{specification[2]}'], mutation_rate))
            elif specification[0] == 'K':
                evolved.append(request_json[f'z{specification[2]}'])
            elif specification[0] == 'N' and not novelty:
                evolved.append(generate_z().tolist())
            elif specification[0] == 'C':
                evolved.append(crossover(
                    request_json[f'z{specification[2]}'], request_json[f'z{specification[5]}']))

        if novelty:
            evolved = behavioral_novelty_search(
                evolved, G) if BEHAVIORAL else novelty_search(evolved)

    for i in range(len(evolved)):
        body[f'z{i}'] = evolved[i]

    return jsonify(body)


# Start the flask loop
if __name__ == '__main__':
    COMPRESS.init_app(APP)
    APP.run(threaded=True)
