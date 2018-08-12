extends Node2D

var musics = []
var musics2 = []
var musics3 = []

func _ready():
	musics = [$AudioStreamPlayer4, $AudioStreamPlayer3, $AudioStreamPlayer2, $AudioStreamPlayer]
	musics2 = [$AudioStreamPlayer4, $AudioStreamPlayer3/Aaah, $AudioStreamPlayer2/Aaah, $AudioStreamPlayer/Aaah]
	musics3 = [$AudioStreamPlayer4, $AudioStreamPlayer3/Aaah, $AudioStreamPlayer2, $AudioStreamPlayer/Violin]

func activate_next(world, lvl):
	if world == 2:
		flux.to(musics2[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	elif world >= 3:
		flux.to(musics3[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	else:
		flux.to(musics[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	
func reset():
	for music in musics:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	for music in musics2:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	for music in musics3:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")