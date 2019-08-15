extends TextureProgress

signal critical_over_capacity

export (bool) var critical = false
export var amount = 0
var old_amount = 0
export var capacity = 10

func _process(delta):
	if critical and amount > capacity:
		emit_signal("critical_over_capacity")
	value = (float(amount) / capacity) * 32
	old_amount = amount if amount <= capacity else capacity
	amount = old_amount