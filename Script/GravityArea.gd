extends Node2D

var collected = false
onready var player = preload("res://Script/Player.gd")
onready var global = get_node("/root/global")

func _on_GravityArea_body_entered(body):
	if body is player:
		if collected:
			return
		collected = true
		visible = false
		
		var GravityArea = get_parent().get_parent().find_node('NormalGravityArea')
		GravityArea.gravity_vec = -GravityArea.gravity_vec
