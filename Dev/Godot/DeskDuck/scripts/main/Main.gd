extends Node2D

func _ready():
	SaveManager.load_player()
	TaskManager.load_tasks()
