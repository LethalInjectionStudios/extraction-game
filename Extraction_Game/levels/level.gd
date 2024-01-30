class_name Level
extends Node2D

@onready var player : Character = $Player
@onready var audio_listener : AudioListener2D = $AudioListener


func _ready():
	for weapon in get_tree().get_nodes_in_group("Weapon"):
		weapon.connect("weapon_fired", _on_weapon_fired)
		
	for poi in get_tree().get_nodes_in_group("POI"):
		poi.connect("poi_created", _on_poi_created)


func _process(_delta):
	pass
	
	
func _on_weapon_fired(projectile) -> void:
	$Projectiles.add_child(projectile)
	

func _on_poi_created(poi) -> void:
	$POI.add_child(poi)
