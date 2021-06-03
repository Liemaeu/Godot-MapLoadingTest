extends Node

###############################################################################
#############    Place your 3 tiles in res://Tile_Size_Test/    ###############
#############    The tiles must be named X1Z1, X1Z2 and X2Z1    ###############
###############################################################################

#change the tile_size value until they tile correctly
var tile_size = 20


var xz = []
var tile_temp
var x_offset
var z_offset

func _ready():
	#X1Z1
	tile_temp = load("res://Tile_Size_Test/X1Z1.tscn").instance()
	xz = [1, 1]
	x_offset = tile_size / 2 + (xz[0] - 1) * tile_size
	z_offset = tile_size / 2 + (xz[1] - 1) * tile_size
	tile_temp.global_translate(Vector3(x_offset, 0, z_offset))
	add_child(tile_temp)
	#X1Z2
	tile_temp = load("res://Tile_Size_Test/X1Z2.tscn").instance()
	xz = [1, 2]
	x_offset = tile_size / 2 + (xz[0] - 1) * tile_size
	z_offset = tile_size / 2 + (xz[1] - 1) * tile_size
	tile_temp.global_translate(Vector3(x_offset, 0, z_offset))
	add_child(tile_temp)
	#X2Z1
	tile_temp = load("res://Tile_Size_Test/X2Z1.tscn").instance()
	xz = [2, 1]
	x_offset = tile_size / 2 + (xz[0] - 1) * tile_size
	z_offset = tile_size / 2 + (xz[1] - 1) * tile_size
	tile_temp.global_translate(Vector3(x_offset, 0, z_offset))
	add_child(tile_temp)
