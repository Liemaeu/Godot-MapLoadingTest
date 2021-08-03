# Godot-MapLoadingTest

This is a test project which allows you to load a big map (e.g. of an open world game) part by part with the [Godot Engine](https://godotengine.org/). It is designed for 3D games.

**Please keep in mind this is just a test project I did for fun, not a professional guide how to do it the perfect way.**

## What it does

You can decrease the loading time of your game by not loading the whole map at the beginning.

It loads the tile the player is standing on and the 8 tiles around it. If the player moves to another tile, all addition tiles which are needed will be loaded and every tile that is no longer needed will be removed automatically.

All happens in the background by using threads, so the game will not freeze while loading new parts of the map.

It only works in two dimensions (x and z) since a usual game map is not particularly high, but it could be extended to three dimensions (x, y and z). It depends on your game if it's needed or not.

## How to use

You have cut your map in **equally sized square tiles** and **name them according to their coordinates**, like X1Z1.tscn and X1Z2.tscn (you just have to change the numbers). These tiles must be put in the Map/Tiles/ folder.

In the **Map/Game.gd** script you have to change the value of `tile_size` according to the size of your tiles. You can use the **Tile_Size_Test to test the size*** of your tiles.
