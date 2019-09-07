extends "res://scripts/Tile.gd"

export var exchanged_entity = "Heat"

var entity

var left_exists = false
var down_exists = false
var up_exists = false
var right_exists = false

var left_is_exchanger = false
var down_is_exchanger = false
var up_is_exchanger = false
var right_is_exchanger = false

var left_entity
var down_entity
var up_entity
var right_entity

var left_intake = 0.0
var down_intake = 0.0
var up_intake = 0.0
var right_intake = 0.0

var left_outlet = 0.0
var down_outlet = 0.0
var up_outlet = 0.0
var right_outlet = 0.0


func get_hover_text():
	return hover_text + "\nCost: " + str(get_sell_cost()) + " " + entity.get_hover_text()


func apply_upgrade(upgrades):
	entity = get_node("./AnimatedSprite/Bars/" + exchanged_entity)
	entity.capacity *= upgrades[Upgrades.UpgradeType.CAPACITY_GENERIC]


func get_sell_cost():
	return cost - cost * entity.amount / entity.capacity


func save():
	var save_dict = .save()
	save_dict["left_intake"] = left_intake
	save_dict["down_intake"] = down_intake
	save_dict["up_intake"] = up_intake
	save_dict["right_intake"] = right_intake
	save_dict["left_outlet"] = left_outlet
	save_dict["down_outlet"] = down_outlet
	save_dict["up_outlet"] = up_outlet
	save_dict["right_outlet"] = right_outlet
	return save_dict


func after_load():
	.after_load()
	entity = .get_entity(exchanged_entity)
	if entity.critical_overflow:
		entity.connect("critical_over_capacity", self, "explode")


func _ready():
	._ready()
	entity = .get_entity(exchanged_entity)


func all_to_false():
	left_exists = false
	down_exists = false
	up_exists = false
	right_exists = false
	
	left_is_exchanger = false
	down_is_exchanger = false
	up_is_exchanger = false
	right_is_exchanger = false


func neighbors_exists(tiles):
	all_to_false()
	for tile in tiles:
		if x_indice > tile.x_indice: # Left
			left_exists = tile.has_entity(exchanged_entity)
			if !left_exists:
				left_outlet = 0.0
				left_intake = 0.0
			else:
				left_entity = tile.get_entity(exchanged_entity)
				if tile.type == TileType.EXCHANGER_HEAT:
					left_is_exchanger = true
		elif y_indice > tile.y_indice: # Down
			down_exists = tile.has_entity(exchanged_entity)
			if !down_exists:
				down_outlet = 0.0
				down_intake = 0.0
			else:
				down_entity = tile.get_entity(exchanged_entity)
				if tile.type == TileType.EXCHANGER_HEAT:
					down_is_exchanger = true
		elif y_indice < tile.y_indice: # Up
			up_exists = tile.has_entity(exchanged_entity)
			if !up_exists:
				up_outlet = 0.0
				up_intake = 0.0
			else:
				up_entity = tile.get_entity(exchanged_entity)
				if tile.type == TileType.EXCHANGER_HEAT:
					up_is_exchanger = true
		else: # Right
			right_exists = tile.has_entity(exchanged_entity)
			if !right_exists:
				right_outlet = 0.0
				right_intake = 0.0
			else:
				right_entity = tile.get_entity(exchanged_entity)
				if tile.type == TileType.EXCHANGER_HEAT:
					right_is_exchanger = true


func count_outlets():
	var outlets = 0
	if left_exists:
		outlets += 1
	if down_exists:
		outlets += 1
	if up_exists:
		outlets += 1
	if right_exists:
		outlets += 1
	return outlets


func zero_out():
	left_intake = 0.0
	down_intake = 0.0
	up_intake = 0.0
	right_intake = 0.0
	left_outlet = 0.0
	down_outlet = 0.0
	up_outlet = 0.0
	right_outlet = 0.0


var left_overfilled = false
var down_overfilled = false
var up_overfilled = false
var right_overfilled = false


func count_underfilled():
	var count = 0
	if left_exists and !left_overfilled:
		count += 1
	if down_exists and !down_overfilled:
		count += 1
	if up_exists and !up_overfilled:
		count += 1
	if right_exists and !right_overfilled:
		count += 1
	return count


