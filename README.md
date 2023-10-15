# Changes in Arctic Permafrost Active Layer Thickness: 1997-2019
Observation of permafrost changes of the active layer thickness (ALT) of Arctic region for [Little Pictures](https://climate.esa.int/en/littlepicturescompetition/) of climate competition 2023

## Motivation
Focusing on changes in permafrost active layer thickness in the Arctic holds significant scientific value due to its underutilization as a parameter in climate visualizations. The Arctic region is particularly vulnerable to climate change, making it a crucial area for study. The active layer thickness represents a critical yet often overlooked factor in climate modeling. This parameter is essential because permafrost contains a substantial carbon reservoir, and its thawing leads to the release of greenhouse gases, exacerbating global warming. Additionally, changes in active layer thickness directly impact Arctic ecosystems, infrastructure, and the well-being of indigenous communities. Therefore, investigating these variations is not only scientifically intriguing but also a matter of scientific responsibility, enabling us to better understand and mitigate the consequences of climate change, both within the Arctic and on a global scale.

## Little picture
### Changes in Arctic Permafrost Active Layer Thickness: 1997-2019
![final_Kluczek](https://github.com/Marcin-Kluczek/permafrost-change/assets/64478068/41c4d180-a45a-42f8-aca9-94963f40f6fa)

In the period spanning from 1997 to 2019, the Arctic region experienced discernible shifts in the Active Layer Thickness (ALT) of permafrost, a critical parameter denoting the depth to which the upper layer of perennially frozen ground thaws during the summer months. These changes have profound implications for both regional and global climates, with a direct nexus to anthropogenic climate warming.

The observed increase in ALT is intricately linked to the anthropogenic influences that have driven global temperature rises. As the Arctic climate warms due to elevated greenhouse gas emissions, the ALT extends its reach, with deeper and more prolonged thawing episodes during the summer season. The relatively rapid response of the active layer to climatic warming is of paramount concern due to its cascading effects on the environment and climate systems.

This shift in ALT sets off a chain of repercussions. Permafrost thawing liberates long-stored greenhouse gases, notably methane and carbon dioxide, into the atmosphere. These gases intensify the greenhouse effect, leading to increased global temperatures and further climatic instability. The temporal proximity between climate warming and ALT changes underscores the urgency in addressing anthropogenic drivers of climate change to stave off the Arctic's transformation into a substantial contributor to global climatic perturbations. Understanding this intricate interplay is essential for preserving Arctic ecosystems and mitigating the broader challenges posed by climate change.


## Methods
Permafrost active layer thickness for the Northern Hemisphere (v3.0) was obtained via an FTP server from the [CEDA archive](https://catalogue.ceda.ac.uk/uuid/67a3f8c8dc914ef99f7f08eb0d997e23) in NetCDF4 format [WinSCP](https://winscp.net/eng/index.php?) software. The data processing procedure was carried out in [R language](https://www.r-project.org/). The data were read from NetCDF and then each year was exported to a separate raster, the rasters were then combined into a common layer stack. Using the polygon with the Arctic region (The Arctic Circle), the polar areas were extracted, the values read from each layer and the pixels averaged to individual years. The final step was to export a csv table with Active Layer Thickness for the years 1997-2019. The data was smoothed with the LOESS algorithm and plotted into a graph which was exported to SVG, where the final graphic effect was given in [Inkscape](https://inkscape.org/) software.

<ins>All procedures were carried out in open source software.</ins>

## Dataset used
ESA Permafrost Climate Change Initiative (Permafrost_cci): Permafrost active layer thickness for the Northern Hemisphere, v3.0

Obu, J.; Westermann, S.; Barboux, C.; Bartsch, A.; Delaloye, R.; Grosse, G.; Heim, B.; Hugelius, G.; Irrgang, A.; Kääb, A.M.; Kroisleitner, C.; Matthes, H.; Nitze, I.; Pellet, C.; Seifert, F.M.; Strozzi, T.; Wegmüller, U.; Wieczorek, M.; Wiesmann, A. (2021): ESA Permafrost Climate Change Initiative (Permafrost_cci): Permafrost active layer thickness for the Northern Hemisphere, v3.0. NERC EDS Centre for Environmental Data Analysis, 28 June 2021. doi:10.5285/67a3f8c8dc914ef99f7f08eb0d997e23. https://dx.doi.org/10.5285/67a3f8c8dc914ef99f7f08eb0d997e23


## Study area - Arctic Circle

![permafrost_arctic_extent](https://github.com/Marcin-Kluczek/permafrost-change/assets/64478068/c0d151e4-5c1e-48fc-8aaf-d8b70ec8ad2a)



by Marcin Kluczek, 2023

#ESAlittlePic #climatechange #ESA #EuropeanSpaceAgency #permafrost #Arctic #R
