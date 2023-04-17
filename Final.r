setwd("C:/Users/CW0004/Documents/EAGLE/Urban/Proyecto")

install.packages("sf")
install.packages("raster")
install.packages("sp")
install.packages("rgdal")
install.packages("terra")
install.packages("stars")
install.packages("landsat")
install.packages("RColorBrewer")
install.packages("mapview")
install.packages("usdm")
install.packages("gstat")
install.packages("basemaps")
install.packages("mapedit")
install.packages("paletteer")

library(plyr)
library(leaflet)
library(gstat)
library(mapedit)
library(basemaps)

library(sp)
library(raster)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(rgdal)
library(terra)
source("utils.R")
library(paletteer)

library(stars)
library(landsat)

library(mapview)
library(usdm)

library(scales)
       

#Loading vector layers

bogota <- st_read("bog.shp")
ggplot(data = bogota) +
  geom_sf()+
  ggtitle("Bogota and Soacha")

soacha <- st_read("soa.shp")
ggplot(data = soacha) +
  geom_sf()+
  ggtitle("Soacha")

bog_soa<-st_read("bog_und_soa.shp")
ggplot(data = bog_soa) +
  geom_sf()+
  ggtitle("Bogota and Soacha")


#Loading bands

img_22_b1<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B1.tif")
img_22_b2<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B2.tif")
img_22_b3<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B3.tif") 
img_22_b4<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B4.tif")
img_22_b5<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B5.tif") 
img_22_b6<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B6.tif")
img_22_b7<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/LC09_L2SP_008057_20220131_20220202_02_T1_SR_B7.tif")
img_22_b10<- raster("LC09_L2SP_008057_20220131_20220202_02_T1/B10_L9.tif")

# Rescale DN and convert to Celsius degrees
stack_23<-stack(img_22_b1,img_22_b2,img_22_b3,img_22_b4,img_22_b5,img_22_b6, img_22_b7)

stack_23_scaled<- (stack_23 * 0.0000275) -0.2 
stack_23_scaled


pal <- colorRampPalette(rev(brewer.pal(11, 'RdYlBu')))(200)
thermal<- ((img_22_b10*0.00341802)+149.0)-273.15
plot(thermal, col=pal)


names(stack_23_scaled) <- c("B1","B2", "B3", "B4", "B5", "B6", "B7")
plot(stack_23)

#Testing band combinations

infrarrojo<-plotRGB(stack_23_scaled, r="B5",g="B4",b="B3", stretch="hist")
falso_color<-plotRGB(stack_23_scaled, r="B7",g="B6",b="B4", stretch="hist")

#Testing CRS and changing projections

crs(bog_soa)
crs(stack_23_scaled)

r_stack<-projectRaster(stack_23_scaled, crs= crs(bog_soa))

#Croping

metropolitana<-crop(r_stack, bog_soa)
plotRGB(metropolitana, r="B4",g="B3",b="B2", stretch="hist")

m_metro<-mask(metropolitana, bog_soa)
plotRGB(m_metro, r="B4",g="B3",b="B2", stretch="hist")
plotRGB(m_metro, r="B5",g="B4",b="B3", stretch="hist")
writeRaster(m_metro, "J:/metropolitana.tif", format = "GTiff", overwrite = TRUE)


#NDVI and NDBI

red <- m_metro$B4
nir <- m_metro$B5
swir <- m_metro$B6
lst <- thermal


#NDVI
veg <- ndvi(nir, red) 
plot(veg, main = "NDVI", col=colorRampPalette(brewer.pal(11, 'RdYlGn'))(200))

#NDBI
builtup <- ndbi(swir, nir) 
plot(builtup, main = "NDBI", col=colorRampPalette(c("black", "white"))(255))


#Landcover

cover_shp_st<-st_read("training_data_metro.shp")
cover_shp_st$Cobertura <- factor(cover_shp_st$Cobertura, 
                                 levels = c("Forest", "Crops", "Grass", "Water",
                                            "Mining", "Baresoil", "Urban"))
ggplot() + 
  geom_sf(data = cover_shp_st, aes(fill = Cobertura)) +
  scale_fill_manual(values = c("olivedrab4", "wheat", "palegreen3","dodgerblue4",
                               "mistyrose3", "cornsilk3", "ivory4"))+
  ggtitle("Landcover Bogota and Soacha")

#Socioeconomic Strata
estratos_shp<-st_read("estratos_soa_bog.shp")
plot(estratos_shp, main="Socioeconomic Strata of Bogota and Soacha, Colombia")

#Population Density
population<-st_read("poblacion-upz-bogota.shp")
ggplot() + 
  geom_sf(data = population, aes(fill = densidad_ur)) +
  ggtitle("Population Density, Bogota")+
  scale_fill_gradient(low="cornsilk",  high=muted("red"))

pop_den<-readOGR("poblacion-upz-bogota.shp")
lst_b<-mask(lst,bogota)
lst_b<-crop(lst_c,bogota)
lc_pop <- aggregate(pop_den, by="densidad_ur", dissolve=TRUE)
df_lst_b <- raster::extract(lst_b, lc_pop, method = "simple", df=TRUE) 


head(df_lst_b)
unique(df_lst_b$ID)
unique(lc_pop$densidad_ur) 
df_lst_b$class <- rep(lc_pop$densidad_ur, table(df_lst_b$ID))
names(df_lst_b)[2] <- "LST" 
head(df_lst_b)


