# wwf-lpi repository

This repository contains work done by the Research Institute for Nature and Forest (INBO) for WWF Belgium to prepare biodiversity data for the calculation of a regional Living Planet Index (LPI) for Belgium (LPR-BE).

The publication of the Belgian LPI can be consulted here [LINK NEEDED]().

The analyses presented in the publication were part of a joint effort with multiple partners (Natuurpunt, Natagora, DEMNA, Arco Van Strien and INBO). 
INBO was responsible for the preprocessing of the biodiversity data concerning grasshoppers, butterflies and moths.
In addition, we also constructed a mapping between the different grid systems that were used by the data providers (Natuurpunt and Natagora).

# Repository structure

```
.
+-- LICENSE
+-- README.md
+-- wwf-lpi.Rproj
+-- media
|   +-- Abraxas grossulariata.png
|   +-- Abraxas sylvata.png
|   +-- ...
|   \-- Zygaena trifolii.png
+-- rendered
|   +-- grid_file_comparison.html
|   +-- WWF_LPR_BE_datapreparation_butterflies_moths_20190918.pdf
|   \-- WWF_LPR_BE_datapreparation_grasshoppers_20190918.pdf
+-- src
|   +-- functions.R
|   +-- grid_file_comparison.Rmd
|   +-- WWF_LPR_BE_datapreparation_butterflies_moths_20190918.Rmd
|   \-- WWF_LPR_BE_datapreparation_grasshoppers_20190918.Rmd
```

The contents in this repository is licensed under a MIT license.
The `.Rproj` allows you to start this project as an [RStudio project](https://rstudio.com/), after cloning the remote GitHub repository to a local repository.

The `media` folder contains density plots depicting the density of butterfly or moths sightings as a function of the day in the year.
A vertical line in these plots indicate the demarcation between different flying periods.

The `src` folder contains the R code used to pre-process the raw data.
Note that the raw data are not released as open data, but the data obtained after pre-processing are released as open data [see Processed data](#processed-data). 
The code is accompanied by explanations of the different pre-processing steps by combining literate text fragments and code blocks in `Rmarkdown` (`.Rmd`) files.
The rendered versions of these files can be found in the `rendered` folder as either `html` or `pdf` files.


# Processed data

The processed data files can be obtained from the following Zenodo archive: [doi](doi).



