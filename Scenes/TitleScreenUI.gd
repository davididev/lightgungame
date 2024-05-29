extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.Score = 0;  #Reset score when we go to the beginning of the game, may be reloaded later
	PlayMusic.PlaySong("Title", get_tree());

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_quit_button_down():
	get_tree().quit();


func _on_button_test_level_1_button_down():
	get_tree().change_scene_to_file("res://Scenes/Bonus1.tscn");


func _on_button_test_level_2_button_down():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn");
