class_name MainMenu
extends Control

@export var play_button: Button
@export var scene: PackedScene
@export var audio_player: AudioStreamPlayer2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(scene)

func _on_settings_pressed() -> void:
	pass
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_twitter_pressed() -> void:
	OS.shell_open("https://twitter.com/LethalInjStudio")


func _on_twitch_pressed() -> void:
	OS.shell_open("https://www.twitch.tv/lethalinjectiongames")


func _on_discord_pressed() -> void:
	OS.shell_open("https://discord.gg/9pHs8dBdp3")


func _on_quit_mouse_entered() -> void:
	audio_player.play()


func _on_settings_mouse_entered() -> void:
	audio_player.play()

func _on_start_mouse_entered() -> void:
	audio_player.play()


func _on_twitter_mouse_entered() -> void:
	audio_player.play()


func _on_twitch_mouse_entered() -> void:
	audio_player.play()


func _on_discord_mouse_entered() -> void:
	audio_player.play()
