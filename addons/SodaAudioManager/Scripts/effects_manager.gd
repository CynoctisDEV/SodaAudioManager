#---------- Soda Audio Manager ver 1.3 MIT license - Alexsander O. de Almeida(CyNoctis) ----------
extends Node

# ---------- DECLARATIONS ----------
# General Var

# Constants

# Node Reference
@onready var root_audio_manager: Node = get_parent()
@onready var music_player: AudioStreamPlayer = $"../music_player"
# ---------- SIGNALS ----------

# ---------- GODOT NATIVE FUNCTIONS ----------


# ---------- MY FUNCTIONS ----------
func fade_in(fade_duration: float):
	var tween = create_tween()
	music_player.play()
	tween.tween_property(music_player, "volume_db", root_audio_manager.music_volume, fade_duration)
	await tween.finished
	root_audio_manager.emit_signal("fade_in_ended")
	root_audio_manager.emit_signal("music_started")
	tween = null


func fade_out(fade_duration: float):
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", root_audio_manager.music_volume, fade_duration)
	await tween.finished
	music_player.stop()
	root_audio_manager.emit_signal("fade_out_ended")
	root_audio_manager.emit_signal("music_stopped")
	tween = null
	root_audio_manager.current_music = null

#---------- Soda Audio Manager ver 1.3 MIT license - Alexsander O. de Almeida(CyNoctis) ----------
