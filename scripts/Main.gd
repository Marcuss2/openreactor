extends Node


func _ready():
	if !Global.load_game():
		$TabContainer/CenterContainer/TileArea.init()
		Upgrades.init()
	$Control.connect("tile_select", $TabContainer/CenterContainer/TileArea, "_on_Control_tile_select")


func _on_Timer_timeout():
	Global.save_game()


func execute_tile_logic():
	$TabContainer/CenterContainer/TileArea.execute_tile_logic()


func _on_Button3_pressed():
	Global.money *= 1000
