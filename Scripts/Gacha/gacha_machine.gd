extends Node2D

@onready var audio_loop = $AudioStreamPlayer2D
@onready var audio_win = $AudioWin
@onready var particles = $GPUParticles2D
@onready var item_label = $WonItemLabel
@onready var casino_music: AudioStreamPlayer2D = $"../CasinoMusic"

const ITEM_NAMES = {
	"item_001": "sports car",
	"item_002": "blue mini car",
	"item_003": "mini robot",
	"item_004": "watermelon",
	"item_005": "table arduino",
	"item_006": "lulu",
	"item_007": "bill cypher",
	"item_008": "ball",
	"item_009": "card",
	"item_010": "chalkboard",
	"item_011": "spring",
}

const WAITING_COLOR = Color(0.0, 1.0, 1.0, 1.0) 

func _ready() -> void:
	casino_music.play()
	item_label.visible = false
	item_label.modulate.a = 0
	if particles:
		particles.emitting = false

func _on_gacha_button_pressed() -> void:
	if audio_loop.playing or item_label.visible:
		return
	
	if Global.coins < 1:
		print("¡No tienes suficientes monedas!")
		item_label.text = "\n ¡NOT ENOUGH \n COINS!"
		item_label.modulate = Color(0.861, 0.828, 0.977, 1.0)
		item_label.visible = true
		
		var t_err = create_tween()
		t_err.tween_property(item_label, "modulate:a", 1.0, 0.2)
		t_err.tween_interval(1.0)
		t_err.tween_property(item_label, "modulate:a", 0.0, 0.3)
		await t_err.finished
		
		item_label.visible = false
		item_label.modulate = Color.WHITE
		return
	
	Global.coins -= 1
	print("Monedas restantes: ", Global.coins)
	
	casino_music.stop()

	var available_items = Global.get_locked_items()
	if available_items.is_empty():
		item_label.text = " ¡COLLECTION \nCOMPLETED!"
		item_label.visible = true
		var t_full = create_tween()
		t_full.tween_property(item_label, "modulate:a", 1.0, 0.2)
		await t_full.finished
		casino_music.play()
		return

	audio_loop.play()
	
	var tween_shake = create_tween().set_loops(15)
	var original_pos = position 
	tween_shake.tween_property(self, "position", original_pos + Vector2(randf_range(-3, 3), randf_range(-3, 3)), 0.1)
	tween_shake.tween_property(self, "position", original_pos, 0.1)
	
	await get_tree().create_timer(3.5).timeout
	
	audio_loop.stop()
	tween_shake.kill()
	position = original_pos
	
	available_items.shuffle()
	var won_id = available_items[0]
	Global.unlock_item(won_id)
	
	audio_win.play()
	particles.emitting = true
	
	var final_name = ITEM_NAMES.get(won_id, won_id)
	
	show_win_animation(final_name)

func show_win_animation(display_name: String):
	var original_label_pos = item_label.position
	
	if particles is GPUParticles2D:
		particles.process_material.scale_min = 4.0
		particles.process_material.scale_max = 6.0
	
	var tween_m = create_tween()
	tween_m.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK)
	tween_m.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

	item_label.text = "¡NEW OBJECT!\n" + display_name
	item_label.visible = true
	
	var tween_t = create_tween()
	tween_t.tween_property(item_label, "modulate:a", 1.0, 0.3)
	tween_t.tween_property(item_label, "position:y", original_label_pos.y - 50, 1.0).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(2.0).timeout
	
	particles.emitting = false
	
	var tween_fade = create_tween()
	tween_fade.tween_property(item_label, "modulate:a", 0.0, 0.5)
	
	await tween_fade.finished
	item_label.visible = false
	item_label.position = original_label_pos
	casino_music.play()
