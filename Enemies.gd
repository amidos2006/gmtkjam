extends Node2D

const COIN = preload("res://coin.tscn")
const CHASER_ENEMY = preload("res://chaserEnemy.tscn")
const STATIC_ENEMY = preload("res://staticEnemy.tscn")
const LINE_ENEMY = preload("res://lineEnemy.tscn")
const RAND_ENEMY = preload("res://randomEnemy.tscn")

const ENEMY_TYPES = [
	[0, 0, 0, 0],
	[6, 0, 0, 0],
	[0, 4, 0, 0],
	[6, 3, 0, 0],
	[0, 0, 4, 0],
	[0, 4, 2, 0],
	[2, 4, 2, 0],
	[0, 0, 0, 2],
	[6, 0, 0, 1],
	[0, 4, 0, 1],
	[0, 3, 2, 1],
	[4, 3, 2, 2]
]

const RANDOM_TYPES = [
	[0, 0, 0, 0],
	[4, 0, 0, 0],
	[0, 2, 0, 0],
	[4, 2, 0, 0],
	[0, 0, 2, 0],
	[0, 2, 2, 0],
	[4, 2, 2, 0],
	[0, 0, 0, 0],
	[4, 0, 0, 0],
	[0, 2, 0, 0],
	[0, 2, 2, 1],
	[2, 2, 2, 1]
]

var firstTime = true

func _get_far_loc(center, size, relative, index, shift):
	var trials = 0
	var location = Vector2(relative.x, relative.y)
	var regions = [
		{"x1":0, "x2":size.x, "y1":0, "y2": size.y},
		{"x1":-size.x, "x2":0, "y1":-size.y, "y2": 0},
		{"x1":-size.x, "x2":0, "y1":0, "y2": size.y},
		{"x1":0, "x2":size.x, "y1":-size.y, "y2": 0},
	]
	var r = regions[index % regions.size()]
	while (abs(location.x - relative.x) < shift.x || abs(location.y - relative.y) < shift.y) && trials < 100:
		trials += 1
		location.x = rand_range(r['x1'], r['x2']) + center.x
		location.y = rand_range(r['y1'], r['y2'])  + center.y
	print(trials)
	return location	

func get_new_position(index, shift):
	var center = $"/root/Global".room.global_position
	var size = $"/root/Global".room.get_node("coinarea").shape.extents
	return _get_far_loc(center, size, $"/root/Global".player.global_position, index, shift)

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".enemies = self
		
func _process(delta):
	if firstTime:
		firstTime = false
		var level = min($"/root/Global".level, ENEMY_TYPES.size())
		var enemies = [0, 0, 0, 0]
		enemies[0] += ENEMY_TYPES[level][0] + randi() % (RANDOM_TYPES[level][0] + 1)
		enemies[1] += ENEMY_TYPES[level][1] + randi() % (RANDOM_TYPES[level][1] + 1)
		enemies[2] += ENEMY_TYPES[level][2] + randi() % (RANDOM_TYPES[level][2] + 1)
		enemies[3] += ENEMY_TYPES[level][3] + randi() % (RANDOM_TYPES[level][3] + 1)
		for i in range(0, enemies[0]):
			var enemy = STATIC_ENEMY.instance()
			self.add_child(enemy)
			print(enemy.global_position)
			enemy.global_position = get_new_position(i, Vector2(40, 40))
			print(enemy.global_position)
		for i in range(0, enemies[1]):
			var enemy = LINE_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i, Vector2(100, 80))
		for i in range(0, enemies[2]):
			var enemy = RAND_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i, Vector2(100, 80))
		for i in range(0, enemies[3]):
			var enemy = CHASER_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i, Vector2(200, 100))
			
		var coin = COIN.instance()
		get_parent().add_child(coin)
			
	if $"/root/Global".room.collected >= $"/root/Global".room.MAX_COINS:
		if $"/root/Global".level < ENEMY_TYPES.size() - 1:
			if Input.is_key_pressed(KEY_SPACE):
				$"/root/Global".level += 1
				$"/root/Global".player.global_position = Vector2(320, 180)
				firstTime = true
				$"/root/Global".room.collected = 0
				$"/root/Global".flash.flash()
		else:
			pass
		
