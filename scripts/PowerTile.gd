extends "res://scripts/Tile.gd"

export var power_gen = 1.0

func tile_logic(tiles):
	var heat = .get_entity("Heat")
	var water = .get_entity("Water")
	if heat.amount >= power_gen and water.amount >= power_gen:
		heat.amount -= power_gen
		water.amount -= power_gen
		Global.money += power_gen
	
	.tile_logic(tiles)
	
	
func get_sell_cost():
	if int(power_gen) == 1:
		return 1.0
	return .get_sell_cost()
	
	
func save():
	var save_dict = .save()
	save_dict["power_gen"] = power_gen
	return save_dict


func get_hover_text():
	var text = hover_text + "\nPower generation: " + str(power_gen) + " "
	text += $AnimatedSprite/Bars/Heat.get_hover_text() + " " + $AnimatedSprite/Bars/Water.get_hover_text()
	return text