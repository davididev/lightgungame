extends Area2D

const SCALE_PER_SECOND : float = 2.0;
@export var anim : AnimatedSprite2D;
@export var lifetime : float = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play(&"main");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta;
	if lifetime <= 0.0:
		queue_free()



func _on_body_entered(body):
	var e : Error = body.emit_signal("on_shot");
	#if e != @GlobalScope.ERR_UNAVAILABLE:
		#  This is how to do error checking in the future
	pass # Replace with function body.
