# Elektronika MS 0511 Common Include Files

This repository contains common include files that I frequently use in projects
for the [Elektronika MS 0511](https://en.wikipedia.org/wiki/UKNC).
## To add to a project as sub-module execute:

```sh
git submodule add git@github.com:aberranthacker/ms0511-common.git common
```

## Third-Party Source Files
In addition to my own include files, this repository also includes the following
third-party source files:
| file              | description                                                                  |
| ----------------- | ---------------------------------------------------------------------------- |
| unlzsa3.s         | an optimized LZSA3 decompressor for the PDP-11, developed by Manwe and Ivanq |
| unlzsa3_from_bp.s | a modified version of **unlzsa3.s** that extracts data from one of the bitplanes |
| unlzsa3_to_bp.s   | a modified version of **unlzsa3.s** that extracts data to one of the bitplanes |
| unzx0.s           | a PDP-11 version of the ZX0 v2.2 unpacker, developed by reddie |
