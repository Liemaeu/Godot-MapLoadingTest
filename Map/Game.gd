extends Node

var tiles_loaded = []
var tiles_existing = []
var tiles_should_loaded = []
var tile_size = 20
var thread_loading
var thread_unloading
var thread_loading_lock = false
var thread_unloading_lock = false
var timer_loading = Timer.new()
var timer_unloading = Timer.new()


func _ready():
	#adds tiles to tiles_existing
	check_existing_tiles()
	#adds startup tile
	load_startup_tiles(2, 2)
	#sets up the loading timer
	timer_loading.connect("timeout", self, "_on_timer_loading_timeout")
	timer_loading.wait_time = 0.1
	add_child(timer_loading)
	timer_loading.start()
	#sets up the unloading timer
	timer_unloading.connect("timeout", self, "_on_timer_unloading_timeout")
	timer_unloading.wait_time = 0.1
	add_child(timer_unloading)
	timer_unloading.start()


func _physics_process(delta):
	check_tiles()



func _on_timer_loading_timeout():
	if thread_loading_lock == false:
		thread_loading_lock = true
		thread_loading = Thread.new()
		thread_loading.start(self, "load_existing_tiles", null, 0)


func _on_timer_unloading_timeout():
	if thread_unloading_lock == false:
		thread_unloading_lock = true
		thread_unloading = Thread.new()
		thread_unloading.start(self, "unload_unexisting_tiles", null, 0)


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

#function to load all tiles that aren't loaded but should be
func load_existing_tiles(arg):
	var children = []
	for i in get_children():
		children.append(i.name)
	for i in tiles_loaded:
		if not children.has(i):
			var tile_temp = load("res://Map/Tiles/" + i + ".tscn").instance()
			var tilexz = i.split("Z", true, 1)
			var x = tilexz[0]
			x.erase(0, 1)
			var z = tilexz[1]
			var x_offset = tile_size / 2 + (int(x) - 1) * tile_size
			var z_offset = tile_size / 2 + (int(z) - 1) * tile_size
			tile_temp.global_translate(Vector3(x_offset, 0, z_offset))
			add_child(tile_temp)
	thread_loading_lock = false


#function to unload all no longer in tiles_loaded existing tiles
func unload_unexisting_tiles(arg):
	for i in get_children():
		if tiles_existing.has(i.name):
			if not tiles_loaded.has(i.name):
				get_node(i.name).queue_free()
	thread_unloading_lock = false


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
func check_tiles():
	var tile_temp
	#adds tiles that should be loaded to tiles_should_loaded
	tiles_should_loaded.clear()
	tile_temp = "X" + str(get_tile_x() - 1) + "Z" + str(get_tile_z() - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x() - 1) + "Z" + str(get_tile_z())
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x() - 1) + "Z" + str(get_tile_z() + 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x()) + "Z" + str(get_tile_z() - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x()) + "Z" + str(get_tile_z())
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x()) + "Z" + str(get_tile_z() + 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x() + 1) + "Z" + str(get_tile_z() - 1)
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x() + 1) + "Z" + str(get_tile_z())
	tiles_should_loaded.append(tile_temp)
	tile_temp = "X" + str(get_tile_x() + 1) + "Z" + str(get_tile_z() + 1)
	tiles_should_loaded.append(tile_temp)
	#removes all tiles that should no longer be loaded from tiles_loaded
	for i in tiles_loaded:
		if not tiles_should_loaded.has(i):
			tiles_loaded.erase(i)
	#adds all tiles that should be loaded to tiles_loaded
	for i in tiles_should_loaded:
		if not tiles_loaded.has(i):
			tiles_loaded.append(i)
