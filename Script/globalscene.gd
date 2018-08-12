extends Node2D

var musics = []
var musics2 = []
var musics3 = []
var musics4 = []

var worldmusics = []

var world = 0

func _ready():
	musics = [$AudioStreamPlayer4, $AudioStreamPlayer3, $AudioStreamPlayer2, $AudioStreamPlayer]
	musics2 = [$AudioStreamPlayer4/Aaah, $AudioStreamPlayer3/Aaah, $AudioStreamPlayer2/Aaah, $AudioStreamPlayer/Aaah]
	musics4 = [$AudioStreamPlayer4/Violin, $AudioStreamPlayer3/Violin, $AudioStreamPlayer2/Violin, $AudioStreamPlayer/Violin]
	musics3 = [$AudioStreamPlayer4/Japanese, $AudioStreamPlayer3/Japanese, $AudioStreamPlayer2/Japanese, $AudioStreamPlayer/Japanese]
	worldmusics = [musics, musics2, musics3, musics4]

func activate_next(world, lvl):
	if world == 2:
		flux.to(musics2[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	elif world == 3:
		flux.to(musics3[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	elif world >= 4:
		flux.to(musics4[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	else:
		flux.to(musics[lvl - 2], 1, {volume_db = $AudioStreamPlayer5.volume_db}, "absolute").ease("quad","inout")
	
func reset(worldnb):
	var f = null
	for music in musics:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	for music in musics2:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	for music in musics3:
		flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
	for music in musics4:
		f = flux.to(music, 1, {volume_db = -80}, "absolute").ease("quad","inout")
		