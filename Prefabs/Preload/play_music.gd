extends Node2D
class_name PlayMusic;
static var Init_Count = 0;
static var Instance : PlayMusic = null;
@export var ref : AudioStreamPlayer2D;
var last_song : String = "";
# Called when the node enters the scene tree for the first time.
func _ready():
	Instance = self;

static func PlaySong(song_name : String, t : SceneTree):
	if Instance == null:
		Init_Count += 1;
		if Init_Count > 3:
			print("Error creating the PlayMusic node");
			return;
		var instance2 = preload("res://Prefabs/Preload/play_music.tscn").instantiate();
		t.get_root().add_child(instance2);  #Make it global
		await t.create_timer(0.05).timeout;
		PlayMusic.PlaySong(song_name, t);
		return;
	if Instance.last_song == song_name:  #Tried to play the same one, don't process
		return;
	var asset_name : String = str("res://Audio/Music/", song_name, ".wav");
	Instance.ref.stream = load(asset_name);
	Instance.ref.play();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ref.playing == false:
		ref.play();	
	var pos = global_position;
	pos.x = Player.CameraX;
	global_position = pos;
