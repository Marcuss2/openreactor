extends "res://scripts/Tile.gd"

export var power_gen = 1

func tile_logic(tiles):
	var heat = .get_entity("Heat")
	var water = .get_entity("Water")
	if heat.amount >= power_gen and water.amount >= power_gen:
		heat.amount -= power_gen
		water.amount -= power_gen
		Global.money += power_gen
		
func get_sell_cost():
	if power_gen == 1:
		return 1
	return .get_sell_cost()