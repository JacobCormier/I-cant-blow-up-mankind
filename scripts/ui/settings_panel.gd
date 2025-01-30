extends Panel

@onready var mute_all: CheckBox = $Panel/SubTitle/MuteAll
@onready var mute_music: CheckBox = $Panel/SubTitle/MuteMusic
@onready var fx_volume: HSlider = $Panel/SubTitle/FXVolume
@onready var music_volume: HSlider = $Panel/SubTitle/MusicVolume
@onready var master_volume: HSlider = $Panel/SubTitle/MasterVolume

func _ready() -> void:
	load_settings()  # Load saved settings at start

	# Connect signals to update settings when changed
	mute_all.toggled.connect(_on_mute_all_toggled)
	mute_music.toggled.connect(_on_mute_music_toggled)
	master_volume.value_changed.connect(_on_master_volume_value_changed)
	music_volume.value_changed.connect(_on_music_volume_value_changed)
	fx_volume.value_changed.connect(_on_fx_volume_value_changed)

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_settings()

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	save_settings()

func _on_fx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FX"), linear_to_db(value))
	save_settings()

func _on_mute_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)
	save_settings()

func _on_mute_all_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
	save_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	
	config.set_value("audio", "mute_all", mute_all.button_pressed)
	config.set_value("audio", "mute_music", mute_music.button_pressed)
	config.set_value("audio", "master_volume", master_volume.value)
	config.set_value("audio", "music_volume", music_volume.value)
	config.set_value("audio", "fx_volume", fx_volume.value)

	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	var settings_exist = config.load("user://settings.cfg") == OK

	# If settings do not exist, set default values
	var default_master = 0.8
	var default_music = 0.8
	var default_fx = 0.7
	var default_mute_all = false
	var default_mute_music = false

	var master_value = config.get_value("audio", "master_volume", default_master)
	var music_value = config.get_value("audio", "music_volume", default_music)
	var fx_value = config.get_value("audio", "fx_volume", default_fx)
	var mute_all_value = config.get_value("audio", "mute_all", default_mute_all)
	var mute_music_value = config.get_value("audio", "mute_music", default_mute_music)

	# Apply settings to UI
	master_volume.value = master_value
	music_volume.value = music_value
	fx_volume.value = fx_value
	mute_all.button_pressed = mute_all_value
	mute_music.button_pressed = mute_music_value

	# Apply settings to AudioServer
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute_all_value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), mute_music_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FX"), linear_to_db(fx_value))

	# If it's the first run, save default settings to file
	if not settings_exist:
		save_settings()
