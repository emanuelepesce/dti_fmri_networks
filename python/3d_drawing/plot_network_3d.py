import numpy as np
import networkx as nx
from mayavi import mlab

def my_plot_network_3d( edges, coords, v_communities, v_size = 7,
                        edges_plot = True, edges_color = (0.5, 0.5, 0.5), 
                        edges_radius = 0.1,north_west_flag = False,
                        contour= True):
    
    mlab.figure(1, bgcolor=(0, 0, 0))
    mlab.clf() 
    
    coords = coords
    
    pts = mlab.points3d(coords[:,0], coords[:,1], coords[:,2],
                        v_communities,
                        scale_factor = v_size,
                        scale_mode = 'none',
                        resolution = 100)
                        
    
    if(edges_plot):    
        pts.mlab_source.dataset.lines = np.array(edges)
        tube = mlab.pipeline.tube(pts, tube_radius = edges_radius)
        mlab.pipeline.surface(tube, color = edges_color)
        
    if(north_west_flag):
        nw_coords = np.array([0, max( coords[:,1]) + 30, 0])
        
        pt_nw = mlab.points3d(  nw_coords[0], nw_coords[1], nw_coords[2],
                                color = (1,0,0),
                                mode = 'arrow',
                                scale_factor = v_size*3,
                                resolution = 100)
    if(contour):
        obj = my_contour3d(coords)    
        obj = mlab.pipeline.iso_surface(mlab.pipeline.contour(obj))
        
        
    mlab.show()
  
  
def my_contour3d(coords):
    
    coords[:,2] += 35     
    
    xmin = min(coords[:,0])
    xmax = max(coords[:,0]) 
    ymin = min(coords[:,1]) - 20
    ymax = max(coords[:,1]) + 40
    zmin = min(coords[:,2]) 
    zmax = max(coords[:,2])  
    
    c = 120j 

    x, y, z = np.mgrid[xmin:xmax:c,ymin:ymax:c,zmin:zmax:c]
       
#    scalars = x * x * 0.5 + y * y + z * z 
    scalars = x * x * 10 + y * y + z * z * 2.0
      
      
    obj = mlab.contour3d(x,y,z, scalars, contours=3, transparent=True,
                          color = (0,0.3,0.9), opacity=0.2)

    return obj