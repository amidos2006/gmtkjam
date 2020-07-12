extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = $"/root/Global".player
	if player == null:
		return
	text = OS.get_scancode_string(player.downKey) + "\n" + str(player.keyLifeSpan[player.downKey])
