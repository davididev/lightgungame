extends Area2D

const SCALE_PER_SECOND : float = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite2D").rotation = randf_range(0.0, 360.0);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var my_scale = scale;
	my_scale.x = move_toward(my_scale.x, 0.0, delta * SCALE_PER_SECOND)
	my_scale.y = move_toward(my_scale.y, 0.0, delta * SCALE_PER_SECOND)
	if my_scale.x == 0.0:
		queue_free()
	else:
		scale = my_scale;



func _on_body_entered(body):
	var e : Error = body.emit_signal("on_shot")
	#if e != @GlobalScope.ERR_UNAVAILABLE:
		#  This is how to do error checking in the future
	pass # Replace with function body.
