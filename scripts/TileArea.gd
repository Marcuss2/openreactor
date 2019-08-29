extends Node2D

export var gridsize_x = 18
export var gridsize_y = 12

var tiles = []
var selected_tile_id = 0

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict


func after_load():
	tiles.resize(gridsize_x)
	for i in range(gridsize_x):
		tiles[i] = []
		tiles[i].resize(gridsize_y)
	for tile in get_children():
		if !(tile is Timer):
			tile.connect("clicked", self, "_on_Tile_clicked")
			tile.connect("clear", self, "_on_Tile_clear")
			tiles[tile.x_indice][tile.y_indice] = tile
			if tile.x_indice > 2 or tile.y_indice > 2:
				tile.add_to_group("size_upgrade_" + str(tile.x_indice if tile.x_indice > tile.y_indice else tile.y_indice))


func place_tile(id, x_indice, y_indice):
	var tile = Global.get_tile_instance(0)
	tile.init(16 + 32 * x_indice, 16 + 32 * y_indice, x_indice, y_indice)
	tile.name = tile.name + "_" + str(x_indice) + "_" + str(y_indice)
	tile.connect("clicked", self, "_on_Tile_clicked")
	tile.connect("clear", self, "_on_Tile_clear")
	tiles[x_indice][y_indice] = tile
	add_child(tile)


# Called when the node enters the scene tree for the first time.
func init():
	tiles.resize(gridsize_x)
	for i in range(gridsize_x):
		tiles[i] = []
		tiles[i].resize(gridsize_y)
	for i in range(gridsize_x):
		for j in range(gridsize_y):
			place_tile(0, i, j)
	for i in range(gridsize_x):
		for j in range(3, gridsize_y):
			tiles[i][j].enabled = false
			tiles[i][j].add_to_group("size_upgrade_" + str(i if i > j else j))
	for i in range(3, gridsize_x):
		for j in range(gridsize_y):
			tiles[i][j].enabled = false
			tiles[i][j].add_to_group("size_upgrade_" + str(i if i > j else j))


func replace_tile(id, x_indice, y_indice):
	var old_tile = tiles[x_indice][y_indice]
	var new_tile = Global.get_tile_instance(id)
	if new_tile.cost > Global.money:
		return
	new_tile.name = new_tile.name + "_" + str(x_indice) + "_" + str(y_indice)
	new_tile.init(16 + 32 * x_indice, 16 + 32 * y_indice, x_indice, y_indice)
	new_tile.connect("clicked", self, "_on_Tile_clicked")
	new_tile.connect("clear", self, "_on_Tile_clear")
	tiles[x_indice][y_indice] = new_tile
	old_tile.queue_free()
	add_child(new_tile)


func get_surrounding_tiles(x_indice, y_indice):
	var surrounding_tiles = []
	if x_indice != 0:
		surrounding_tiles.append(tiles[x_indice - 1][y_indice])
	if x_indice != gridsize_x - 1:
		surrounding_tiles.append(tiles[x_indice + 1][y_indice])
	if y_indice != 0:
		surrounding_tiles.append(tiles[x_indice][y_indice - 1])
	if y_indice != gridsize_y - 1:
		surrounding_tiles.append(tiles[x_indice][y_indice + 1])
	return surrounding_tiles


func execute_tile_logic():
	for i in range(gridsize_x):
		for j in range(gridsize_y):
			tiles[i][j].tile_logic(get_surrounding_tiles(i, j))
	get_tree().call_group("tick_action", "tick")
	get_tree().call_group("second_pass", "second_pass")


func _on_Tile_clicked(x_indice, y_indice):
	print_debug("Tile: %d %d" % [x_indice, y_indice])
	if tiles[x_indice][y_indice].id == 0 and tiles[x_indice][y_indice].enabled:
		replace_tile(selected_tile_id, x_indice, y_indice)


func _on_Tile_clear(x_indice, y_indice):
	if tiles[x_indice][y_indice].id == 0 and !tiles[x_indice][y_indice].enabled:
		return
	replace_tile(0, x_indice, y_indice)

func _on_Tile_exploded(x_indice, y_indice):
	print("Exploded! " + str(x_indice) + " " + str(y_indice))

func _on_Control_tile_select(tile_id):
	selected_tile_id = tile_id
