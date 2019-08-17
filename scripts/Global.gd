extends Node

export var cost = []
export var tile_resource = []
var money = 5

func get_tile_instance(id):
	return tile_resource[id].instance()

func _ready():
	money = 3