ggplot(df_lst_b, aes(x = class, y = LST, group = class)) +
  geom_point(na.rm = TRUE) +
  labs(x = "Population Density", y = "LST (°C)") +
  geom_smooth(method="auto", se=TRUE, fullrange=FALSE, level=0.95)


#Boxplot

# Landcover vs temperature

cover_shp<-readOGR("training_data_metro.shp")
cover_shp$Cobertura <- factor(cover_shp_st$Cobertura, 
                              levels = c("Forest", "Crops", "Grass", "Water",
                                         "Mining", "Baresoil", "Urban"))

lc_cover <- aggregate(cover_shp, by="Cobertura", dissolve=TRUE)
df_lc <- raster::extract(lst, lc_cover, method = "simple", df=TRUE) 
head(df_lc)
unique(df_lc$ID) 
unique(lc_cover$Cobertura)

df_lc$class <- rep(lc_cover$Cobertura, table(df_lc$ID))
names(df_lc)[2] <- "LST" 
head(df_lc)

ggplot(df_lc, aes(x = class, y = LST, group = class)) +
  geom_boxplot(fill = c("olivedrab4", "wheat", "palegreen3","dodgerblue4",
                        "mistyrose3", "cornsilk3", "ivory4")) +
  labs(x = "Land Cover", y = "LST (°C)") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14),
        panel.grid.major = element_line(size = 0.5, linetype = "dashed", color = "gray50"),
        panel.grid.minor = element_line(size = 0.25, linetype = "dashed", color = "gray50"))

# Strata vs LST

estratos<-readOGR("estratos_soa_bog.shp") 
lc_mult <- aggregate(estratos, by="estrato", dissolve=TRUE)
df <- raster::extract(lst, lc_mult, method = "simple", df=TRUE) 
head(df)
unique(df$ID)
unique(lc_mult$estrato) 
df$class <- rep(lc_mult$estrato, table(df$ID))
names(df)[2] <- "LST" 
head(df)

ggplot(df, aes(x = class, y = LST, group = class)) +
  geom_boxplot(fill = "dodgerblue4") +
  labs(x = "Socioeconomic Strata", y = "LST (?C)") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14),
        panel.grid.major = element_line(size = 0.5, linetype = "dashed", color = "gray50"),
        panel.grid.minor = element_line(size = 0.25, linetype = "dashed", color = "gray50"))

# Strata vs NDVI

lc_mult <- aggregate(estratos, by="estrato", dissolve=TRUE)
df_ndvi <- raster::extract(veg, lc_mult, method = "simple", df=TRUE) 
head(df_ndvi)
unique(df_ndvi$ID) 
unique(lc_mult$estrato)

df_ndvi$class <- rep(lc_mult$estrato, table(df_ndvi$ID))
names(df_ndvi)[2] <- "NDVI" 
head(df_ndvi)

ggplot(df_ndvi, aes(x = class, y = NDVI, group = class)) +
  geom_boxplot(fill = "darkgreen") +
  labs(x = "Socioeconomic Strata", y = "NDVI") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14),
        panel.grid.major = element_line(size = 0.5, linetype = "dashed", color = "gray50"),
        panel.grid.minor = element_line(size = 0.25, linetype = "dashed", color = "gray50"))




# Buffer rural area

buf <- st_difference((st_buffer(bog_soa, dist =  2000)),bog_soa) #Obtain only external area of the city buffer
plot(st_geometry(buf), col="black", main= "External area of the buffer")

rural<-crop(r_stack, buf)
rural<-mask(rural, buf)
plotRGB(rural,  r="B4",g="B3",b="B2", stretch="hist")

lst_rural<-crop(lst,buf)
plot(lst_rural, col=pal)
plot(bog_soa, add=TRUE)
lst_rural<-mask(lst_rural,buf)

#DEM

dem<-raster("dem_bog_soa.tif")
dem<-mask(dem,bog_soa)
dem<-crop(dem,bog_soa)
plot(dem)
lst_c<-mask(lst,bog_soa)
lst_c<-crop(lst_c,bog_soa)
plot(lst_c)

lst_c<-resample(lst_c,dem)
ndvi<-resample(veg,dem)
ndbi<-resample(builtup,dem)
 
st_indices <- stack(lst_c, ndvi, ndbi, dem) 
  names(st_indices) <- c("LST", "NDVI", "NDBI","Elevation") 
st_indices <- mask(st_indices, bog_soa) 

# LST vs NDVI

scatter.smooth(x=values(st_indices[[2]]), y=values(st_indices[[1]]), 
               ylab = "LST  (°C)", main="LST ~ NDVI", 
               col = alpha("grey23", 0.15), xlab = "NDVI", cex.lab = 3)

#LST vs NDBI
scatter.smooth(x=values(st_indices[[3]]), y=values(st_indices[[1]]),
               ylab = "LST  (°C)", main="LST ~ NDBI", 
               col = alpha("grey23", 0.15), xlab = "NDBI",cex.lab = 2)
               
#LST vs Elevation
scatter.smooth(x=values(st_indices[[4]]), y=values(st_indices[[1]]),
               ylab = "LST  (°C)", main="LST ~ Elevation", 
               col = alpha("grey23", 0.15), xlab = "Elevation")

#LST vs Population Density

ggplot(df_lst_b, aes(x = class, y = LST, group = class)) +
  geom_point(na.rm = TRUE) +
  labs(x = "Population Density", y = "LST (°C)")+
  geom_smooth(method = "lm", se = TRUE, fullrange = FALSE, level = 0.95)

