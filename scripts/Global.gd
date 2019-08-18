extends Node

export var cost = []
export var tile_resource = []
export var money = 3.0


var magnitudes = ["", "k", "M", "G", "T", "P", "E", "Z", "Y"]


func get_money_string():
	var mag = money
	var i = 0
	while mag > 10000:
		mag /= 1000
		i += 1
	return str(mag) + magnitudes[i]


func get_tile_instance(id):
	return tile_resource[id].instance()