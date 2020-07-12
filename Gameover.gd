extends Control

var startgame = true
var alpha = 1

# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	if startgame and \
		Input.is_key_pressed(KEY_A) or \
		Input.is_key_pressed(KEY_D) or \
		Input.is_key_pressed(KEY_S) or \
		Input.is_key_pressed(KEY_W) or \
		Input.is_key_pressed(KEY_SPACE):
		startgame = false
	if not startgame:
		$Title.modulate.a -= delta * 2
		if $Title.modulate.a < 0:
			$Title.modulate.a = 0
		
	$Defeat.visible = false
	$RestartButton.visible = false
	$Victory.visible = false
	$NextLvl.visible = false
	if $"/root/Global".player == null:
		$Defeat.visible = true
		$RestartButton.visible = true
		if Input.is_key_pressed(KEY_SPACE):
			$"/root/Global".level = 0
			get_tree().reload_current_scene()
	if $"/root/Global".room.collected >= $"/root/Global".room.MAX_COINS:
		if $"/root/Global".level >= 11:
			$Victory.visible = true
			$RestartButton.visible = true
			if Input.is_key_pressed(KEY_SPACE):
				$"/root/Global".level = 0
				get_tree().reload_current_scene()
		else:
			$NextLvl.visible = true