func divide_between_entities(divided_amount):
	var count = count_underfilled()
	if count == 0:
		return
	if left_exists and !left_overfilled:
		left_outlet += divided_amount / count
	if down_exists and !down_overfilled:
		down_outlet += divided_amount / count
	if up_exists and !up_overfilled:
		up_outlet += divided_amount / count
	if right_exists and !right_overfilled:
		right_outlet += divided_amount / count

func update_outlets(outlet_count):
	left_overfilled = false
	down_overfilled = false
	up_overfilled = false
	right_overfilled = false
	var divided_amount = 0.0
	if left_exists:
		if left_outlet < entity.amount / outlet_count:
			left_outlet += ((entity.amount / outlet_count) - left_outlet) / 2
		else:
			left_outlet += ((entity.amount / outlet_count) - left_outlet)
		if left_entity.amount > entity.amount and entity.amount != 0 and left_entity.amount != 0:
			left_overfilled = true
			var ratio = left_entity.amount / entity.amount
			divided_amount += left_outlet * (ratio - 1)
			left_outlet /= ratio
	if down_exists:
		if down_outlet < entity.amount / outlet_count:
			down_outlet += ((entity.amount / outlet_count) - down_outlet) / 2
		else:
			down_outlet += ((entity.amount / outlet_count) - down_outlet)
		if down_entity.amount > entity.amount and entity.amount != 0 and down_entity.amount != 0:
			down_overfilled = true
			var ratio = down_entity.amount / entity.amount
			divided_amount += down_outlet * (ratio - 1)
			down_outlet /= ratio
	if up_exists:
		if up_outlet < entity.amount / outlet_count:
			up_outlet += ((entity.amount / outlet_count) - up_outlet) / 2
		else:
			up_outlet += ((entity.amount / outlet_count) - up_outlet)
		if up_entity.amount > entity.amount and entity.amount != 0 and up_entity.amount != 0:
			up_overfilled = true
			var ratio = up_entity.amount / entity.amount
			divided_amount += up_outlet * (ratio - 1)
			up_outlet /= ratio
	if right_exists:
		if right_outlet < entity.amount / outlet_count:
			right_outlet += ((entity.amount / outlet_count) - right_outlet) / 2
		else:
			right_outlet += ((entity.amount / outlet_count) - right_outlet) 
		if right_entity.amount > entity.amount and entity.amount != 0 and right_entity.amount != 0:
			right_overfilled = true
			var ratio = right_entity.amount / entity.amount
			divided_amount += right_outlet * (ratio - 1)
			right_outlet /= ratio
	divide_between_entities(divided_amount)


func upgrade_entity_capacity(multiplier):
	entity.capacity *= multiplier


func update_intakes():
	if left_is_exchanger:
		left_intake = 0.0
	elif left_exists:
		left_intake += ((left_entity.amount / 4) - left_intake)
	
	if down_is_exchanger:
		down_intake = 0.0
	elif down_exists:
		down_intake += ((down_entity.amount / 4) - down_intake)
	
	if up_is_exchanger:
		up_intake = 0.0
	elif up_exists:
		up_intake += ((up_entity.amount / 4) - up_intake)
	
	if right_is_exchanger:
		right_intake = 0.0
	elif right_exists:
		right_intake += ((right_entity.amount / 4) - right_intake)


func tile_logic(tiles):
	neighbors_exists(tiles)
	var outlet_count = count_outlets()
	if outlet_count == 0:
		zero_out()
		return
	update_outlets(outlet_count)
	update_intakes()
	.tile_logic(tiles)


func second_pass():
	if left_exists:
		left_entity.amount += left_outlet - left_intake
		entity.amount += left_intake - left_outlet
		if left_entity.amount < 0.0:
			left_entity.amount = 0.0
	if down_exists:
		down_entity.amount += down_outlet - down_intake
		entity.amount += down_intake - down_outlet
		if down_entity.amount < 0.0:
			down_entity.amount = 0.0
	if up_exists:
		up_entity.amount += up_outlet - up_intake
		entity.amount += up_intake - up_outlet
		if up_entity.amount < 0.0:
			up_entity.amount = 0.0
	if right_exists:
		right_entity.amount += right_outlet - right_intake
		entity.amount += right_intake - right_outlet
		if right_entity.amount < 0.0:
			right_entity.amount = 0.0
	if entity.amount < 0.0:
		entity.amount = 0.0