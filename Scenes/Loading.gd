extends Node2D
var resource_name;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CanvasLayer/Header").text = str("[center]Loading:\n", SaveData.CurrentLevel);
	resource_name = str("res://Scenes/", SaveData.CurrentLevel, ".tscn")
	ResourceLoader.load_threaded_request(resource_name);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = [];
	var status = ResourceLoader.load_threaded_get_status(resource_name, progress);
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		
		var percentage = round(progress[0] * 100.0);
		get_node("CanvasLayer/PerctangeText").text = str(percentage, "%")
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(resource_name));
