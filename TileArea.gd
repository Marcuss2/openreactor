extends Node2D

export var gridsize_x = 19
export var gridsize_y = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	var empty_tile = preload("res://Tile.tscn")
	for i in range(gridsize_x):
		for j in range(gridsize_y):
			var tile = empty_tile.instance()
			tile.init(16 + 32 * i, 16 + 32 * j, i, j)
			tile.connect("clicked", self, "_on_Tile_clicked")
			add_child(tile)
			

func _on_Tile_clicked(x_indice, y_indice):
	print("Clicked! " + str(x_indice) + " " + str(y_indice))