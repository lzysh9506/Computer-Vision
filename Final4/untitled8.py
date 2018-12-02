# -*- coding: utf-8 -*-
"""
Created on Sat Dec  1 10:23:21 2018

@author: liuzh
"""
import scipy.io as sio
def IOU(label_map1,label_map2):
    intersect = 0

    for i in range(label_map1.shape[0]):
        label1 = np.unique(label_map1[i])
        num_label1 = label1.shape[0]
        p = 0
        label2 = np.unique(label_map2[i])
        num_label2 = label2.shape[0]
        q = 0
        for j in range(label_map1.shape[1]):

            if label_map1[i][j] == label1[p] and label_map2[i][j] == label2[q]:
                    intersect += 1     
            else:
                p = min(p+1, num_label1)
                q = min(q+1, num_label2)
    IOU_rate = intersect/(label_map1.shape[0]*label_map1.shape[1])
    return IOU_rate

IOU(label_map_slic_lzy,label_map_snic)

m = np.zeros((500,750))

a = label_map_snic + segments
b = mark_boundaries(m,a)
misc.imsave('b.png', b)

plt.imshow(mark_boundaries(m,a))

data = sio.loadmat('matlab.mat')