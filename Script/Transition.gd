extends Node


onready var flux = get_node("/root/flux")
var wait_time = 1.5

func _ready():
	$Camera2D/Transition.apply_scale($Camera2D.zoom)
	$Camera2D/Transition/LeftDoor.translate(Vector2(512* $Camera2D.zoom.x, 0))
	$Camera2D/Transition/RightDoor.translate(Vector2(-512* $Camera2D.zoom.x, 0))
	$ExitAreas/Timer.wait_time = wait_time
	
	transition_in()

func transition_in():
	flux.to($Camera2D/Transition/LeftDoor, 1, {x = -512 * $Camera2D.zoom.x}, "relative").ease("quad","in")
	flux.to($Camera2D/Transition/RightDoor, 1, {x = 512 * $Camera2D.zoom.x}, "relative").ease("quad","in")
	
func transition_out():
	flux.to($Camera2D/Transition/LeftDoor, wait_time, {x = 512 * $Camera2D.zoom.x}, "relative").ease("bounce","out")
	flux.to($Camera2D/Transition/RightDoor, wait_time, {x = -512 * $Camera2D.zoom.x}, "relative").ease("bounce","out")
