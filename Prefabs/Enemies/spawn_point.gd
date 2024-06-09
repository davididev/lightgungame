extends Node2D

@export var enemy_to_spawn : Array[SpawnListEntry];
@export var delay : float = 0.0;
@export var use_anim : bool = false;
@export var use_sound : bool = false;
@export var possible_animation_ref : AnimatedSprite2D;
@export var animation_name : StringName;
@export var sound_name : String;
@export var spawn_location : Node2D;
var spawned = false;
var visible_triggered = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_made_visible():
	visible_triggered = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawned == false:
		var check_x = global_position.x + 256.0;
		#print("Check ", check_x, "vs ", Player.CurrentX)
		if visible_triggered:
			if delay > 0.0:
				delay -= delta;
			else:
				if use_anim:
					possible_animation_ref.play(animation_name);
					
				if use_sound:
					SoundFX.PlaySound(sound_name, get_tree(), global_position);
				SpawnRoutine();
				spawned = true;

func SpawnRoutine():
	for entry in enemy_to_spawn:
		await get_tree().create_timer(entry.spawn_delay).timeout
		var instance = entry.prefab.instantiate();
		instance.global_position = spawn_location.global_position + entry.offset;
		get_tree().root.get_node("Node2D").add_child(instance);
