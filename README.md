# Changes in Arctic Permafrost Active Layer Thickness: 1997-2019
Observation of permafrost changes of the active layer thickness (ALT) of Arctic region for [Little Pictures](https://climate.esa.int/en/littlepicturescompetition/) of climate competition 2023

## Motivation
Focusing on changes in permafrost active layer thickness in the Arctic holds significant scientific value due to its underutilization as a parameter in climate visualizations. The Arctic region is particularly vulnerable to climate change, making it a crucial area for study. The active layer thickness represents a critical yet often overlooked factor in climate modeling. This parameter is essential because permafrost contains a substantial carbon reservoir, and its thawing leads to the release of greenhouse gases, exacerbating global warming. Additionally, changes in active layer thickness directly impact Arctic ecosystems, infrastructure, and the well-being of indigenous communities. Therefore, investigating these variations is not only scientifically intriguing but also a matter of scientific responsibility, enabling us to better understand and mitigate the consequences of climate change, both within the Arctic and on a global scale.

## Little picture
### Changes in Arctic Permafrost Active Layer Thickness: 1997-2019
![final_Kluczek](https://github.com/Marcin-Kluczek/permafrost-change/assets/64478068/41c4d180-a45a-42f8-aca9-94963f40f6fa)



## Methods
Permafrost active layer thickness for the Northern Hemisphere (v3.0) was obtained via an FTP server from the [CEDA archive](https://catalogue.ceda.ac.uk/uuid/67a3f8c8dc914ef99f7f08eb0d997e23) in NetCDF4 format [WinSCP](https://winscp.net/eng/index.php?) software. The data processing procedure was carried out in R. The data were read from netcdf4 and then each year was exported to a separate raster, the rasters were then combined into a common layer stack. Using the polygon with the Arctic region (The Arctic Circle), the polar areas were extracted, the values read from each layer and the pixels averaged to individual years. The final step was to export a csv table with Active Layer Thickness for the years 1997-2019.

## Dataset used
ESA Permafrost Climate Change Initiative (Permafrost_cci): Permafrost active layer thickness for the Northern Hemisphere, v3.0

Obu, J.; Westermann, S.; Barboux, C.; Bartsch, A.; Delaloye, R.; Grosse, G.; Heim, B.; Hugelius, G.; Irrgang, A.; Kääb, A.M.; Kroisleitner, C.; Matthes, H.; Nitze, I.; Pellet, C.; Seifert, F.M.; Strozzi, T.; Wegmüller, U.; Wieczorek, M.; Wiesmann, A. (2021): ESA Permafrost Climate Change Initiative (Permafrost_cci): Permafrost active layer thickness for the Northern Hemisphere, v3.0. NERC EDS Centre for Environmental Data Analysis, 28 June 2021. doi:10.5285/67a3f8c8dc914ef99f7f08eb0d997e23. https://dx.doi.org/10.5285/67a3f8c8dc914ef99f7f08eb0d997e23


## Study area - Arctic Circle

![permafrost_arctic_extent](https://github.com/Marcin-Kluczek/permafrost-change/assets/64478068/c0d151e4-5c1e-48fc-8aaf-d8b70ec8ad2a)



by Marcin Kluczek, 2023

#ESAlittlePic #climatechange #ESA #European Space Agency
