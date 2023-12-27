extends CanvasLayer

signal start_game
signal pause_game
signal resume_game
# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseButton.hide()
	$ResumeButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	$PauseButton.hide()
	show_message("Game over")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge kiisu"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)
	if score > int($Highscore.text):
		$Highscore.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
	$PauseButton.show()


func _on_message_timer_timeout():
	$Message.hide()


func _on_pause_button_pressed():
	show_message("Game paused")
	$ResumeButton.show()
	pause_game.emit()


func _on_resume_button_pressed():
	$ResumeButton.hide()
	resume_game.emit()
	
