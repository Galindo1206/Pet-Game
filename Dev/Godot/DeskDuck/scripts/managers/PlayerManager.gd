extends Node

var level: int = 1
var xp: int = 0
var coins: int = 0

func add_xp(amount: int):
	xp += amount

	while xp >= get_required_xp():
		xp -= get_required_xp()
		level += 1
		coins += 100

	SaveManager.save_player()

func get_required_xp() -> int:
	return level * 100

func add_coins(amount: int):
	coins += amount
	SaveManager.save_player()