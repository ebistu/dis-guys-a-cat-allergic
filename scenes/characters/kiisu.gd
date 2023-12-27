extends RigidBody2D

var type: String = "mob"

# Called when the node enters the scene tree for the first time.
func _ready():
	var kiisu_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(kiisu_types[randi() % kiisu_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
