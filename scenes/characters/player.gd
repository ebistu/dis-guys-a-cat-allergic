extends Area2D

signal hit
signal picked_powerup
var screen_size
var speed = 200
var indestructible: bool = false
var animationOverride: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		if animationOverride == false:
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if animationOverride == false:
			$AnimatedSprite2D.animation = "walk"
	else:
		if animationOverride == false:
			$AnimatedSprite2D.animation = "default"
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0
		

func _on_body_entered(body):
	match body.type:
		"mob":
			if indestructible == false:
				hide()
				hit.emit()
				$CollisionShape2D.set_deferred("disabled", true)
				powerup("reset")
		"powerup":
			powerup(body.poweruptype)
			body.queue_free()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func powerup(type):
	if type == "reset":
		scale = Vector2(1,1)
		speed = speed
		indestructible = false
		animationOverride = false
		$poweruplabel.hide()
	else:
		$poweruplabel.show()
		picked_powerup.emit()
		match type:
			"shrink":
				scale = Vector2(0.5,0.5)
				$poweruplabel.text = "smol"
			"speed":
				speed = speed * 2
				$poweruplabel.text = "accelerandoo"
			"indestructible":
				$AnimatedSprite2D.animation = "ghost"
				animationOverride = true
				indestructible = true
				$poweruplabel.text = "immune to cat"
			"enlarge":
				scale = Vector2(1.5,1.5)
				$poweruplabel.text = "huge"
		await get_tree().create_timer(10.0).timeout
		powerup("reset")
