extends Node

onready var tilePacked = predload("res://Scene/Tile.tscn")

func _ready():
	var tile = tilePacked.instance()
	
	