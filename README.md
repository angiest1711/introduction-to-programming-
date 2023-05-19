# Urban Heat Island Effect in the cities of Bogota and Soacha, Colombia

## Study Area

### Bogota

The city is located in the middle of Colombia, in the eastern mountain chain in the Andes. It has an altitude of 2600 meters above sea level, despite of that its terrain is relatively flat.

It is divided in 20 localities, these can be divided into UPZ or Zonal Planning Units which help in the urban planning because they integrate neighborhoods that have similar characteristics between each other(sdp,2020).

The city has a relatively stable temperature throughout the year, oscillating between 8°C and 20°C, being 13°C the mean temperature.

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/3c2d2c8d-254c-4102-9ca0-d3cf8694663a)


### Soacha

The city is located at the southwest of Bogota, in the Cundinamarca department at an altitude of 2565meters above sea level. It is totally conurbated with Bogota. In its urban area, Soacha is divided in “comunas”, while the rural is divided in “veredas” (Aldana and Chindicue, 2014)

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/c79fdfe3-c92f-4ca5-a01f-dadb19faf5e3)


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

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/484eb349-8384-4027-8ebd-27c9a81cddb6)

Changing CRS
Croping the Landsat image to see the Study Area

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/27a0257a-bbc5-4850-8d66-fa2bd5377ee0)

NDVI and NDBI

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/2bbd331e-3cef-49c6-ac51-2f75e5ee2f7a)

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/4f4a4e22-916d-4175-b86a-a80c33eecf14)

Landcover

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/76898f94-6164-4d72-8d12-60169ef2ac31)

Socioeconomic Strata

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/ef879454-56a8-4d43-8657-6f20925d1415)


Population Density of Bogota

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/67748d6b-1d8f-4fb9-9991-910a56734597)

There is a lack of accuracy in the population data for Soacha, depending on the source,the population variates from 600.000 people to above 1 million people. What can be said is that density in Soacha is high due to the urbanization patterns that were caused by migration into the city.

DEM

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/2fc3680c-2174-45ac-b122-aa7d11e6fab7)

LST

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/c369971a-25d6-4df4-a8c2-baf33b296eeb)


## Boxplots

Landcover vs temperature

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/77d49504-cb98-4d22-89e7-5d7d79dfa8bd)

Strata vs LST

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/7dc3f60f-8d22-4059-8879-8cbee479744d)

Strata vs NDVI
![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/a7a372a3-d38b-4c41-a211-9f92cf805255)



Relationship between Variables


LST vs NDVI

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/ac2f1e1a-6119-4a95-b5d8-e15946636268)

LST vs NDBI

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/0a289116-d1aa-46c4-bb8b-7310950676be)

LST~Elevation

![image](https://github.com/angiest1711/introduction-to-programming-/assets/119541571/d4d4e889-9aa7-4424-a456-c02bdbe3ff17)


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
