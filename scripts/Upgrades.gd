extends Node

export var upgrade_count = 20

enum UpgradeType {CAPACITY_HEAT, CAPACITY_WATER, CAPACITY_LONGETIVITY, ACTIVITY, UNLOCK}

var upgrades = []


func init():
	var upgrades = []
	upgrades.resize(upgrade_count)
	for i in upgrades:
		i.resize(len(UpgradeType))
		for j in i:
			j = 1


func apply_upgrade(type, upgrade_id, upgrade_multiplier):
	upgrades[upgrade_id][type] *= upgrade_multiplier