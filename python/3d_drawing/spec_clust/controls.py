import networkx as nx
import numpy as np
from mayavi import mlab
import csv
import sys
sys.path.insert(0, './../')

import plot_network_3d as pl

file_data="./../example/example.graphml"
G = nx.read_graphml(file_data)
G = nx.convert_node_labels_to_integers(G, first_label=0)

file_coords = "./../example/coords.txt"
coords = []

with open(file_coords, 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    for row in spamreader:
        row = [int(float(i)) for i in row]
        coords.append(row)

coords = np.array(coords)

file_clustering = "./membership_controls.csv"
communities = []
lines = [line.rstrip('\n') for line in open(file_clustering)]

for l in lines:
    communities.append(float(l))

co = communities

k = max(communities)

for i in xrange(len(communities)):
    communities[i] = communities[i]/k

pl.my_plot_network_3d(G.edges(), coords, communities,north_west_flag = True)


