extends Node2D
class_name SceneVars
@export var steps : Array[LevelStep]
@export var song_name : String = "Bonus"; 
@export var ending_x = 6400.0;
@export var next_scene = "Level1";
@export var checkpoint = false;

static var MoveSpeed = 32.0;
static var EndedLevel : bool = false;
static var FreezeMovement : bool = false;  #Should be called for the tutorial and end of level
var current_step = -1;
# Called when the node enters the scene tree for the first time.
func _ready():
	EndedLevel = false;
	PlayMusic.PlaySong(song_name, get_tree());
	if checkpoint:
		SaveData.CheckpointLevel = SaveData.CurrentLevel;

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
	
	if current_x > ending_x:
		SaveData.CurrentLevel = next_scene;
		SavaData.SaveFile();
		EndedLevel = true;
		FreezeMovement = true; 
		
