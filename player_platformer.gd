extends KinematicBody2D

const SPEED = 80
const ACCELERATION = 10
const FRICTION = 2
const GRAVITY = 10
const JUMP_POWER = -250
const CYOTE_TIME = 10
const MAX_LIFE_SPAN = 100
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var keyLifeSpan = {}
var leftKey = KEY_LEFT
var rightKey = KEY_RIGHT
var jumpKey = KEY_SPACE
var cyoteTime = CYOTE_TIME
var currentKeyCode = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	keyLifeSpan = {}
	keyLifeSpan[leftKey] = MAX_LIFE_SPAN
	keyLifeSpan[rightKey] = MAX_LIFE_SPAN
	keyLifeSpan[jumpKey] = MAX_LIFE_SPAN
	
func _unhandled_input(event):
	if event is InputEventKey: 
		if event.is_pressed():
			currentKeyCode = event.scancode
		else:
			currentKeyCode = -1

func _update_velocity(dir, ground, jump):
	velocity.x += dir.x * ACCELERATION
	if abs(velocity.x) > SPEED:
		velocity.x = sign(velocity.x) * SPEED
	if dir.length_squared() == 0:
		velocity.x /= FRICTION
		if abs(velocity.x) < 0.1:
			velocity.x = 0
	if ground && jump:
		velocity.y = JUMP_POWER
		cyoteTime = 0
	velocity.y += GRAVITY
	
func _update_animation(dir):
	$AnimatedSprite.flip_h = dir.x < 0
	if is_on_floor():
		if abs(dir.x) > 0:
			$AnimatedSprite.play("move")
		else:
			$AnimatedSprite.play("idle")
	else:
		if velocity.y >= 0:
			$AnimatedSprite.play("fall")
		else:
			$AnimatedSprite.play("jump")
			
func _update_keys():
	if !currentKeyCode in keyLifeSpan:
		keyLifeSpan[currentKeyCode] = MAX_LIFE_SPAN
	keyLifeSpan[currentKeyCode] -= 1
	if keyLifeSpan[currentKeyCode] <= 0:
		keyLifeSpan[currentKeyCode] = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_update_keys()
	
	var dir = Vector2()
	var jump = false
	if keyLifeSpan[rightKey] > 0 && Input.is_key_pressed(rightKey):
		dir.x = 1
	if keyLifeSpan[leftKey] > 0 && Input.is_key_pressed(leftKey):
		dir.x = -1
	if  keyLifeSpan[jumpKey] > 0 && Input.is_key_pressed(jumpKey):
		jump = true
		
	if is_on_floor():
		cyoteTime = CYOTE_TIME
	else:
		cyoteTime -= 1
		
	_update_velocity(dir, cyoteTime > 0 && is_on_floor(), jump)
	velocity.y = move_and_slide(velocity, FLOOR, true).y
	_update_animation(dir)
