# MMLandmarks Dataset

[![paper](https://img.shields.io/badge/arXiv-Paper-B3181B.svg)](https://arxiv.org/abs/2512.17492)
[![Dataset](https://img.shields.io/badge/Dataset-Access-4CAF50)](https://archive.compute.dtu.dk/files/public/projects/MMLandmarks)
[![Website](https://img.shields.io/badge/Project-Website-87CEEB)](https://mmlandmarks.compute.dtu.dk/)

## Description

Welcome to the MultiModal Landmarks (MMLandmarks) dataset, part of our [CVPR 2026 paper](https://arxiv.org/abs/2512.17492).

With this dataset, the Cross-View Localization is extended for the first time to a continental scale at a fine-grained level.
The dataset collection process is inspired by the Google Landmarks Dataset v2 ([GLDv2](https://arxiv.org/abs/2004.01804)), which is combined with information from OpenStreetMaps ([OSM](https://www.openstreetmap.org/)) and the National Agriculture Imagery Program ([NAIP](https://developers.google.com/earth-engine/datasets/catalog/USDA_NAIP_DOQQ)).
It has been collected to enable training models for various geospatial tasks, including Geolocalization, Cross-View Ground-to-Satellite and Satellite-to-Ground localization, and Any-to-Any retrieval.

MMLandmarks is built from $18{,}557$ landmarks in the United States of America, which have associated Wikipedia and Wikimedia Commons pages. 
For each landmark, multiple ground and aerial images are collected, while each landmark has a unique GPS coordinate taken as the geographical center from OSM, and text description collected from Wikimedia Commons.
The total dataset contains $329k$ Ground images, $197k$ Aerial images, $18{,}557$ GPS coordinates and $18{,}557$ Text descriptions, split into 3 sets: `train`, `query`, and `index`.

### Dataset Statistics

| Split | Landmarks | Ground Images | Satellite Images | GPS Coordinates | Text Descriptions |
|:-----:|:---------:|:-------------:|:----------------:|:---------------:|:-----------------:|
| `train` | 17,557 | 310k | 186k | 17,557 | 17,557 |
| `query` | 1,000 | 18,688 | 10,631 | 1,000 | 1,000 |
| **Total** | **18,557** | **329k** | **197k** | **18,557** | **18,557** |
| `index` (ground) | — | 714k | — | — | — |
| `index` (satellite) | — | — | 100k | 100k | — |

We would like to acknowledge the work of Tobias Weyand, Andre Araujo, Bingyi Cao and Jack Sim, and thank them for their comprehensive [GLDv2 repository](https://github.com/cvdfoundation/google-landmark) which has greatly inspired the structure of this one.

## General Information

The dataset can be visually explored [here](https://mmlandmarks.compute.dtu.dk/explore.html).

Download the following CSV file containing information about all $18{,}557$ landmarks with the following link:

[https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/metadata/mmlandmarks.csv](https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/metadata/mmlandmarks.csv)

- `mmlandmarks.csv` CSV with landmark_id, CommonsCategory, WikipediaPage, lat, lon, min_lat, min_lon, max_lat, max_lon, QID, osm_type, osm_id, category, state, hierarchical_category fields. The file gives a full overview of the dataset.
    - `landmark_id`: integer from 0 to 18557.
    - `CommonsCategory`: string with the landmark's Wikimedia Commons Category webpage.
    - `WikipediaPage`: string with the landmark's Wikipedia webpage.
    - `lat`, `lon`: GPS coordinates of the landmark's geographical center.
    - \[`min_lat`,`min_lon`,`max_lat`,`max_lon`\]: bounding box from the landmark OSM polygon.
    - `QID`: string with the landmark's Wikidata identifier.
    - `osm_type`, `osm_id`: string with the type and id for the OSM polygon. Can be found  with `https://www.openstreetmap.org/osm_type/osm_id` to retrieve the associated landmark polygon information.
    - `category`: string referring to the type of the landmark mined from Wikimedia.   
    - `state`: string referring to the state in which the landmark is located.
    - `hierarchical_category`: string corresponding to the landmark's hierarchical label using the hierarchical extension of GLDv2.

## Getting started

Follow the instructions below for downloading the different parts of the MMLandmarks dataset. `get_started.ipynb` gives a comprehensive introduction for how to navigate the dataset.


## Download `train` set

The training set contains $17{,}557$ landmarks with: $310k$ Ground images, $186k$ Satellite images, $17{,}557$ GPS coordinates and $17{,}557$ Text descriptions

### Downloading the labels and metadata
-   `mml_train.csv`: CSV with landmark_id, CommonsCategory, lat, lon fields.
-   `mml_train_ground.csv`: CSV with landmark_id, images fields.
-   `mml_train_satellite.csv`: CSV with landmark_id, images fields.
-   `mml_train_text.csv`: CSV with landmark_id, json fields.

### Downloading the data:

The `train/ground` is split into 80 TAR files (each of size ~800MB), `train/satellite` is split into 200 TAR files (each of size ~850MB) and `train/text` has 1 TAR file (of size ~106MB).
The files are located in the `train/(ground/satellite/text)` directory, and are e.g. named `images_000.tar`, `images_001.tar`, ..., `images_079.tar` for the `ground` files. 
To download them, access the following link: 

[https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/train/ground/images_000.tar](https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/train/ground/images_000.tar)

And similarly for the other files.

#### Using the provided script

```shell
mkdir train && cd train

# Downloads all modalities (ground/satellite/text) for train
bash ../mml-download.sh train

# Downloads ground images for train
bash ../mml-download.sh train ground 80
```



## Download `index` set

The Index set is a large collection of Ground and Aerial images used as a challenging gallery from which to retrieve the correct corresponding landmark information:
- Ground index: $714k$ images from the GLDv2 index set, where the landmarks in MMLandmarks are filtered out.
- Satellite index: $100k$ images sampled from the NAIP, with the same distribution as MMLandmarks.
- GPS index: $100k$ GPS coordinates taken as the centers of the Satellite index set images.

### Downloading the labels and metadata
-   `mml_index_ground.csv`: CSV with images, gldv2_id fields.
-   `mml_index_satellite.csv`: CSV with images, lat, lon, year fields.

### Downloading the data:

The `index/ground` is split into 80 TAR files (each of size ~1GB), and `index/satellite` is split into 120 TAR files (each of size ~1GB).
The files are located in the `index/(ground/satellite)` directory, and are e.g. named `images_000.tar`, `images_001.tar`, ..., `images_079.tar` for the `ground` files. 
To download them, access the following link: 

[https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/index/ground/images_000.tar](https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/index/ground/images_000.tar)

And similarly for the other files.

#### Using the provided script

```shell
mkdir index && cd index

# Downloads all modalities (ground/satellite) for index
bash ../mml-download.sh index

# Downloads satellite images for index
bash ../mml-download.sh index satellite 120
```




## Download `query` set

The query set contains $1{,}000$ landmarks with: $18{,}688$ Ground images, $1{,}000$ Satellite images, $1{,}000$ GPS coordinates and $1{,}000$ Text descriptions. While only the latest satellite images are used for retrieval in the original paper, we provide the full satellite query set ($10{,}631$ images).

### Downloading the labels and metadata
-   `mml_query.csv`: CSV with `landmark_id`, `CommonsCategory`, `lat`, `lon` fields.
-   `mml_query_ground.csv`: CSV with `landmark_id`, `images` fields.
-   `mml_query_satellite.csv`: CSV with `landmark_id`, `images` fields.
-   `mml_query_text.csv`: CSV with `landmark_id`, `json` fields.

### Extra query:
-   `mml_query_all_satellite.csv`: CSV with `landmark_id`, `images` fields.
-   `mml_query_text_sentences.csv`: CSV with `landmark_id`, `sentences` fields.

### Downloading the data:

The `query/ground` is split into 4 TAR files (each of size ~900MB), `query/satellite` is split into 10 TAR files (each of size ~950MB) and `query/text` has 1 TAR file (of size ~7MB).
The files are located in the `query/(ground/satellite/text)` directory, and are e.g. named `images_000.tar`, `images_001.tar`, ..., `images_079.tar` for the `ground` files. 
To download them, access the following link: 

[https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/query/ground/images_000.tar](https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/query/ground/images_000.tar)

And similarly for the other files.

#### Using the provided script

```shell
mkdir query && cd query

# Downloads all modalities (ground/satellite/text) for query
bash ../mml-download.sh query

# Downloads satellite images for query
bash ../mml-download.sh query satellite 10
```




## Checking the download

md5sum files are made available to check the integrity of the downloaded files. Each md5sum file corresponds to one of the TAR files mentioned above, and are located in the same directory as the TAR files: `(train/index/query)/(ground/satellite/text)/`. For example, the md5sum file `images_000.tar` for the ground in the train set can be found via the following link.

[https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/train/ground/md5.images_000.txt](https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks/train/ground/md5.images_000.txt)

And similarly for the other files.

When downloading the dataset with the `download-mml.sh` script, the integrity of the files is already checked as part of the download process.




## Extracting the data

The file structure follows that of [GLDv2](https://github.com/cvdfoundation/google-landmark), namely the files in each directory (`train`, `index`, `query`) and modality (`ground`, `satellite`, `text`) are stored in a directory `${a}/${b}/${c}/${id}.ext` (with `ext`: `jpg` for `ground`, `png` for `satellite`, and `json` for `text`). `${a}`, `${b}`, and `${c}` are the first three letters of the ground/satellite images and text jsons, and `${id}` is the image/json id found in the CSV files. For example:
- a ground image from the train set with id `0123456789abcdef` is stored in `train/ground/0/1/2/0123456789abcdef.jpg`.
- a satellite image from the index set with id `0123456789abcdef` is stored in `index/satellite/0/1/2/0123456789abcdef.png`.
- a text json from the train set with id `0123456789abcdef` is stored in `train/text/0/1/2/0123456789abcdef.json`


## Code & Baseline models

The codebase with the training and evaluation setup for our results can be found here [TODO].

## Dataset licenses

### Wikimedia Commons licenses:
The `ground` images are licensed under Creative Commons and Public Domain licenses. The licenses for all images are available here:
-   `mml_train_licenses.csv`: CSV with `landmark_id`, `images`, `license` fields.
-   `mml_query_licenses.csv`: CSV with `landmark_id`, `images`, `license` fields.

### National Agriculture Imagery Program (NAIP) license:
The `satellite` images are provided by the U.S. Department of Agriculture, Farm Service Agency, and are considered public domain information.
Users of this dataset should acknowledge **USDA Farm Production and Conservation - Business Center, Geospatial Enterprise Operations** when using or distributing the satellite imagery.


## Release history

### May 2026 (version 1.0)

- Initial version release. 

## Contact

For any comments/questions/advice/suggestions, feel free to create an issue on this GitHub repository. We will 

## Citation

If you make use of this dataset, please consider giving the repository a star and citing our paper as:
```
@InProceedings{Kristoffersen_2026_MMLandmarks,
  author    = {Oskar Kristoffersen and Alba Reinders and Morten R. Hannemose and Anders B. Dahl and Dim P. Papadopoulos},
  title     = {MMLandmarks: a Cross-View Instance-Level Benchmark for Geo-Spatial Understanding},
  booktitle = {Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
  month     = {June},
  year      = {2026},
}
```


## Acknowledgements

The satellite imagery in MMLandmarks is sourced from the National Agriculture Imagery Program (NAIP). We acknowledge **USDA Farm Production and Conservation - Business Center, Geospatial Enterprise Operations** for providing this data.
