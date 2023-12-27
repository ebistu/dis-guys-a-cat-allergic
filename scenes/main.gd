extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene
var score
var powerupIndex = 0
var powerup_has_dropped_arr: Array[bool] = [false, false, false, false, false, false, false, false, false, false]
var powerup_drop_round_arr: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var boss_kiisu_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	powerup_drop()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BossTimer.stop()
	$HUD.show_game_over()
	powerup_drop_round_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	powerup_has_dropped_arr = [false, false, false, false, false, false, false, false, false, false]
	powerupIndex = 0

func new_game():
	score = 40
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	powerup_drop_round_arr = [randi_range(40,60), randi_range(65,85), randi_range(90,110), randi_range(115,135), randi_range(140,160), \
	randi_range(165,185), randi_range(190,210), randi_range(220,230), randi_range(230,235), randi_range(240,245)]
	print(powerup_drop_round_arr)
	print(powerup_has_dropped_arr)
	$MobTimer.wait_time = 0.5

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var kiisu = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	kiisu.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	kiisu.rotation = direction
	var velocity = Vector2(randf_range(200.0, 350.0), 0.0)
	if score > 50:
		velocity = velocity * 1.5
	elif score > 100:
		velocity = velocity * 2
	elif score > 150:
		velocity = velocity * 2.5
	elif score > 200:
		velocity = velocity * 3
	kiisu.linear_velocity = velocity.rotated(direction)
	add_child(kiisu)

func _on_boss_timer_timeout():
	pass

func game_pause():
	get_tree().paused = true

func game_resume():
	get_tree().paused = false
	
func play_powerup_sound():
	$powerup_sound.play()

func powerup_drop():
	if score == powerup_drop_round_arr[powerupIndex] and powerup_has_dropped_arr[powerupIndex] == false:
		var powerup_shrink = powerup_scene.instantiate()
		powerup_shrink.position = Vector2(randf_range(100, 1180), randf_range(50,670))
		add_child(powerup_shrink)
		powerup_has_dropped_arr[powerupIndex] = true
		if powerupIndex < 4:
			powerupIndex += 1
