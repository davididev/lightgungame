extends RigidBody2D

@export var ColorStr = "[color=green]";
@export var points = 1;
@export var MoveLeftVelocity = 180.0;
@export var ShatterPrefab : PackedScene;
var has_been_shot_timer = -10.0;
signal on_shot;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetRigidText(s : String):
	get_node("RigidText/CollisionShape2D/RichTextLabel").text = str(ColorStr, s);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_been_shot_timer < 0.0:
		linear_velocity = Vector2(-MoveLeftVelocity, 0.0);
		var v = global_position + Vector2(232.0, 0.0);
		var rigid : RigidBody2D = get_node("RigidText");
		rigid.global_position = v;
		rigid.sleeping = true;
	else:
		linear_velocity = Vector2.ZERO;
		has_been_shot_timer -= delta;
		if has_been_shot_timer < 0.0:
			queue_free();

func _on_on_shot():
	if has_been_shot_timer < 0.0:
		has_been_shot_timer = 5.0;
		var rigid : RigidBody2D = get_node("RigidText");
		rigid.sleeping  = false;
		rigid.apply_impulse(Vector2(0.0, 90.0));
		get_node("CollisionShape2D/Sprite2D").visible = false;
		var instance = ShatterPrefab.instantiate();
		instance.global_position = global_position;
		get_tree().root.get_node("Node2D").add_child(instance);
		SaveData.Score += points;
		var instance2 : AddScore = preload("res://Prefabs/Preload/AddScore.tscn").instantiate();
		instance2.set_label(points);
		instance2.global_position = global_position;
		get_tree().root.get_node("Node2D").add_child(instance2);
