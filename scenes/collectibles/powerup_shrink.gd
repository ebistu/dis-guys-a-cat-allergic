extends RigidBody2D

var type: String = "powerup"
var poweruptype: String = ""
var typeArr = ["shrink", "speed", "indestructible"]
#var typeArr = ["enlarge"]
# Called when the node enters the scene tree for the first time.
func _ready():
	poweruptype = typeArr[randi_range(0,2)]


# Called every frame. 'delta' is the elapsed time since tahe previous frame.
func _process(_delta):
	pass
