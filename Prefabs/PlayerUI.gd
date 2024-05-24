extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(4);
	set_score(0);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_health(h : int):
	for n in range(0, 4, 1):
		#var format_string = "HealthBG/Unit%n";
		var actual_string = str("HealthBG/Unit", n);
		get_node(actual_string).visible = ((h-1) >= n);

func set_score(s : int):
	get_node("ScoreLabel").text = "Score: %010d" % [s]
