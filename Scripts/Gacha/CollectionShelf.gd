extends GridContainer

# This function should be connected to the 'item_rolled' signal
func _on_gacha_machine_item_rolled(rolled_item: GachaItem) -> void:
	for slot in get_children():
		if slot.item_reference == rolled_item:
			slot.unlock()
