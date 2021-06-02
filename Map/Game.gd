extends Node

var tiles_loaded = []
var tiles_existing = []
var tile_size = 20
var player_pos
var thread_lock = false


func _ready():
	#adds tiles to tiles_existing
	check_existing_tiles()
	#adds startup tile
	load_startup_tiles(2, 2)
	#adds player x and z tile position
	player_pos = [get_tile_x(), get_tile_z()]


func _physics_process(delta):
	if player_pos[0] != get_tile_x() or player_pos[1] != get_tile_z():
		if thread_lock == false:
			thread_lock = true
			player_pos = [get_tile_x(), get_tile_z()]
			var thread = Thread.new()
			thread.start(self, "check_tiles", player_pos, 0)


#function to check for existing tiles
func check_existing_tiles():
	var dir = Directory.new()
	dir.open("res://Map/Tiles/")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != '':
		if file.length() > 2:
			#cuts .tscn
			file.erase(file.length() - 5, 5)
			tiles_existing.append(file)
		file = dir.get_next()


#function to load startup tiles
func load_startup_tiles(x, z):
	load_tile(x-1, z-1)
	load_tile(x-1, z)
	load_tile(x-1, z+1)
	load_tile(x, z-1)
	load_tile(x, z)
	load_tile(x, z+1)
	load_tile(x+1, z-1)
	load_tile(x+1, z)
	load_tile(x+1, z+1)


#function to load tiles for load_startup_tiles()
func load_tile(x, z):
	var tile_temp = "X" + str(x) + "Z" + str(z)
	if tiles_existing.has(tile_temp):
		var tile_load_temp = load("res://Map/Tiles/" + tile_temp + ".tscn").instance()
		var x_offset = tile_size / 2 + (int(x) - 1) * tile_size
		var z_offset = tile_size / 2 + (int(z) - 1) * tile_size
		tile_load_temp.global_translate(Vector3(x_offset, 0, z_offset))
		add_child(tile_load_temp)
	tiles_loaded.append(tile_temp)


#function to get tile x position of player
func get_tile_x():
	var x = get_node("Player").translation.x / 2 / (tile_size / 2)
	#correction for converting -0.x in int
	if x < 0 and x > -1:
		x = -1
	else:
		x = int(x)
	return x + 1


#function to get tile z position of player
func get_tile_z():
	var z = get_node("Player").translation.z / 2 / (tile_size / 2)
	#correction for converting -0.x in int
	if z < 0 and z > -1:
		z = -1
	else:
		z = int(z)
	return z + 1


#function to load and unload tiles
func check_tiles(player_pos):
	var tile_temp
	#adds tiles that should be loaded to tiles_should_loaded
	var tiles_should_loaded = []
	tile_temp = "X" + str(player_pos[0] - 1) + "Z" + str(player_pos[1] - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0] - 1) + "Z" + str(player_pos[1])
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0] - 1) + "Z" + str(player_pos[1] + 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0]) + "Z" + str(player_pos[1] - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0]) + "Z" + str(player_pos[1])
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0]) + "Z" + str(player_pos[1] + 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0] + 1) + "Z" + str(player_pos[1] - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0] + 1) + "Z" + str(player_pos[1])
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(player_pos[0] + 1) + "Z" + str(player_pos[1] + 1)
	tiles_should_loaded.append(tile_temp)
	#removes all tiles that should no longer be loaded
	for i in tiles_loaded:
		if not tiles_should_loaded.has(i):
			tiles_loaded.erase(i)
			get_node(i).queue_free()
	#adds all tiles that should be loaded
	for i in tiles_should_loaded:
		if not tiles_loaded.has(i) and tiles_existing.has(i):
			tiles_loaded.append(i)
			tile_temp = load("res://Map/Tiles/" + i + ".tscn").instance()
			var tilexz = i.split("Z", true, 1)
			var x = tilexz[0]
			x.erase(0, 1)
			var z = tilexz[1]
			var x_offset = tile_size / 2 + (int(x) - 1) * tile_size
			var z_offset = tile_size / 2 + (int(z) - 1) * tile_size
			tile_temp.global_translate(Vector3(x_offset, 0, z_offset))
			add_child(tile_temp)
	thread_lock = false
