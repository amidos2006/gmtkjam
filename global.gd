extends Node2D

var player
var room
var enemies
var coin
var flash
var level = 0

func _ready():
	randomize()
