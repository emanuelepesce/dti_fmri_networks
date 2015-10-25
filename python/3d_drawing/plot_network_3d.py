import numpy as np
import networkx as nx
from mayavi import mlab

def my_plot_network_3d( edges, coords, v_communities, v_size = 7,
                        edges_plot = True, edges_color = (0.5, 0.5, 0.5), 
                        edges_radius = 0.1,north_west_flag = False):
    
    mlab.figure(1, bgcolor=(0, 0, 0))
    mlab.clf() 
    
    
    pts = mlab.points3d(coords[:,0], coords[:,1], coords[:,2],
                        v_communities,
#                        colormap = theme,
                        scale_factor = v_size,
                        scale_mode = 'none',
                        resolution = 100)
                        
    
    if(edges_plot):    
        pts.mlab_source.dataset.lines = np.array(edges)
        tube = mlab.pipeline.tube(pts, tube_radius = edges_radius)
        mlab.pipeline.surface(tube, color = edges_color)
        
    if(north_west_flag):
        nw_coords = np.array([0, max( coords[:,1]) + 15, 0])
        
    pt_nw = mlab.points3d(  nw_coords[0], nw_coords[1], nw_coords[2],
                            color = (1,0,0),
                            mode = 'arrow',
                            scale_factor = v_size*3,
                            resolution = 100)
    
    mlab.show()
    
    