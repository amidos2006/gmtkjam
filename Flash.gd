extends ColorRect

const SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".flash = self

func flash():
	color.a = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color.a -= delta * SPEED
	if color.a < 0:
		color.a = 0
