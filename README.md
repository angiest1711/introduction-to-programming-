# Urban Heat Island Effect in the cities of Bogota and Soacha, Colombia

## Study Area

### Bogota

The city is located in the middle of Colombia, in the eastern mountain chain in the Andes. It has an altitude of 2600 meters above sea level, despite of that its terrain is relatively flat.

It is divided in 20 localities, these can be divided into UPZ or Zonal Planning Units which help in the urban planning because they integrate neighborhoods that have similar characteristics between each other(sdp,2020).

The city has a relatively stable temperature throughout the year, oscillating between 8°C and 20°C, being 13°C the mean temperature.

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/3c2d2c8d-254c-4102-9ca0-d3cf8694663a)


### Soacha

The city is located at the southwest of Bogota, in the Cundinamarca department at an altitude of 2565meters above sea level. It is totally conurbated with Bogota. In its urban area, Soacha is divided in “comunas”, while the rural is divided in “veredas” (Aldana and Chindicue, 2014)

## Data description

1.Landsat 9 image -> Extracted from the USGS Earth Explorer web page, for the 31/01/2022. Belonging to the Landsat Collection 2 Level. It includes thermal information.

2.Land cover data from the Cundinamarca government.

3.Socioeconomic strata data from the IDECA.

Colombia has a stratification system where it determines the socioeconomic conditions and infrastructure of constructions. It follows a methodology in order to classify by city blocks or “manzanas”depending on three factors, Housing, Urban Environment and Urban Context, where different variables are taken to account and it makes a classification into 6 levels, being 1 the lowest and 6 the highest.

4.UPZ and city shapefiles from Datos Abiertos.

## Preprocessing

Libraries

Loading Vector Layers -> It only includes the urban area of each city.
Loading Raster Files
Rescale DN and convert to Celsius degrees -> As the selected Landsat image belongs to the Collection 2 Level, it already has some preprocessing, making easier to rescale the values and working with them. A mistake made in the beginning was using a Level 1 image, making the obtained results not so logical.
Changing CRS
Croping the Landsat image to see the Study Area

NDVI and NDBI
Landcover
Socioeconomic Strata

Population Density of Bogota

There is a lack of accuracy in the population data for Soacha, depending on the source,the population variates from 600.000 people to above 1 million people. What can be said is that density in Soacha is high due to the urbanization patterns that were caused by migration into the city.

DEM

Boxplots

Landcover vs temperature

Strata vs LST



Relationship between Variables


LST~NDVI
LST~NDBI
LST~Elevation
LST~Population Density

## Conclusions

The socioeconomic strata that registers more data in terms of concentrated heat is the Strata 3 due to its economical activity and industries, forming a heat belt in the occidental part of the city.
-Some of the unplanned areas do not take green areas into account, making their temperature higher, compared to those that, due to their location near the oriental hills, have more vegetation.

Temperature decreases with the high terrains .

## Limitations

Computational power and storage.

Data Availability

A wider time frame would allow to see the differences between rain and dry seasons throughout the years and the evolution in temperatures.

## Sources

Secretaria de Planeación. 2020. Norma Urbana

Aldana, C and Chindicue, C. 2014. Multitemporal Analysis Tierra Blanca and Neuta swamp in the municipality of Soacha
