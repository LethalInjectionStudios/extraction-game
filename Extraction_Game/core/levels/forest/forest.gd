class_name Forest
extends Level

@export var point_of_interests: Node2D
@export var extraction_points: Node2D
@export var tilemap: Node2D
@export var scenery: Node2D

const EXTRACTION: PackedScene = preload("res://core/common/extraction.tscn")
const MAP_SIZE: Vector2 = Vector2(256, 256)
const LAND_CAP: float = .05
const SCENERY_OBJECTS_COUNT: int = 10000
const SCENERY_OPTIONS: Array[PackedScene] = [
			preload("res://core/levels/forest/objects/forest_tree_01.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_02.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_03.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_04.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_05.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_06.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_07.tscn"),
			preload("res://core/levels/forest/objects/forest_tree_08.tscn"),
			preload("res://core/levels/forest/objects/rock_01.tscn"),
			preload("res://core/levels/forest/objects/bush_01.tscn"),
			preload("res://core/levels/forest/objects/bush_02.tscn"),
			preload("res://core/levels/forest/objects/bush_03.tscn"),
			preload("res://core/levels/forest/objects/bush_04.tscn")
		]
				
const POI_OPTIONS: Array[PackedScene] = [
			preload("res://core/levels/forest/poi/army_camp.tscn")
		]

func _ready() -> void:
	super._ready()
	generate_world()
	audio_listener.make_current()
	_connect_signals()
	

func _connect_signals() -> void:
	super._connect_signals()


func _process(_delta: float) -> void:
	audio_listener.global_position = _player.global_position


func generate_world() -> void:
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi()
	
	var cells: Array[Vector2] = []
	
	for x: float in MAP_SIZE.x:
		for y: float in MAP_SIZE.y:
			var a: float = noise.get_noise_2d(x, y)
			if a <= LAND_CAP:
				cells.append(Vector2(x,y))
			else:
				tilemap.set_cell(0, Vector2(x, y), 2, Vector2(randi_range(0,8), 7), 0)
				
	tilemap.set_cells_terrain_connect(0, cells, 0, 0)

	for i: int in range(SCENERY_OBJECTS_COUNT):
		var scenery_instance: Scenery = SCENERY_OPTIONS[randi_range(0, SCENERY_OPTIONS.size() - 1)].instantiate() as Scenery
		scenery_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(scenery_instance)
		scenery_instance.calculate_z_index(scenery_instance.global_position.y)

	var poi_instance: POI = POI_OPTIONS[0].instantiate() as POI
	poi_instance.position = Vector2(1000,1000)
	point_of_interests.add_child(poi_instance)

	#var poi_instance2: POI = preload(poi2).instantiate() as POI
	#poi_instance2.position = Vector2(1000,1000)
	#point_of_interests.add_child(poi_instance2)
	
	var extraction_point: Extraction = EXTRACTION.instantiate() as Extraction
	extraction_point.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
	extraction_points.add_child(extraction_point)
