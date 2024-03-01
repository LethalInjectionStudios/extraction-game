class_name Extraction
extends Area2D

var selected_raid : String = "res://levels/hideout/hideout.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var _player: Player = body as Player
		if _player.weapon_component.weapon:
			_player.unequip_weapon()
		_player._save()
		call_deferred("_load_scene")
		
	
func _load_scene() -> void:
	get_tree().change_scene_to_packed(load(selected_raid))
