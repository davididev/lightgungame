extends Node2D
class_name SceneVars
@export var steps : Array[LevelStep]
@export var song_name : String = "Bonus"; 

static var MoveSpeed = 32.0;
var current_step = -1;
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayMusic.PlaySong(song_name, get_tree());

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_x = Player.CameraX;
	for n in range(steps.size() - 1, current_step, -1):  #Max to 0
		#print("Current ", n, ": ", current_x, " vs", steps[n].ending_x)
		if current_x > steps[n].ending_x:  #Finished current step
			current_step = n;
			break;
		else:
			SceneVars.MoveSpeed = steps[n].horizontal_speed
	
