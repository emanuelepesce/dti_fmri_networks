library(igraph)
library("rgl")

path <- "./../data/graphs_integration/borda_sw_004/Controls/CTRL_amore.graphml"

g <- read.graph(path, "graphml")

x <- V(g)$cx
y <- V(g)$cy
z <- V(g)$cz

rgl_init <- function(new.device = FALSE, bg = "white", width = 640) { 
  if( new.device | rgl.cur() == 0 ) {
    rgl.open()
    par3d(windowRect = 50 + c( 0, 0, width, width ) )
    rgl.bg(color = bg )
  }
  rgl.clear(type = c("shapes", "bboxdeco"))
  rgl.viewpoint(theta = 15, phi = 20, zoom = 0.7)
}

# x, y, z : numeric vectors corresponding to
#  the coordinates of points
# axis.col : axis colors
# xlab, ylab, zlab: axis labels
# show.plane : add axis planes
# show.bbox : add the bounding box decoration
# bbox.col: the bounding box colors. The first color is the
# the background color; the second color is the color of tick marks
rgl_add_axes <- function(x, y, z, axis.col = "red",
                         xlab = "X", ylab="Y", zlab="Z", show.plane = TRUE, 
                         show.bbox = FALSE, bbox.col = c("#333377","black"))
{ 
  
  lim <- function(x){c(-max(abs(x)), max(abs(x))) * 1.1}
  # Add axes
  xlim <- lim(x); ylim <- lim(y); zlim <- lim(z)
  rgl.lines(xlim, c(0, 0), c(0, 0), color = axis.col)
  rgl.lines(c(0, 0), ylim, c(0, 0), color = axis.col)
  rgl.lines(c(0, 0), c(0, 0), zlim, color = axis.col)
  
  # Add a point at the end of each axes to specify the direction
  axes <- rbind(c(xlim[2], 0, 0), c(0, ylim[2], 0), 
                c(0, 0, zlim[2]))
  rgl.points(axes, color = axis.col, size = 3)
  
  # Add axis labels
  rgl.texts(axes, text = c(xlab, ylab, zlab), color = axis.col,
            adj = c(0.5, -0.8), size = 2)
  
  # Add plane
  if(show.plane==TRUE) {
    xlim <- xlim/1.1; zlim <- zlim /1.1
    rgl.quads( x = rep(xlim, each = 2), y = c(0, 0, 0, 0),
               z = c(zlim[1], zlim[2], zlim[2], zlim[1]))
  }

  
  # Add bounding box decoration
  if(show.bbox){
    rgl.bbox(color=c(bbox.col[1],bbox.col[2]), alpha = 0.5, 
             emission=bbox.col[1], specular=bbox.col[1], shininess=5, 
             xlen = 3, ylen = 3, zlen = 3) 
  }
}
y <- y + 200
z <- z + 200
x <- x + 200

rgl_init()
rgl_add_axes(x, y, z, show.plane = TRUE)
rglplot(g, layout=(cbind(x,y,z)))
# Show tick marks
axis3d('x', pos=c( NA, 0, 0 ), col = "darkgrey", ntick = 100)
axis3d('y', pos=c( 0, NA, 0 ), col = "darkgrey")
axis3d('z', pos=c( 0, 0, NA ), col = "darkgrey")
# rgl_add_axes(x, y, z)
# aspect3d(1,1,1)
# Compute and draw the ellipse of concentration
# ellips <- ellipse3d(cov(cbind(x,y,z)), 
#                     centre=c(0,0,0), level = 0.0001)
# shade3d(ellips, col = "#D95F02", alpha = 0.1, lit = FALSE)
# wire3d(ellips, col = "#D95F02",  lit = FALSE)

