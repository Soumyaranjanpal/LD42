extends Area2D

var time = 0
var speed = 1
var label = null

onready var flux = get_node("/root/flux")

func _ready():
	label = get_parent().get_node("Node2D")
	flux.to(label, 1, {angle = PI}, "relative").ease("elastic","out").oncomplete.append(funcref(self, "rotate_again"))

func _process(delta):
	time += delta
	
	$Sprite.rotate(delta * speed * 1.25)
	$Sprite2.rotate(-delta * speed)
	$Sprite3.rotate(delta * speed * 0.75)
	
func rotate_again():
	flux.to(label, 1.5, {angle = PI}, "relative").ease("elastic","out").oncomplete.append(funcref(self, "rotate_again"))