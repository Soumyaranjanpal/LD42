extends Label

onready var global = get_node("/root/global")

func _ready():
	var t = global.time
	var minute = int(t / 60)
	var second = int(t) % 60
	
	text = ("%d:" % minute) + ("%02d" % second)
