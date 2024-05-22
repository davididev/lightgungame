extends Node2D

@export var enemy_to_spawn : PackedScene;
@export var delay : float = 0.0;
var spawned = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawned == false:
		var check_x = global_position.x + 256.0;
		print("Check ", check_x, "vs ", Player.CurrentX)
		if Player.CurrentX > check_x:
			if delay > 0.0:
				delay -= delta;
			else:
				var instance = enemy_to_spawn.instantiate();
				instance.global_position = global_position;
				get_tree().root.get_node("Node2D").add_child(instance);
				spawned = true;
