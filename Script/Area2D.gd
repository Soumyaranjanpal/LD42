extends Area2D

onready var player = preload("res://Script/Player.gd")

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body is player:
		$CollisionShape2D/RESTART.visible = true
