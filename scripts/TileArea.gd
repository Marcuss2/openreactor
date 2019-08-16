extends Node2D

export var gridsize_x = 18
export var gridsize_y = 12

var tiles = []
var selected_tile_id = 0


func place_tile(id, x_indice, y_indice):
	var tile = Global.get_tile_instance(0)
	tile.init(16 + 32 * x_indice, 16 + 32 * y_indice, x_indice, y_indice)
	tile.connect("clicked", self, "_on_Tile_clicked")
	tile.connect("clear", self, "_on_Tile_clear")
	tiles[x_indice].append(tile)
	add_child(tile)


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(gridsize_x):
		tiles.append([])
		for j in range(gridsize_y):
			place_tile(0, i, j)


func replace_tile(id, x_indice, y_indice):
	var old_tile = tiles[x_indice][y_indice]
	var new_tile = Global.get_tile_instance(id)
	if new_tile.cost > Global.money:
		return
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


func _on_Tile_clicked(x_indice, y_indice):
	print("Clicked! " + str(x_indice) + " " + str(y_indice))
	if tiles[x_indice][y_indice].id == 0:
		replace_tile(selected_tile_id, x_indice, y_indice)


func _on_Tile_clear(x_indice, y_indice):
	replace_tile(0, x_indice, y_indice)

func _on_Tile_exploded(x_indice, y_indice):
	print("Exploded! " + str(x_indice) + " " + str(y_indice))

func _on_Control_tile_select(tile_id):
	selected_tile_id = tile_id
