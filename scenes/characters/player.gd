extends Area2D

signal hit
var screen_size
var speed = 200
var indestructible: bool = false
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
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
	else:
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
	match type:
		"reset":
			scale = Vector2(1,1)
			speed = 200
			indestructible = false
		"shrink":
			scale = Vector2(0.5,0.5)
			$poweruplabel.text = "smol"
			$poweruplabel.show()
			await get_tree().create_timer(10.0).timeout
			scale = Vector2(1,1)
			$poweruplabel.hide()
		"speed":
			speed = speed * 2
			$poweruplabel.text = "accelerandoo"
			$poweruplabel.show()
			await get_tree().create_timer(10.0).timeout
			speed = 200
			$poweruplabel.hide()
		"indestructible":
			indestructible = true
			$poweruplabel.text = "immune to cat"
			$poweruplabel.show()
			await get_tree().create_timer(10.0).timeout
			indestructible = false
			$poweruplabel.hide()
