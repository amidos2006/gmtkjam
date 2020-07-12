extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SHIFT_X = 2
const ROW1 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-"]
const SCANCODE1 = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0, KEY_MINUS]
const ROW2 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
const SCANCODE2 = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P]
const ROW3 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
const SCANCODE3 = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L]
const ROW4 = ["Z", "X", "C", "V", "B", "N", "M", ","]
const SCANCODE4 = [KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA]


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, ROW1.size()):
		get_node(ROW1[i]).position.x = SHIFT_X + 8 + i * 2
		get_node(ROW1[i]).position.y = 8 
		get_node(ROW1[i] + "/Label").text = ROW1[i]
		get_node(ROW1[i] + "/Label").rect_position = Vector2(-8, -8)
		get_node(ROW1[i] + "/Label").rect_size = Vector2(16, 16)
		get_node(ROW1[i] + "/Label").rect_pivot_offset = Vector2(8, 8)
	for i in range(0, ROW2.size()):
		get_node(ROW2[i]).position.x = SHIFT_X + 9 + i * 2
		get_node(ROW2[i]).position.y = 16
		get_node(ROW2[i] + "/Label").text = ROW2[i]
		get_node(ROW2[i] + "/Label").rect_position = Vector2(-8, -8)
		get_node(ROW2[i] + "/Label").rect_size = Vector2(16, 16)
		get_node(ROW2[i] + "/Label").rect_pivot_offset = Vector2(8, 8)
	for i in range(0, ROW3.size()):
		get_node(ROW3[i]).position.x = SHIFT_X + 10 + i * 2
		get_node(ROW3[i]).position.y = 24
		get_node(ROW3[i] + "/Label").text = ROW3[i]
		get_node(ROW3[i] + "/Label").rect_position = Vector2(-8, -8)
		get_node(ROW3[i] + "/Label").rect_size = Vector2(16, 16)
		get_node(ROW3[i] + "/Label").rect_pivot_offset = Vector2(8, 8)
	for i in range(0, ROW4.size()):
		get_node(ROW4[i]).position.x = SHIFT_X + 11 + i * 2
		get_node(ROW4[i]).position.y = 32
		get_node(ROW4[i] + "/Label").text = ROW4[i]
		get_node(ROW4[i] + "/Label").rect_position = Vector2(-8, -8)
		get_node(ROW4[i] + "/Label").rect_size = Vector2(16, 16)
		get_node(ROW4[i] + "/Label").rect_pivot_offset = Vector2(8, 8)


func get_scancode(v):
	if ROW1.find(v) >= 0:
		return SCANCODE1[ROW1.find(v)]
	if ROW2.find(v) >= 0:
		return SCANCODE2[ROW2.find(v)]
	if ROW3.find(v) >= 0:
		return SCANCODE3[ROW3.find(v)]
	if ROW4.find(v) >= 0:
		return SCANCODE4[ROW4.find(v)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = $"/root/Global".player
	if player == null:
		return
	for c in ROW1:
		var life = player.MAX_LIFE_SPAN
		if get_scancode(c) in player.keyLifeSpan:
			life = player.keyLifeSpan[get_scancode(c)]
		life = life / player.MAX_LIFE_SPAN
		get_node(c).modulate.s = 1 - life
		get_node(c).play(str(min(4, int(life * 5))))
	for c in ROW2:
		var life = player.MAX_LIFE_SPAN
		if get_scancode(c) in player.keyLifeSpan:
			life = player.keyLifeSpan[get_scancode(c)]
		life = life / player.MAX_LIFE_SPAN
		get_node(c).modulate.s = 1 - life
		get_node(c).play(str(min(4, int(life * 5))))
	for c in ROW3:
		var life = player.MAX_LIFE_SPAN
		if get_scancode(c) in player.keyLifeSpan:
			life = player.keyLifeSpan[get_scancode(c)]
		life = life / player.MAX_LIFE_SPAN
		get_node(c).modulate.s = 1 - life
		get_node(c).play(str(min(4, int(life * 5))))
	for c in ROW4:
		var life = player.MAX_LIFE_SPAN
		if get_scancode(c) in player.keyLifeSpan:
			life = player.keyLifeSpan[get_scancode(c)]
		life = life / player.MAX_LIFE_SPAN
		get_node(c).modulate.s = 1 - life
		get_node(c).play(str(min(4, int(life * 5))))
