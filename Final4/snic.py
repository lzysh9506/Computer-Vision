import heapq
import numpy as np
from math import sqrt


class QueueElement(object):
    #define priority queue elements 
    #the law of poping is decided by the key
    __sub_index = 0

    def __init__(self, dist, value):
        self._key = dist
        self.value = value

    def __lt__(self, other):
        """
        :type other: QueueElement
        """
        return self._key < other._key


class Queue(object): 
    #define a priority queue
    def __init__(self, _buffer_size=0):
        self.heap = []

    def add(self, priority, value):
        heapq.heappush(self.heap, QueueElement(priority, value))

    def is_empty(self):
        return len(self.heap) == 0

    def pop_value(self):
        item = heapq.heappop(self.heap)
        return item.value

    def pop(self):
        return heapq.heappop(self.heap)

    def length(self):
        return len(self.heap)


def compute_centroids(image, grid_of_x, grid_of_y):
    #initialized coordinate and lab value of centroids 
    image_size = np.array([len(image), len(image[0])])

    step_x = image_size[0]//grid_of_x
    step_y = image_size[1]//grid_of_y
    
    centroids_pos = np.array([[[
        int(step_x/2 + x * step_x ),
        int(step_y/2 + y * step_y )
    ] for x in range(grid_of_x)] for y in range(grid_of_y)])
    
    centroids = []
    
    for i in range(len(centroids_pos)):
        for j in range(len(centroids_pos[0])):
            pos = centroids_pos[i][j]
            centroid = [centroids_pos[i][j], image[pos[0]][pos[1]],0]
            centroids.append(centroid)
            
    return centroids


def get_neighbourhood_pos(pos, image_size):
    # outputs candidates 1 pixel away from the image border.
    n = 0
    neighbourhood = [None, None, None, None]

    x = pos[0]
    y = pos[1]

    if x - 1 >= 0:
        neighbourhood[0] = [x - 1, y]
        n += 1

    if y - 1 >= 0:
        neighbourhood[n] = [x, y - 1]
        n += 1

    if x + 1 < image_size[0]:
        neighbourhood[n] = [x + 1, y]
        n += 1

    if y + 1 < image_size[1]:
        neighbourhood[n] = [x, y + 1]
        n += 1
    
    return neighbourhood, n

def update(centroid, candidate, num_pixel):
    #online update centroids value with candidates 
    return (centroid*(num_pixel-1) + candidate)/num_pixel

def snic_distance_mod(pos_i, pos_j, col_i, col_j, s, m):
    #Computes the SNIC pixel distance between i and j
    #param s: normalization factor = 1 / np.sqrt(num_pixels_in_image/num_super_pixels)
    #param m: user provided, higher m leads to more compact superpixels and poorer boundary adherence
    
    pos_d = ((pos_i[0] - pos_j[0])**2 + (pos_i[1] - pos_j[1])**2) / s
    col_d = ((col_i[0]-col_j[0])**2 + (col_i[1]-col_j[1])**2 + (col_i[1]-col_j[1])**2)/ m
    distance = pos_d + col_d
    return distance


def snic(
        image,
        grid_of_x, 
        grid_of_y,
        compactness):
    """
    Computes superpixels from a given image.

    > author = {Zhenyue Liu}
    > title = {Applied Superpixels Simple Non-Iterative Clustering}
    > date = {11.26.2018}

    > reference = {Achanta, Radhakrishna, and Sabine Süsstrunk. 
    "Superpixels and polygons using simple non-iterative clustering." 
    Computer Vision and Pattern Recognition (CVPR), 2017 IEEE Conference on. Ieee, 2017.}
    {https://github.com/MoritzWillig/pysnic}

    """
    #initializa basic parameters 
    image_size = np.array([len(image), len(image[0])])
    label_map = np.ones(image_size)*-1     #create a map with the same size of image, value of unlabeled pixel is -1
    s = sqrt(image_size[0]*image_size[1]/(grid_of_x*grid_of_y))    #normalization factor
    m = compactness
    centroids = compute_centroids(image,grid_of_x, grid_of_y)  # [position, color at position]

    # create priority queue
    queue = Queue(image_size[0] * image_size[1] * 4)  # [position, color, centroid_idx]
    q_add = queue.add  
    q_pop = queue.pop
    
    # create a priority queue first filled with the centroids itself. 
    # since keys of centroids are negative, and keys of other pixels are postive, centroids are poped from queue first
    for k in range(len(centroids)):
        init_centroid = centroids[k]
        q_add(-k, [init_centroid[0], init_centroid[1], k])

    try:
        # process until the queue is empty
        while True:
            
            # pop current processing pixels 
            item = q_pop()
            candidate = item.value      
            candidate_pos = candidate[0]
            candidate_color = candidate[1]

            # test if pixel is not already labeled
            # since the key of first element in queue is 0, we set key of unlabeled pixel to be -1
            if label_map[candidate_pos[0]][candidate_pos[1]] == -1:
                centroid_idx = candidate[2]

                # label new pixel
                label_map[candidate_pos[0]][candidate_pos[1]] = centroid_idx

                # online update of centroid
                centroid = centroids[centroid_idx]
                num_pixels = centroid[2] + 1

                # update centroid position and color and the number of pixels corresponding to this superpixel
                centroid[0] = update(centroid[0], candidate_pos, num_pixels)
                centroid[1] = update(centroid[1], candidate_color, num_pixels)
                centroid[2] = num_pixels
                centroids[centroid_idx] = [centroid[0], centroid[1], centroid[2]]

                # get four neighbour candidates to current processing pixel to queue
                neighbours_pos, neighbour_num = get_neighbourhood_pos(candidate_pos, image_size)
                
                # process neighbour pixels and add unlabeled ones into priority queue
                for i in range(neighbour_num):
                    neighbour_pos = neighbours_pos[i]
                    neighbour_color = image[neighbour_pos[0]][neighbour_pos[1]]
                    # check if neighbour is already labeled
                    # compute the distance between current processing candidate pixel and centroids
                    # use distance as key to add candidate pixels into queue
                    if label_map[neighbour_pos[0]][neighbour_pos[1]] == -1:
                        distance = snic_distance_mod(neighbour_pos, centroid[0], neighbour_color, centroid[1], s, m)
                        q_add(distance, [neighbour_pos, neighbour_color, centroid_idx])

    except IndexError:
        pass

    return label_map, centroids