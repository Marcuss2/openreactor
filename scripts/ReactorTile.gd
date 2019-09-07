extends "res://scripts/Tile.gd"


export var heat_gen = 10.0
export var reactivity = 1.0

var relative_reactivity = 1.0

var tint


func after_load():
	$AnimatedSprite/Bars/Longetivity.connect("critical_under_capacity", self, "run_out")


func _ready():
	relative_reactivity = reactivity
	tint = $AnimatedSprite/AnimatedSprite.modulate


func apply_upgrade(upgrades):
	heat_gen *= upgrades[Upgrades.UpgradeType.ACTIVITY]
	$AnimatedSprite/Bars/Longetivity.amount *= upgrades[Upgrades.UpgradeType.CAPACITY_GENERIC]
	$AnimatedSprite/Bars/Longetivity.capacity *= upgrades[Upgrades.UpgradeType.CAPACITY_GENERIC]
	relative_reactivity = reactivity


func save():
	var save_dict = .save()
	save_dict["heat_gen"] = heat_gen
	return save_dict


func upgrade_heat_gen(multiplier):
	heat_gen *= multiplier


func upgrade_longetivity(multiplier):
	$AnimatedSprite/Bars/Longetivity.amount *= multiplier
	$AnimatedSprite/Bars/Longetivity.capacity *= multiplier


func _process(delta):
	pass


func tile_logic(tiles):
	if !enabled:
		if Global.check_rebuy(upgrade_id):
			Global.money -= cost
			$AnimatedSprite/Bars/Longetivity.amount = $AnimatedSprite/Bars/Longetivity.capacity
			$AnimatedSprite/AnimatedSprite.modulate = tint
		else:
			return
	relative_reactivity = reactivity
	for tile in tiles:
		if tile.type == TileType.REACTOR:
			relative_reactivity += tile.reactivity
	for tile in tiles:
		if tile.type == TileType.BOOSTER:
			relative_reactivity *= tile.reaction_multiplier
	var heat_entities = .get_entities_from_tiles("Heat", tiles)
	if len(heat_entities) == 0:
		explode()
		return
	if relative_reactivity > $AnimatedSprite/Bars/Longetivity.amount:
		$AnimatedSprite/Bars/Longetivity.amount
		for entity in heat_entities:
			entity.amount += (heat_gen * $AnimatedSprite/Bars/Longetivity.amount) / heat_entities.size()
	else:
		for entity in heat_entities:
			entity.amount += (heat_gen * relative_reactivity) / heat_entities.size()
	$AnimatedSprite/Bars/Longetivity.amount -= relative_reactivity


func get_hover_text():
	return hover_text + "\nCost: %s Heat generation per reactivity: %s Reactivity: %s" % [Global.get_magnified_string(cost), Global.get_magnified_string(heat_gen), Global.get_magnified_string(relative_reactivity)]


func run_out():
	enabled = false
	$AnimatedSprite/AnimatedSprite.modulate = Color(1, 1, 1, 0.5).blend(tint)