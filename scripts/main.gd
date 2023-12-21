extends Node

@export var mob_scene: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $ScoreTimer.is_stopped() and Input.is_action_pressed("start_game"):
		new_game()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready")
	get_tree().call_group("mobs", "queue_free")
	

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
	
	
