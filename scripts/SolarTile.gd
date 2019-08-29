extends "res://scripts/Tile.gd"

export var heat_gen = 4.0

func tile_logic(tiles):
	var heat_entities = .get_entities_from_tiles("Heat", tiles)
	for entity in heat_entities:
		if entity.amount < heat_gen:
			entity.amount += heat_gen / heat_entities.size()
			entity.amount = min(heat_gen, entity.amount)
	.tile_logic(tiles)


func save():
	var save_dict = .save()
	save_dict["heat_gen"] = heat_gen
	return save_dict


func get_hover_text():
	return hover_text + "\nCost: %s Heat generation: %s" % [Global.get_magnified_string(cost), Global.get_magnified_string(heat_gen)]


func upgrade_heat_gen(multiplier):
	heat_gen *= multiplier


func apply_upgrade(upgrades):
	heat_gen *= upgrades[Upgrades.UpgradeType.ACTIVITY]