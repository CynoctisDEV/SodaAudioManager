#---------- Soda Audio Manager ver 1.3 MIT license - Alexsander O. de Almeida(CyNoctis) ----------
extends Node

# ---------- SIGNALS ----------
signal fade_in_ended
signal fade_out_ended
signal music_stopped
signal music_started

# ---------- DECLARATIONS ----------
var music_volume: float = 0.0
var sfx_ui_volume: float = 0.0
var sfx_volume: float = 0.0
var music_mute_volume: float = -50.0
var current_music
# Constants

# Node Reference
@onready var music_player: AudioStreamPlayer = $music_player
@onready var container_sfx: Node = $container_sfx
@onready var effects_manager: Node = $effects_manager


# ---------- GODOT NATIVE FUNCTIONS ----------
func _ready() -> void:
	randomize() # needed for play_random_sfx


# ---------- MY FUNCTIONS ----------
# Music functions
func play_music(sound_path: String, loop: bool, fade: bool = true, fade_duration: float = 1.0) -> void:
	if sound_path == "":
		push_error("ERROR: The path to the music file cannot be an empty string.")
		return

	var sound = load(sound_path)
	if !sound:
		push_error("ERROR: The music load is failed. Please verify the path to file.")
		return
	if sound is AudioStreamOggVorbis or sound is AudioStreamMP3:
		sound.loop = loop
	else:
		push_warning("Looping is only available in .ogg and .mp3 files. This song will not loop after it finishes playing.")

	if current_music != sound:
		current_music = sound
		music_player.stream = sound
		match fade:
			true:
				music_player.volume_db = music_mute_volume
				effects_manager.fade_in(fade_duration)
			false:
				music_player.volume_db = music_volume
				music_player.play()
				emit_signal("music_started")
	else:
		push_warning("The selected song is already playing, nothing will be changed.")
		return


func pause_play_music() -> void:
	music_player.stream_paused = !music_player.stream_paused


func stop_music(fade: bool = true, fade_duration: float = 1.0) -> void:
	match fade:
		true:
			effects_manager.fade_out(fade_duration)
		false:
			music_player.stop()
			emit_signal("music_stopped")
			current_music = null


# SFX functions
func play_sfx(sound_path: String) -> SodaSFX:
	if sound_path == "":
		push_error("ERROR: The path to the sound sfx file cannot be an empty string.")
		return null

	var sound = load(sound_path)
	if !sound:
		push_error("ERROR: The sound sfx load is failed. Please verify the path to file.")
		return null

	var sfx: SodaSFX = SodaSFX.new()
	if !sfx:
		push_error("ERROR: Failed to instantiate SodaSFX node.")
		return null

	container_sfx.add_child(sfx)
	sfx.current_type = sfx.SodaSfxTypes.GENERAL
	sfx.stream = sound
	sfx.volume_db = sfx_volume
	sfx.play()

	return sfx # Return instance for chaining


func play_ui_sfx(sound_path: String) -> SodaSFX:
	if sound_path == "":
		push_error("ERROR: The path to the sound sfx file cannot be an empty string.")
		return null

	var sound = load(sound_path)
	if !sound:
		push_error("ERROR: The sound sfx load is failed. Please verify the path to file.")
		return null

	var sfx: SodaSFX = SodaSFX.new()
	if !sfx:
		push_error("ERROR: Failed to instantiate SodaSFX node.")
		return null

	container_sfx.add_child(sfx)
	sfx.current_type = sfx.SodaSfxTypes.UI
	sfx.stream = sound
	sfx.volume_db = sfx_ui_volume
	sfx.play()

	return sfx # Return instance for chaining


## New feature v1.3
## Plays a random music from an array of sound paths.
## Each music has an equal chance of being selected.
func play_random_music(sound_paths: Array[String], loop := false) -> void:
	if sound_paths.is_empty():
		push_error("ERROR: The sound paths array cannot be empty.")
		return

	var random_index = randi_range(0, sound_paths.size() - 1)
	var selected_path = sound_paths[random_index]

	return play_music(selected_path, loop)


## New feature v1.3
## Plays a random sound effect from an array of sound paths.
## Each sound has an equal chance of being selected.
## Returns the SodaSFX instance for chaining.
func play_random_sfx(sound_paths: Array[String]) -> SodaSFX:
	if sound_paths.is_empty():
		push_error("ERROR: The sound paths array cannot be empty.")
		return null

	var random_index = randi_range(0, sound_paths.size() - 1)
	var selected_path = sound_paths[random_index]

	return play_sfx(selected_path)


## New feature v1.3
## Plays a random UI sound effect from an array of sound paths.
## Each sound has an equal chance of being selected.
## Returns the SodaSFX instance for chaining.
func play_random_ui_sfx(sound_paths: Array[String]) -> SodaSFX:
	if sound_paths.is_empty():
		push_error("ERROR: The sound paths array cannot be empty.")
		return null

	var random_index = randi_range(0, sound_paths.size() - 1)
	var selected_path = sound_paths[random_index]

	return play_ui_sfx(selected_path)


# Update properties
func update_volume(music_volume_global: float, sfx_ui_volume_global: float, sfx_volume_global: float) -> void:
	music_volume = music_volume_global
	sfx_ui_volume = sfx_ui_volume_global
	sfx_volume = sfx_volume_global

	music_player.volume_db = music_volume
	var sfx_nodes = container_sfx.get_children()
	if !sfx_nodes:
		return
	for i in sfx_nodes:
		i as SodaSFX
		if i.current_type == i.SodaSfxTypes.UI:
			i.volume_db = sfx_ui_volume
		else:
			i.volume_db = sfx_volume

	sfx_nodes = null


# Plays a list of paths in order.
func play_sequence(paths: Array[String], is_ui: bool = false) -> void:
	if paths.is_empty():
		return

	var current_path = paths.pop_front()
	var sfx_instance: SodaSFX

	if is_ui:
		sfx_instance = play_ui_sfx(current_path)
	else:
		sfx_instance = play_sfx(current_path)

	if sfx_instance:
		# Using when_is_finished to recursively play the next sound when this one finishes
		sfx_instance.when_is_finished(func(): play_sequence(paths, is_ui))

#---------- Soda Audio Manager ver 1.3 MIT license - Alexsander O. de Almeida(CyNoctis) ----------
