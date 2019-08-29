extends Node

export var upgrade_count = 20

enum UpgradeType {CAPACITY_HEAT, CAPACITY_GENERIC, CAPACITY_WATER, ACTIVITY, UNLOCK}

var upgrades = []


func init():
	upgrades = []
	upgrades.resize(upgrade_count)
	for i in range(len(upgrades)):
		upgrades[i] = []
		upgrades[i].resize(len(UpgradeType))
		for j in range(len(UpgradeType)):
			upgrades[i][j] = 1


func apply_upgrade(type, upgrade_id, upgrade_multiplier):
	if upgrade_id == -1:
		return
	upgrades[upgrade_id][type] *= upgrade_multiplier


func apply_upgrade_to_tile(tile):
	if tile.id == 0:
		return
	tile.apply_upgrade(upgrades[tile.upgrade_id])


func save():
	var save_dict = {
		"upgrades" : upgrades
		}
	return save_dict


func load_node(dict):
	upgrades = dict["upgrades"]