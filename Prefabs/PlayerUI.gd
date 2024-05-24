extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(6);
	set_score(0);
	test_health();

#Delete this coroutine later
func test_health():
	set_health(6);
	set_score(0);
	await get_tree().create_timer(2.0).timeout;
	set_health(5);
	set_score(2);
	await get_tree().create_timer(2.0).timeout;
	set_health(4);
	set_score(99);
	await get_tree().create_timer(2.0).timeout;
	set_health(3);
	set_score(120);
	await get_tree().create_timer(2.0).timeout;
	set_health(2);
	set_score(200);
	await get_tree().create_timer(2.0).timeout;
	set_health(1);
	set_score(4333);
	await get_tree().create_timer(2.0).timeout;
	set_health(0);
	set_score(54333);
	await get_tree().create_timer(2.0).timeout;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_health(h : int):
	for n in range(0, 6, 1):
		#var format_string = "HealthBG/Unit%n";
		var actual_string = str("HealthBG/Unit", n);
		get_node(actual_string).visible = ((h-1) >= n);

func set_score(s : int):
	get_node("ScoreLabel").text = "Score: %010d" % [s]
