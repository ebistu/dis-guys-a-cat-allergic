extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene
var score
var powerup_shrink = preload("res://scenes/collectibles/powerup_shrink.gd")
var powerup_drop1: bool = false
var powerup_drop1_round: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if score == powerup_drop1_round and powerup_drop1 == false:
		var powerup_shrink = powerup_scene.instantiate()
		powerup_shrink.position = Vector2(randf_range(100, 1180), randf_range(50,670))
		print(powerup_shrink.position)
		add_child(powerup_shrink)
		powerup_drop1 = true

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	powerup_drop1 = false
	powerup_drop1_round = 0

func new_game():
	score = 10
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready")
	get_tree().call_group("mobs", "queue_free")
	powerup_drop1_round = randf_range(10, 25)
	print(powerup_drop1_round)
	

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
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	if score > 50:
		velocity = velocity * 1.25
	elif score > 100:
		velocity = velocity * 1.5
	elif score > 150:
		velocity = velocity * 1.75
	elif score > 200:
		velocity = velocity * 2
	
	kiisu.linear_velocity = velocity.rotated(direction)
	
	add_child(kiisu)
	
	
