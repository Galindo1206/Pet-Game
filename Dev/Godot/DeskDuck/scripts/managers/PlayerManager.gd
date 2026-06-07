extends Node

var level: int = 1
var xp: int = 0
var coins: int = 0

func add_xp(amount: int) -> bool:
	var leveled_up = false

	xp += amount

	while xp >= get_required_xp():
		xp -= get_required_xp()
		level += 1
		coins += 100
		leveled_up = true

	SaveManager.save_player()

	return leveled_up

func get_required_xp() -> int:
	return level * 100

func add_coins(amount: int):
	coins += amount
	SaveManager.save_player()
