extends Node2D

var musics = []

func _ready():
	musics = [$AudioStreamPlayer4, $AudioStreamPlayer3, $AudioStreamPlayer2, $AudioStreamPlayer]

func activate_next(lvl):
	flux.to(musics[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	
func reset():
	flux.to($AudioStreamPlayer, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	flux.to($AudioStreamPlayer2, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	flux.to($AudioStreamPlayer3, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	flux.to($AudioStreamPlayer4, 1, {volume_db = -80}, "absolute").ease("quad","inout")