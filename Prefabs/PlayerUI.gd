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
	set_forcefield_perc(0.0);
	await get_tree().create_timer(2.0).timeout;
	set_health(5);
	set_score(2);
	set_forcefield_perc(0.1);
	await get_tree().create_timer(2.0).timeout;
	set_health(4);
	set_score(99);
	set_forcefield_perc(0.2);
	await get_tree().create_timer(2.0).timeout;
	set_health(3);
	set_score(120);
	set_forcefield_perc(0.3);
	await get_tree().create_timer(2.0).timeout;
	set_health(2);
	set_score(200);
	set_forcefield_perc(0.4);
	await get_tree().create_timer(2.0).timeout;
	set_health(1);
	set_score(4333);
	set_forcefield_perc(0.5);
	await get_tree().create_timer(2.0).timeout;
	set_health(0);
	set_score(54333);
	set_forcefield_perc(0.6);
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


func set_forcefield_perc(perc : float):
	if perc == 0.0:
		get_node("ForcefieldChargeBG/ForcefieldChargeFG").visible = false;
	else:
		get_node("ForcefieldChargeBG/ForcefieldChargeFG").visible = true;
	var s = get_node("ForcefieldChargeBG/ForcefieldChargeFG").size;
	s.x = 180.0 * perc;
	get_node("ForcefieldChargeBG/ForcefieldChargeFG").size = s;
