extends TextureProgress

signal critical_over_capacity
signal critical_under_capacity

export var critical_overflow = false
export var critical_underflow = false
export var amount = 0.0
export var capacity = 10.0

var position = Vector2(0, 0)

func _process(delta):
	if critical_overflow and amount > capacity:
		emit_signal("critical_over_capacity")
		return
	if critical_underflow and amount <= 0:
		emit_signal("critical_under_capacity")
		return
	value = (amount / capacity) * 32
	amount = amount if amount <= capacity else capacity


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"name" : name,
		"critical_overflow" : critical_overflow,
		"critical_underflow" : critical_underflow,
		"amount" : amount,
		"capacity" : capacity,
		"pos_x" : position.x,
		"pos_y" : position.y
		}
	return save_dict
	
	
func after_load():
	pass