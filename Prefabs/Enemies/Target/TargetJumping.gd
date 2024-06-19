extends RigidBody2D

@export var JumpForce = 400.0;
@export var PointsOnShoot = 1;
@export var TargetExplosion : PackedScene;

signal on_shot

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2.UP * JumpForce);
	#test_damage();
	pass # Replace with function body.
	
func test_damage():
	await get_tree().create_timer(2.0).timeout;
	Player.Damage(1);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_on_shot():
	if visible == false:
		return;
	var instance = TargetExplosion.instantiate();
	instance.global_position = global_position;
	get_tree().root.get_node("Node2D").add_child(instance);
	SaveData.Score += PointsOnShoot;
	var instance2 : AddScore = preload("res://Prefabs/Preload/AddScore.tscn").instantiate();
	instance2.set_label(PointsOnShoot);
	instance2.global_position = global_position;
	get_tree().root.get_node("Node2D").add_child(instance2);
	queue_free()
	#TODO: Add particle system and points
