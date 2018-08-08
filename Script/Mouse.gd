extends AnimatedSprite

onready var global = get_node("/root/global")
var zoom
var init = false

func _ready():
	zoom = get_parent().zoom.x
	global.mouse = self
	global.hovered_objs = []
	z_index = 10
	pass

func _process(delta):
	if not init:
		init = true
	transform.origin = get_viewport().get_mouse_position() * zoom
