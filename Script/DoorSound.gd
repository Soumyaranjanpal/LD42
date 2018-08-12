extends AudioStreamPlayer

var parent = null
var collide = true

func _ready():
	parent = get_parent()

func _process(delta):
	if parent.position.x >= 505 and not collide:
		collide = true
		play()
		volume_db -= 5
	elif parent.position.x < 505:
		collide = false