from PIL import Image
import numpy as np
import time
import skimage.color
from skimage.segmentation import mark_boundaries, find_boundaries
from skimage.segmentation import slic
from sklearn.metrics import confusion_matrix
from scipy import misc
from snic import snic
from slic import SLICProcessor
import scipy.io as sio

def recall(ground_truth_set, image):
    recall = []
    for i in range(len(ground_truth_set)):
        conf_mat = confusion_matrix(ground_truth_set[i].ravel(), image.ravel())
        norm_conf_mat = conf_mat/np.sum(conf_mat)
        recall.append(norm_conf_mat[1][1]/(norm_conf_mat[1][1]+norm_conf_mat[0][0]))
    return np.average(recall), recall
    
# load image
image = np.array(Image.open('118035.jpg'))
lab_image = skimage.color.rgb2lab(image)

# SNIC parameters
grid_of_x = 10
grid_of_y = 10
compactness = 40
iteration = 10

#SNIC
t1 = time.time()
[label_map_snic, centroids_snic] = snic(
    lab_image, grid_of_x, grid_of_y, compactness,)
t2 = time.time()
label_map_snic = label_map_snic.astype(int)
image_seg_snic = mark_boundaries(image, np.array(label_map_snic))
bd_snic = find_boundaries(np.array(label_map_snic)) *1
misc.imsave('img_snic.png', image_seg_snic)
print('SNIC Algorithm cost :', t2-t1)

#SLIC_Zhenyue Liu
slic_lzy = SLICProcessor('118035.jpg', grid_of_x*grid_of_y, 40)
t3 = time.time()
slic_lzy.iterate_10times()
t4 = time.time()
label_map = slic_lzy.label
label_map_slic_lzy = np.zeros((321,481))
for i in range(321):
    for j in range(481):
        label_map_slic_lzy[i][j] = label_map[(i,j)].no
label_map_slic_lzy = label_map_slic_lzy.astype(int)
image_seg_slic_lzy = mark_boundaries(image, np.array(label_map_slic_lzy))
bd_slic_lzy = find_boundaries(np.array(label_map_slic_lzy)) *1
misc.imsave('image_seg_slic_lzy.png', image_seg_slic_lzy)
print('SLIC from Zhenyue Liu cost:', t4-t3)

#SLIC used skimage
segments = slic(image, n_segments = 100, compactness = 40)
t5 = time.time()
slic_skimage = mark_boundaries(image, segments)
bd_slic_skimage = find_boundaries(np.array(segments)) *1
t6 = time.time()
misc.imsave('img_slic_skimage.png', slic_skimage)
print('SLIC from skimage cost:', t6-t5)

#load ground truth image
data = sio.loadmat('matlab.mat')
ground_truth_set = [data['b1'], data['b2'], data['b3'], data['b4'], data['b5']]

#calculate recall score
rec_snic = recall(ground_truth_set,bd_snic)
rec_slic_lzy = recall(ground_truth_set,bd_slic_lzy)
rec_slic_skimage = recall(ground_truth_set,bd_slic_skimage)