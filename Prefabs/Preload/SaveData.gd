extends Node
class_name SavaData

static var File_ID = 0;

static var FileName : String = "NIL";
static var CurrentLevel : String = "Bonus1";
static var Score : int = 0;
static var Continues : int = 3;
static var Ammo1 : int = 0;
static var Ammo2 : int = 0;
static var Ammo3 : int = 0;
static var VolumeMaster : float = 1.0;
static var VolumeMusic : float = 1.0;
static var VolumeSound : float = 1.0;

static func NewFile(id : int):
	CurrentLevel = "Bonus1";
	FileName = "NIL";
	File_ID = id;
	Score = 0;
	Continues = 3;
	Ammo1 = 0;
	Ammo2 = 0;
	Ammo3 = 0;
	VolumeMaster = 1.0;
	VolumeMusic = 1.0;
	VolumeSound = 1.0;
	
static func SaveFile():
	var config = ConfigFile.new();
	config.set_value("Main", "FileName", FileName);
	config.set_value("Main", "CurrentLevel", CurrentLevel);
	config.set_value("Main", "Score", Score);
	config.set_value("Main", "Continues", Continues);
	config.set_value("Main", "Ammo1", Ammo1);
	config.set_value("Main", "Ammo2", Ammo2);
	config.set_value("Main", "Ammo3", Ammo3);
	config.set_value("Main", "VolumeMaster", VolumeMaster);
	config.set_value("Main", "VolumeMusic", VolumeMusic);
	config.set_value("Main", "VolumeSound", VolumeSound);
	var fileName = str("user://file", File_ID, ".cfg");
	config.save(fileName);

static func LoadFile():
	var fileName = str("user://file", File_ID, ".cfg");
	var config = ConfigFile.new();
	var err = config.load(fileName);
	if err != OK:  #No file, return
		NewFile(File_ID);
		return false;  
	for sec in config.get_sections():  #There's really only one section, but no get_section function
		FileName = config.get_value(sec, "FileName");
		CurrentLevel = config.get_value(sec, "CurrentLevel");
		Score = config.get_value(sec, "Score");
		Continues = config.get_value(sec, "Continues");
		Ammo1 = config.get_value(sec, "Ammo1");
		Ammo2 = config.get_value(sec, "Ammo2");
		Ammo3 = config.get_value(sec, "Ammo3");
		VolumeMaster = config.get_value(sec, "VolumeMaster");
		VolumeMusic = config.get_value(sec, "VolumeMusic");
		VolumeSound = config.get_value(sec, "VolumeSound");
	
	return true;	
