extends RigidBody2D

var type: String = "powerup"
var poweruptype: String = ""
var typeArr = ["shrink", "speed", "indestructible"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	poweruptype = typeArr[randf_range(0,2)]
