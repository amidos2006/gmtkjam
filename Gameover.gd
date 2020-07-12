extends Control

# Called when the node enters the scene tree for the first time.
func _process(delta):
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
		if $"/root/Global".level >= 9:
			$Victory.visible = true
			$RestartButton.visible = true
		else:
			$NextLvl.visible = true
