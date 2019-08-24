extends TextureRect


export var cost = 100.0
export var upgrade_id = -1
export var text_label = "First line text"
export var maxed_out_label = "maxed"
export (Upgrades.UpgradeType) var type
export var upgrade_multiplier = 4.0 / 3.0
export var cost_multiplier = 1.5
export var group_upgrade = "group_"
export var upgrade_function = "function"
export var unlock_type_argument = []
export var increment = 3
export var increment_limit = 10


var level = 1


var maxed_out = false



func save():
	var save_dict = {
		"path" : get_path(),
		"cost" : cost,
		"visible" : visible,
		"increment" : increment,
		"maxed_out" : maxed_out,
		"level" : level
		}
	return save_dict


func maxed():
	var max_instance = preload("res://scenes/MaxedSprite.tscn").instance()
	add_child(max_instance)


func load_node(save_dict):
	for i in save_dict:
		if i != "path":
			self.set(i, save_dict[i])
	if maxed_out:
		maxed()
	$Label.text = str(level)


func upgrade():
	if Global.money < cost:
		return
	Global.money -= cost
	if type == Upgrades.UpgradeType.UNLOCK:
		get_tree().call_group(group_upgrade + str(increment), upgrade_function, unlock_type_argument[0])
	else:
		get_tree().call_group(group_upgrade, upgrade_function, upgrade_multiplier)
		Upgrades.apply_upgrade(type, upgrade_id, upgrade_multiplier)
	increment += 1
	cost *= cost_multiplier
	if increment > increment_limit:
		maxed_out = true
		maxed()
		return
	level += 1
	$Label.text = str(level)


func _on_UpgradeButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !maxed_out:
			upgrade()
	if event is InputEventMouseMotion:
		get_tree().call_group("mouse_in", "remove_mouse_in")
		if maxed_out:
			Global.set_text_hover_label(maxed_out_label)
		else:
			Global.set_text_hover_label(text_label + "\nCost: " + Global.get_magnified_string(cost))