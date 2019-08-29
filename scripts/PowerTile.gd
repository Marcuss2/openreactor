extends "res://scripts/Tile.gd"

export var power_gen = 1.0

func tile_logic(tiles):
	var heat = .get_entity("Heat")
	var water = .get_entity("Water")
	if heat.amount >= power_gen * 10 and water.amount >= power_gen * 10:
		heat.amount -= power_gen * 10
		water.amount -= power_gen * 10
		Global.money += power_gen
	
	.tile_logic(tiles)
	
	
func get_sell_cost():
	if power_gen < 1.0:
		return 1.0
	return .get_sell_cost()
	
	
func save():
	var save_dict = .save()
	save_dict["power_gen"] = power_gen
	return save_dict


func get_hover_text():
	var text = hover_text + "\nCost: " + Global.get_magnified_string(get_sell_cost()) + " Power generation: " 
	text += Global.get_magnified_string(power_gen) + " " + $AnimatedSprite/Bars/Heat.get_hover_text() + " "
	text += $AnimatedSprite/Bars/Water.get_hover_text() + " Efficiency: 0.1"
	return text


func upgrade_power_gen(multiplier):
	power_gen *= multiplier


func upgrade_heat_capacity(multiplier):
	$AnimatedSprite/Bars/Heat.capacity *= multiplier


func upgrade_water_capacity(multiplier):
	$AnimatedSprite/Bars/Water.capacity *= multiplier


func apply_upgrade(upgrades):
	power_gen *= upgrades[Upgrades.UpgradeType.ACTIVITY]
	$AnimatedSprite/Bars/Heat.capacity *= upgrades[Upgrades.UpgradeType.CAPACITY_HEAT]
	$AnimatedSprite/Bars/Water.capacity *= upgrades[Upgrades.UpgradeType.CAPACITY_WATER]


func after_load():
	.after_load()