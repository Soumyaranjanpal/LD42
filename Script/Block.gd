extends Node2D

var agents = []

onready var global = get_node("/root/global")

func _ready():
	pass

func _on_KinematicBody2D_input_event(viewport, event, shape_idx):
	pass

func _on_Area2D_body_entered(body):
	agents.append(body)

func _on_Area2D_body_exited(body):
	agents.erase(body)


func _on_KinematicBody2D_mouse_entered():
	global.hovered_objs.append(self)


func _on_KinematicBody2D_mouse_exited():
	global.hovered_objs.erase(self)
