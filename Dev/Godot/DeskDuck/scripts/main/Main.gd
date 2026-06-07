extends Node2D
@onready var nova = $Sprite2D

var idle_texture = preload("res://assets/characters/nova/idle.png")
var happy_texture = preload("res://assets/characters/nova/happy.png")
var sad_texture = preload("res://assets/characters/nova/sad.png")

func _ready():
	nova.texture = idle_texture
	SaveManager.load_player()
	TaskManager.load_tasks()
	
func show_happy():
	nova.texture = happy_texture

	await get_tree().create_timer(3.0).timeout

	nova.texture = idle_texture
