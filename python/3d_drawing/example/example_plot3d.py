import networkx as nx
import numpy as np
from mayavi import mlab
import csv
import sys
sys.path.insert(0, './../')

import plot_network_3d as pl

file_data="example.graphml"
G = nx.read_graphml(file_data)
G = nx.convert_node_labels_to_integers(G, first_label=0)

file_coords = "coords.txt"
coords = []

with open(file_coords, 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    for row in spamreader:
        row = [int(float(i)) for i in row]
        coords.append(row)

xyz = np.array(coords)


v_colors = [0]*90
v_colors[80] = 1
v_colors[81] = 2
v_colors[48] = 1
v_colors[25] = 2
v_colors[45] = 2

pl.my_plot_network_3d(G.edges(), xyz, v_colors, theme = 'Blues', north_west_flag = True)


