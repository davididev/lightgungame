extends Area2D

const SCALE_PER_SECOND : float = 0.5;
var lifetime : float = 0.2;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite2D").rotation = randf_range(0.0, 360.0);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var my_scale = scale;
	my_scale += Vector2.ONE * SCALE_PER_SECOND * delta;
	scale = my_scale;
	lifetime -= delta;
	if lifetime <= 0.0:
		queue_free()



func _on_body_entered(body):
	var e : Error = body.emit_signal("on_shot")
	#if e != @GlobalScope.ERR_UNAVAILABLE:
		#  This is how to do error checking in the future
	pass # Replace with function body.
