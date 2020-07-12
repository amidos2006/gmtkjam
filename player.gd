extends KinematicBody2D

const SPEED = 150
const ACCELERATION = 10
const FRICTION = 1.5
const MAX_LIFE_SPAN = 100
const BREAK_SPEED = 20
const BOUNCE = 200
const MAX_HEALTH = 3
const MAX_INV = 0.5

var velocity = Vector2()
var keyLifeSpan = {}
var leftKey = KEY_A
var rightKey = KEY_D
var upKey = KEY_W
var downKey = KEY_S
var currentKeyCodes = []

var health = MAX_HEALTH
var invurnability = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".player = self
	
	keyLifeSpan = {}
	keyLifeSpan[leftKey] = MAX_LIFE_SPAN
	keyLifeSpan[rightKey] = MAX_LIFE_SPAN
	keyLifeSpan[upKey] = MAX_LIFE_SPAN
	keyLifeSpan[downKey] = MAX_LIFE_SPAN
	
func heal():
	health += 1
	if health > MAX_HEALTH:
		health = MAX_HEALTH	

func hit(direction):
	if invurnability > 0:
		return
	health -= 1;
	$Sounds/hurt.play()
	if(health <= 0):
		queue_free()
	invurnability = MAX_INV
	direction = direction * BOUNCE
	velocity += direction
	
func is_valid_key(keycode):
	if !keycode in keyLifeSpan:
		keyLifeSpan[keycode] = MAX_LIFE_SPAN
	return keycode != leftKey && \
		keycode != rightKey && \
		keycode != upKey && \
		keycode != downKey && \
		keyLifeSpan[keycode] > 0 && \
		((keycode >= KEY_A && keycode <= KEY_Z) ||\
		 (keycode >= KEY_0 && keycode <= KEY_9) ||\
		 (keycode == KEY_MINUS) ||\
		 (keycode == KEY_COMMA))
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if !currentKeyCodes.has(event.scancode): 
			currentKeyCodes.append(event.scancode)

func _update_velocity(dir):
	velocity.x += dir.x * ACCELERATION
	velocity.y += dir.y * ACCELERATION
	velocity = velocity.clamped(SPEED)
	if dir.length_squared() == 0:
		velocity /= FRICTION
	
func _update_animation(dir):
	if abs(dir.x) > 0:
		$AnimatedSprite.flip_h = dir.x < 0
	if abs(dir.y) > 0 && abs(dir.y) >= abs(dir.x):
		if dir.y > 0:
			$AnimatedSprite.play("move_down")
		elif dir.y < 0:
			$AnimatedSprite.play("move_up")
	elif abs(dir.x) > 0:
		$AnimatedSprite.play("move_right")
	else:
		$AnimatedSprite.play("idle")
	if invurnability > 0:
		visible = !visible
	else:
		visible = true
			
func _update_keys(delta):
	var to_remove = []
	for key in currentKeyCodes:
		if !key in keyLifeSpan:
			keyLifeSpan[key] = MAX_LIFE_SPAN
		if Input.is_key_pressed(key):
			keyLifeSpan[key] -= BREAK_SPEED * delta
			if keyLifeSpan[key] <= 0:
				keyLifeSpan[key] = 0
		else:
			to_remove.append(key)
	for key in to_remove:
		currentKeyCodes.erase(key)
	$Keys.get_node("left").play(str(min(4,int(keyLifeSpan[leftKey]/MAX_LIFE_SPAN * 5))))
	$Keys.get_node("left").modulate.s = 1-keyLifeSpan[leftKey]/MAX_LIFE_SPAN
	var text = OS.get_scancode_string(leftKey)
	if leftKey == KEY_MINUS:
		text = "-"
	if leftKey == KEY_COMMA:
		text = ","
	$Keys.get_node("left/Label").text = text
	$Keys.get_node("right").play(str(min(4,int(keyLifeSpan[rightKey]/MAX_LIFE_SPAN * 5))))
	$Keys.get_node("right").modulate.s = 1-keyLifeSpan[rightKey]/MAX_LIFE_SPAN
	text = OS.get_scancode_string(rightKey)
	if rightKey == KEY_MINUS:
		text = "-"
	if rightKey == KEY_COMMA:
		text = ","
	$Keys.get_node("right/Label").text = text
	$Keys.get_node("up").play(str(min(4,int(keyLifeSpan[upKey]/MAX_LIFE_SPAN * 5))))
	$Keys.get_node("up").modulate.s = 1-keyLifeSpan[upKey]/MAX_LIFE_SPAN
	text = OS.get_scancode_string(upKey)
	if upKey == KEY_MINUS:
		text = "-"
	if upKey == KEY_COMMA:
		text = ","
	$Keys.get_node("up/Label").text = text
	$Keys.get_node("down").play(str(min(4,int(keyLifeSpan[downKey]/MAX_LIFE_SPAN * 5))))
	$Keys.get_node("down").modulate.s = 1-keyLifeSpan[downKey]/MAX_LIFE_SPAN
	text = OS.get_scancode_string(downKey)
	if downKey == KEY_MINUS:
		text = "-"
	if downKey == KEY_COMMA:
		text = ","
	$Keys.get_node("down/Label").text = text
	if keyLifeSpan[leftKey] <= 0 &&\
	 	keyLifeSpan[rightKey] <= 0 &&\
	 	keyLifeSpan[upKey] <= 0 &&\
	 	keyLifeSpan[downKey]:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_update_keys(delta)
	
	var dir = Vector2()
	var jump = false
	if keyLifeSpan[rightKey] > 0 && Input.is_key_pressed(rightKey):
		dir.x += 1
	if keyLifeSpan[leftKey] > 0 && Input.is_key_pressed(leftKey):
		dir.x += -1
	if  keyLifeSpan[upKey] > 0 && Input.is_key_pressed(upKey):
		dir.y += -1
	if  keyLifeSpan[downKey] > 0 && Input.is_key_pressed(downKey):
		dir.y += 1
		
	_update_velocity(dir)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if 'Enemy' in collision.collider.name:
			if collision.collider.has_method('hit'):
				collision.collider.hit(dir)
			hit(-dir)
	_update_animation(dir)
	z_index = global_position.y
	if invurnability > 0:
		invurnability -= delta
