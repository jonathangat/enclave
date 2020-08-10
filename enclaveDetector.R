# load libraries
library(sf)
library(tmap)
library(units)

# set tmap mode to view
tmap_mode('view')

# read shapefile
juris <- st_read('shp/shiput.shp')


# explode multipolygons
juris_explode <- st_cast(juris,"POLYGON")

# create a spare matrix
juris_mtx <- st_intersects(juris_explode,juris_explode)


# iterate over the sf object and count the number of neighbours for each polygon
for (i in 1:nrow(juris_explode)) {
  juris_explode[i,'numOfNei'] <- length(juris_mtx[[i]])-1
}

# add a new boolean variable for enclaves
juris_explode$enclave <- ifelse(juris_explode$numOfNei==1,'מובלעת','לא מובלעת')

# calculate the area of each polygon
juris_explode$area <- st_area(juris_explode)

# set units
juris_explode$area <- set_units(juris_explode$area, km^2)

# map it
tm_shape(juris_explode, title='Jurisdiction Enclaves in Israel') +
  tm_polygons('enclave',
              title = 'מקרא',
              id = 'Muni_Heb',
              alpha = 0.5,
              palette = c('#d1d1d1','#ffee00'),
              border.aplha = 0.2,
              border.col = '#999999',
              popup.vars=c('Muni_Heb','Muni_Eng','Sug_Muni','CR_PNIM','Machoz','numOfNei','area')) +
  tm_scale_bar() +
  tm_layout('מפת המובלעות של ישראל')

