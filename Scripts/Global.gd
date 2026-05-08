extends Node

var historia_completada: bool = false
var intro_visto = false
var endless_mode:bool=false
var difficulty_level:int =0
var coins:int=0
var coin_pressed : bool=false

# Dictionary to store the collection status
# item_id: is_unlocked
var collection = {
	"item_001": false,
	"item_002": false,
	"item_003": false,
	"item_004": false,
	"item_005": false,
	"item_006": false,
	"item_007": false,
	"item_008": false,
	"item_009": false,
	"item_010": false,
	"item_011": false,
}

# Function to get only the items that are still locked
func get_locked_items() -> Array:
	var locked = []
	for item_id in collection.keys():
		if collection[item_id] == false:
			locked.append(item_id)
	return locked

# Function to unlock an item
func unlock_item(item_id: String):
	if collection.has(item_id):
		collection[item_id] = true
