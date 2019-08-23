extends Node


func _ready():
	if !Global.load_game():
		$TabContainer/CenterContainer/TileArea.init()
	$Control.connect("tile_select", $TabContainer/CenterContainer/TileArea, "_on_Control_tile_select")


func _on_Timer_timeout():
	Global.save_game()
