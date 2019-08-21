extends TabContainer


export var icons = []


func _ready():
	for i in range(get_tab_count()):
		set_tab_title(i, "")
		set_tab_icon(i, icons[i])
