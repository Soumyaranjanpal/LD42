extends Node


onready var flux = get_node("/root/flux")

func _ready():
	$Camera2D/Transition.apply_scale($Camera2D.zoom)
	$Camera2D/Transition.translate(Vector2(0, 600 * $Camera2D.zoom.y))
	transition_in()

func transition_in():
	flux.to($Camera2D/Transition, 1, {y = -600 * $Camera2D.zoom.y}, "relative").ease("quad","in")
	
func transition_out():
	flux.to($Camera2D/Transition, 1, {y = 600 * $Camera2D.zoom.y}, "relative").ease("quad","out")
