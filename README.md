# VolticPunk

This is a suite of extensions and utilities built on top of the existing FlashPunk library. It includes an Entity-Component framework, asset management and Ogmo Editor level support.

## Project Structure

The library expects a root folder called assets, as in `src/assets`, with a file `A.as` in it. This file is generated using scripts, and contains all definitions for asset imports.

The script within this repo at `assets/directory.py` should be placed in this assets folder, running it will generate `A.as`.

The project requires a file `C.as` defined in the root, which defines `WIDTH`, `HEIGHT` and `GRID` as static constants.

Create a package `entities.loadable` and place `volticpunk.entities.loadable`'s contents in it, running the `generate.py` file creates `E.as` which is used for looking up entities via reflection.

## Dependencies

This project depends only on FlashPunk
