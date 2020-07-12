extends Control

var leftBroke = false
var rightBroke = false
var upBroke = false
var downBroke = false
var prevBroke = false

func _input(event):
	var player = $"/root/Global".player
	if is_broke() and event is InputEventKey:
		var newKey = event.scancode
		if !player.is_valid_key(newKey):
			newKey = -1
		if newKey >= 0:
			if leftBroke:
				player.leftKey = newKey
			elif rightBroke:
				player.rightKey = newKey
			elif upBroke:
				player.upKey = newKey
			elif downBroke:
				player.downKey = newKey

func more_buttons():
	if $"/root/Global".player == null:
		return false
	var result = 0
	for i in range(KEY_A, KEY_Z + 1):
		if $"/root/Global".player.is_valid_key(i):
			result += 1
	for i in range(KEY_0, KEY_9 + 1):
		if $"/root/Global".player.is_valid_key(i):
			result += 1
	if $"/root/Global".player.is_valid_key(KEY_COMMA):
		result += 1
	if $"/root/Global".player.is_valid_key(KEY_MINUS):
		result += 1
	return result >= 1

func is_broke():
	return more_buttons() && (leftBroke || rightBroke || upBroke || downBroke)

func _process(delta):
	var player = $"/root/Global".player
	if player == null:
		return
	leftBroke = player.keyLifeSpan[player.leftKey] <= 0
	rightBroke = player.keyLifeSpan[player.rightKey] <= 0
	upBroke = player.keyLifeSpan[player.upKey] <= 0
	downBroke = player.keyLifeSpan[player.downKey] <= 0
	get_tree().paused = is_broke()
	visible = is_broke()
	if leftBroke:
		get_node("leftText").visible = true
		get_node("rightText").visible = false
		get_node("upText").visible = false
		get_node("downText").visible = false
	elif rightBroke:
		get_node("leftText").visible = false
		get_node("rightText").visible = true
		get_node("upText").visible = false
		get_node("downText").visible = false
	elif upBroke:
		get_node("leftText").visible = false
		get_node("rightText").visible = false
		get_node("upText").visible = true
		get_node("downText").visible = false
	elif downBroke:
		get_node("leftText").visible = false
		get_node("rightText").visible = false
		get_node("upText").visible = false
		get_node("downText").visible = true
	if !prevBroke && is_broke():
		$break.play()
	prevBroke = is_broke()
