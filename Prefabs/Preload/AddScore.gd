extends Label
class_name AddScore

@export var lifetime : float = 5.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_label(amt : int):
	text = "+%d" % [amt];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos : Vector2 = position;
	pos.y -= 64.0 * delta;
	position = pos;
	lifetime -= delta;
	if lifetime <= 0.0:
		queue_free();
