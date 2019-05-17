import random
import torch

# Constants
FOREIGN = 2
Z_SIZE = 200


def simple_evolution(selected_canvases, zs, G, novelty=False, behavioral=False, mutation_rate=1.0):
    '''
    1:1 implementation of DeepIE if not [novelty], else DeepIE with added novelty search
    '''
    selected_zs, evolved_zs = [], []

    for i in selected_canvases:
        selected_zs.append(zs[i])

    delta = 9 - len(selected_zs)
    x = max(0, delta - FOREIGN)
    if selected_zs:
        evolved_zs.extend([mutate(simple_crossover(selected_zs), mutation_rate)
                           for _ in range(x)])
    else:
        if novelty:
            return behavioral_novelty_search([], G) if behavioral else novelty_search([])
        else:
            return [normal().tolist() for _ in range(9)]

    x = min(FOREIGN, delta)
    evolved_zs.extend([mutate(selected_zs[i], mutation_rate)
                       for i in range(len(selected_zs))])
    if novelty:
        evolved_zs = behavioral_novelty_search(
            [], G) if behavioral else novelty_search(evolved_zs)
    else:
        evolved_zs.extend([normal().tolist() for _ in range(x)])
    return evolved_zs


def simple_crossover(population):
    '''
    Crossover used in DeepIE - picks randomly two from the population
    '''
    a = population[random.randint(0, len(population)-1)]
    b = population[random.randint(0, len(population)-1)]
    return crossover(a, b)


def crossover(a, b):
    '''
    Crossover two genes
    '''
    mask = benoulli().tolist()
    return [mask[i] * a[i] + (1 - mask[i]) * b[i] for i in range(Z_SIZE)]


def benoulli():
    '''
    The Benoulli distribution
    '''
    return torch.Tensor(Z_SIZE).bernoulli_(0.5)


def normal(mutation_rate=1.0):
    '''
    The normal distribution
    '''
    return torch.Tensor(Z_SIZE).normal_(0.0, mutation_rate)


def mutate(individual, mutation_rate=1.0):
    '''
    Mutate an individual
    '''
    mutation = benoulli().tolist()
    noise = normal(mutation_rate).tolist()
    mutations = []
    for i in range(Z_SIZE):
        value = individual[i] + mutation[i] * noise[i]
        if value > 5.0:
            value = 4.99
        if value < -5.0:
            value = -4.99
        mutations.append(value)

    return mutations


def novel_number(numbers):
    '''
    Given a list of numbers, find the number furthest apart from all other numbers
    '''
    numbers.append(4.896745231)
    numbers.append(-4.987654321)
    numbers.sort()
    distance = -1.0
    number = 0.5
    for i in range(1, len(numbers)):
        temp_distance = abs(numbers[i] - numbers[i-1])
        if temp_distance > distance:
            distance = temp_distance
            number = numbers[i-1]
    return number + distance/2.0


def create_novel(zs):
    '''
    Create a single novel Z vector based on previous Z vectors
    '''
    novel = []
    for i in range(Z_SIZE):
        numbers = []
        for z in zs:
            numbers.append(z[i])
        novel.append(novel_number(numbers))
    return novel


def novelty_search(zs):
    '''
    Perform novelty search on the Z vectors
    '''
    if not zs:
        zs.append(normal().tolist())
    novel_size = 9 - len(zs)
    for _ in range(novel_size):
        zs.append(create_novel(zs))

    return zs


def behavioral_novelty_search(zs, G, n=10):
    '''
    Perform behavioral novelty search - noveltry metric: voxel intersections
    '''
    models = []
    if not zs:
        zs.append(normal().tolist())
    for z in zs:
        models.append(torch.round(G.generate(torch.Tensor(z), 'Plane')))
    while len(zs) < 9:
        n_zs, n_models = generate_models(G, n)
        similarity = 100
        z_index = -1
        for index, model in enumerate(n_models):
            temp_similarity = get_sim(model, models)
            if temp_similarity < similarity:
                similarity = temp_similarity
                z_index = index
        zs.append(n_zs[z_index].tolist())
        models.append(torch.round(G.generate(n_zs[z_index], 'Plane')))
    return zs


def generate_models(G, n):
    '''
    Generates [n] z vectors and [n] 3D models
    '''
    zs = [normal() for _ in range(n)]
    models = [torch.round(G.generate(zs[i], 'Plane')) for i in range(n)]
    return zs, models


def get_sim(model, dataset):
    '''
    Returns similarity of a model compared to a dataset
    '''
    size = len(dataset)
    model = torch.nonzero(model)
    voxel_count = len(model)
    same_voxel_count = 0
    for voxels in dataset:
        for (x, y, z) in model:
            if voxels[x][y][z]:
                same_voxel_count += 1
    return same_voxel_count/size/voxel_count*100
