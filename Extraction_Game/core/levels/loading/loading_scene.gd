class_name LoadingScene
extends Control


var is_loaded: bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request(Globals.next_scene)
	

func _process(_delta: float) -> void:
	var progress: Array = []
	ResourceLoader.load_threaded_get_status(Globals.next_scene, progress)
	$ProgressBar.value = progress[0]*100
	
	if progress[0] == 1 and !is_loaded:
		#$Timer.start(1)
		#is_loaded = true
		var packed_scene: PackedScene = ResourceLoader.load_threaded_get(Globals.next_scene)
		System.log(Globals.next_scene)
		get_tree().change_scene_to_packed(packed_scene)
		
		
func _on_timer_timeout() -> void:
	pass
	#var packed_scene = ResourceLoader.load_threaded_get(Globals.next_scene)
	#get_tree().change_scene_to_packed(packed_scene)
