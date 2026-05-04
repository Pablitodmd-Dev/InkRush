extends Node

var minigame_list = {
	"res://Scenes/Microgames/Dodge the balls/Dodge.tscn":"allArrows",
	"res://Scenes/Microgames/dodge_vehicles/main.tscn":"horizontal",
	"res://Scenes/Microgames/Escape the labyrinth/Level1.tscn":"allArrows",
	"res://Scenes/Microgames/Help The Robot/Main.tscn":"vertical",
	"res://Scenes/Microgames/Hit the fruit/main.tscn":"onlyright",
	"res://Scenes/Microgames/Pattern Bot/main.tscn":"numbers",
	"res://Scenes/Microgames/Protect Lulu/Game.tscn":"horizontal",
	"res://Scenes/Microgames/score_the_goal/main.tscn":"onlyup",
	"res://Scenes/Microgames/The Last Lesson/main.tscn":"horizontal",
	"res://Scenes/Microgames/trampoline_game/trampoline_game.tscn":"horizontal"
}

var lives: int = 4
@onready var menu_layer = $menu

func _ready():
	menu_layer.update_brushes(lives)
	load_random_microgame()

func load_random_microgame() -> void:
	if minigame_list.size()<=0:
		get_tree().quit()
		return
	menu_layer.show_screen("start")
	var allKeys=minigame_list.keys()
	var random_index = randi() % minigame_list.size()
	var game_path = allKeys[random_index]

	var control_type =minigame_list[game_path]

	menu_layer.show_specific_controls(control_type)

	await get_tree().create_timer(3.0).timeout

	var game_scene = load(game_path).instantiate()

	game_scene.finished.connect(_on_microgame_finished)
	
	add_child(game_scene)
	
	#minigame_list.pop_at(random_index)
	minigame_list.erase(game_path)
	menu_layer.hide_all() 
	menu_layer.hide_all_controls()

func _on_microgame_finished(success: bool) -> void:
	for child in get_children():
		if child != menu_layer:
			child.queue_free()
	
	if success:
		menu_layer.show_screen("completed")
	else:
		lives -= 1
		menu_layer.show_screen("failed")
		menu_layer.update_brushes(lives)

	if lives <= 0:
		print("GAME OVER")
	else:
		await get_tree().create_timer(3.0).timeout
		load_random_microgame()
