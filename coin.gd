extends Area2D

signal killEveryone

const SMALL_DIST = 200
const SCALE_SPEED = 5

var firstTime = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".coin = self
	$CPUParticles2D.restart()
	$Sprite.scale.x = 0
	$Sprite.scale.y = 0
	
func _get_far_loc(center, size, relative):
	var trials = 0
	var location = Vector2(relative.x, relative.y)
	while (location - relative).length() < 100 && trials < 100:
		trials += 1
		location.x = rand_range(-size.x/2, size.x/2) + center.x
		location.y = rand_range(-size.y/2, size.y/2)  + center.y
	return location	

func _on_Coin_body_entered(body):
	if "Player" in body.name:
		if $"/root/Global".room.coin_collected():
			$CPUParticles2D.restart()
			$Sprite.scale.x = 0
			$Sprite.scale.y = 0
			$"/root/Global".player.get_node("Sounds/collect").play()
			var center = $"/root/Global".room.global_position
			var size = $"/root/Global".room.get_node("coinarea").shape.extents
			position = _get_far_loc(center, size, $"/root/Global".player.global_position)
	if "room" in body.name:
		var center = $"/root/Global".room.global_position
		var size = $"/root/Global".room.get_node("coinarea").shape.extents
		position = _get_far_loc(center, size, $"/root/Global".player.global_position)

func _process(delta):
	if firstTime:
		firstTime = false
		var center = $"/root/Global".room.global_position
		var size = $"/root/Global".room.get_node("coinarea").shape.extents
		position = _get_far_loc(center, size, $"/root/Global".player.global_position)
	z_index = global_position.y
	if $Sprite.scale.x < 1:
		$Sprite.scale.x += delta * SCALE_SPEED
	else:
		$Sprite.scale.x = 1
	$Sprite.scale.y = $Sprite.scale.x
