extends Node2D
class_name SoundFX;

@export var ref : NodePath;
static var ref_instance = preload("res://Prefabs/Preload/play_sound_fx.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
"ref"
static func PlaySound(file_name : String, t : SceneTree, pos : Vector2):
	var instance : SoundFX = ref_instance.instantiate(); 
	instance.global_position = pos;
	t.root.add_child(instance);
	var asset_name : String = str("res://Audio/Sound/", file_name, ".wav");
	instance.get_node(instance.ref).stream = load(asset_name);
	instance.get_node(instance.ref).play();
	instance.play_sound_routine();

func play_sound_routine():
	await get_tree().create_timer(0.05).timeout;
	while get_node(ref).playing == true:
		await get_tree().create_timer(0.05).timeout;
	
	queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
