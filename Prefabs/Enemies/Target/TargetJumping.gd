extends RigidBody2D

@export var JumpForce = 400.0;
@export var PointsOnShoot = 1;
@export var TargetExplosion : PackedScene;

signal on_shot

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2.UP * JumpForce);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_on_shot():
	var instance = TargetExplosion.instantiate();
	instance.global_position = global_position;
	get_tree().root.get_node("Node2D").add_child(instance);
	queue_free()
	#TODO: Add particle system and points
