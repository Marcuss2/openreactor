extends Node2D

export var gridsize_x = 19
export var gridsize_y = 12

var tiles = []
var selected_tile_id = 0

export var tile_resource = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(gridsize_x):
		tiles.append([])
		for j in range(gridsize_y):
			var tile = tile_resource[0].instance()
			tile.init(16 + 32 * i, 16 + 32 * j, i, j)
			tile.connect("clicked", self, "_on_Tile_clicked")
			tiles[i].append(tile)
			add_child(tile)


func _on_Tile_clicked(x_indice, y_indice):
	print("Clicked! " + str(x_indice) + " " + str(y_indice))
	if tiles[x_indice][y_indice].id == 0:
		tiles[x_indice][y_indice].queue_free()
		var new_tile = tile_resource[selected_tile_id].instance()
		new_tile.init(16 + 32 * x_indice, 16 + 32 * y_indice, x_indice, y_indice)
		new_tile.connect("clicked", self, "_on_Tile_clicked")
		tiles[x_indice][y_indice] = new_tile
		add_child(new_tile)


func _on_Tile_exploded(x_indice, y_indice):
	print("Exploded! " + str(x_indice) + " " + str(y_indice))

func _on_Control_tile_select(tile_id):
	selected_tile_id = tile_id
