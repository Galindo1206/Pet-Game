extends Node

var active_character = "nova_classic"

var characters = {
	"nova_classic": {
		"name": "Nova Classic",
		"price": 0,
		"unlocked": true
	},
	"nova_gold": {
		"name": "Nova Gold",
		"price": 300,
		"unlocked": false
	},
	"nova_shadow": {
		"name": "Nova Shadow",
		"price": 500,
		"unlocked": false
	}
}

func buy_character(character_id: String) -> bool:
	if not characters.has(character_id):
		return false

	var character = characters[character_id]

	if character["unlocked"]:
		active_character = character_id
		return true

	if PlayerManager.coins < character["price"]:
		return false

	PlayerManager.coins -= character["price"]
	character["unlocked"] = true
	active_character = character_id

	SaveManager.save_player()

	return true

func get_character(character_id: String) -> Dictionary:
	return characters.get(character_id, {})

func get_all_characters() -> Dictionary:
	return characters
