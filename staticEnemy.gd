extends KinematicBody2D

const BOUNCE = 200
const FRICTION = 1.2

var velocity = Vector2()

func hit(direction):
	direction = direction * BOUNCE
	velocity += direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	z_index = global_position.y
	velocity /= FRICTION
	if velocity.length() < 0.2:
		velocity = Vector2()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(velocity.normalized())
