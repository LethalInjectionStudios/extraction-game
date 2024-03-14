class_name MainMenu
extends Control

@export var play_button: Button
@export var scene: PackedScene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(scene)


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _on_twitter_pressed() -> void:
	OS.shell_open("https://twitter.com/LethalInjStudio")


func _on_twitch_pressed() -> void:
	OS.shell_open("https://www.twitch.tv/lethalinjectiongames")


func _on_discord_pressed() -> void:
	OS.shell_open("https://discord.gg/9pHs8dBdp3")