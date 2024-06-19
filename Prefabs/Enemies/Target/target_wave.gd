extends RigidBody2D
@export var PointsOnShoot = 1;
@export var TargetExplosion : PackedScene;
@export var DegreesPerSecond : float = 180.0;
@export var WaveHeight : float = 128.0;
@export var MoveXPerSecond : float = 256.0;

var current_degrees = 0.0;

signal on_shot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var begun = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if begun:
		var current_rad = deg_to_rad(current_degrees);
		var vel : Vector2;
		vel.x = -MoveXPerSecond;
		vel.y = cos(current_rad) * WaveHeight;
		linear_velocity = vel;
		current_degrees += DegreesPerSecond * delta;
		if current_degrees > 360.0:
			current_degrees -= 360.0;
	


func _on_visible_on_screen_notifier_2d_screen_entered():
	begun = true;


func _on_visible_on_screen_notifier_2d_screen_exited():
	if begun:  #Don't delete it unless it has started to move
		queue_free();


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
