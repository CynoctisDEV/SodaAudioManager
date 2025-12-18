# Soda AudioManager 1.3

*Plugin created and tested exclusively on Godot 4.5.1 (stable)*
*Created by Alexsander Oliveira de Almeida(CyNoctis)*


## Changes from version 1.3
- Some code was reordered / renamed to improve clarity and understandability.
- Typos in several words `properties`, `music_stopped`, `license` 
- Added `play_random_music`, `play_random_sfx()` and `play_random_ui_sfx()` methods for random sound selection
- added `.when_is_finished` functionality to execute code post finishing a sound
- added `.play_sequence` functionality to run several sounds in sequence
- Added pitch shifting capabilities with `set_pitch()` method
- Added random pitch variation with `randomize_pitch()` method and `PitchVariation` enum
- Some new methods support chaining for flexible sound manipulation

## Overview

Soda AudioManager is a global plugin for Godot, designed to handle non-spatial sounds, including interface sound effects, background music, and general sound effects. It offers an easy way to manage audio playback, control volumes, apply sound effects, and configure looping.

---

## Installation

### Step 1: Download

- Download the plugin package.
- Extract the contents to a local directory.

### Step 2: Install and Activate

1. Copy the `addons` folder to your project’s root directory.
2. Open your Godot project.
3. Go to **Project -> Project Settings -> Plugins**.
4. Locate the "SodaAudioManager" plugin and enable it by checking the box.

---

## Usage Guide

To use the plugin, call its functions in your scripts whenever you need to play, stop, or pause audio.

### Music Functions

```gdscript
SodaAudioManager.play_music(soundPath: String, loop: bool, fade: bool = false, fade_duration: float = 1.0)
```

*Plays background music from a specified file.*

- **soundPath:** Path to the audio file as a string (e.g., "res://path/to/music.ogg").
- **loop:** Determines if the music loops (true/false). Only .ogg and .mp3 formats support looping; .wav files are not supported.
- **fade:** Enables a fade-in effect when starting the audio.
- **fade_duration:** Sets the fade-in duration in seconds (default is 1.0).

```gdscript
SodaAudioManager.pause_play_music()
```

*Pauses or resumes the currently playing music.*

```gdscript
SodaAudioManager.stop_music(fade: bool, fade_duration: float = 1.0)
```

*Stops the currently playing music.*

- **fade:** If true, applies a fade-out effect before stopping.
- **fade_duration:** Sets the fade-out duration in seconds (default is 1.0).

#### Random Music Selection (New in v1.3)

```gdscript
SodaAudioManager.play_random_music(soundPathArray: Array[String], loop: bool)
```

*Randomly selects and plays one background music from an array of sound paths.*

- **soundPathArray:** Array of paths to audio files
- **loop:** Determines if the music loops (true/false). Only .ogg and .mp3 formats support looping; .wav files are not supported.

**Note: the loop flag will keep the selected music going (it will `NOT` randomly choose another)**

### Sound Effects (SFX)

#### Interface SFX

```gdscript
SodaAudioManager.play_ui_sfx(soundPath: String)
```

*Plays interface sound effects.*

- **soundPath:** Path to the audio file as a string.

#### General SFX

```gdscript
SodaAudioManager.play_sfx(soundPath: String)
```

*Plays general sound effects.*

- **soundPath:** Path to the audio file as a string.

```gdscript
SodaAudioManager.update_volume(MusicVolumeGlobal: float, sfxUiVolumeGlobal: float, sfxVolumeGlobal: float)
```

*Updates the volume of the plugin's audio players.*


#### When is finished


```gdscript
SodaAudioManager.play_sfx(soundPath: String).when_is_finished(func():
  print("The explosion sound finished")
)
```

- **soundPath:** Path to the audio file as a string.

*Allows the user tu run arbitrary code after a SFX is finished*

#### Sound Sequencing

```gdscript
SodaAudioManager.play_sequence(soundPathArray: Array[String], is_ui: bool)
```

- **soundPathArray:** Array of paths to the audio files
- **is_ui:** optional parameter to determine if the sequence of sounds is SFX or UI

For example:

```gdscript
SodaAudioManager.play_sequence(["res://A.wav", "res://B.wav", "res://C.wav"])
```

*Plays A, then waits for finish, then plays B, then C.*

#### Random Sound Selection (New in v1.3)

```gdscript
SodaAudioManager.play_random_sfx(soundPathArray: Array[String])
```

*Randomly selects and plays one sound effect from an array of sound paths.*

- **soundPathArray:** Array of paths to sound effect files
- Returns a SodaSFX instance for chaining

```gdscript
SodaAudioManager.play_random_ui_sfx(soundPathArray: Array[String])
```

*Randomly selects and plays one UI sound effect from an array of sound paths.*

- **soundPathArray:** Array of paths to UI sound effect files
- Returns a SodaSFX instance for chaining

**Example:**

```gdscript
# Play a random hit sound from a collection
var hit_sounds = ["res://hit1.wav", "res://hit2.wav", "res://hit3.wav"]
SodaAudioManager.play_random_sfx(hit_sounds)

# Random UI click sound
var click_sounds = ["res://click1.wav", "res://click2.wav"]
SodaAudioManager.play_random_ui_sfx(click_sounds)
```

#### Pitch Shifting (New in v1.3)

The `SodaSFX` class now supports pitch manipulation through chainable methods:

**Set Pitch (Manual Control)**

```gdscript
.set_pitch(pitch_scale: float) -> SodaSFX
```

*Sets the pitch scale of the sound effect.*

- **pitch_scale:** Pitch multiplier (0.1 to 3.0). Values are clamped to this range.
  - 0.5 = half speed (one octave down)
  - 1.0 = normal speed
  - 2.0 = double speed (one octave up)
- Returns self for chaining

**Random Pitch Variation**

```gdscript
.randomize_pitch(variation: SodaSFX.PitchVariation = MODERATE) -> SodaSFX
```

*Applies random pitch variation around 1.0 (normal pitch).*

- **variation:** Intensity of pitch randomization (defaults to MODERATE)
  - `SodaSFX.PitchVariation.SUBTLE` - ±0.05 (0.95 to 1.05)
  - `SodaSFX.PitchVariation.MODERATE` - ±0.15 (0.85 to 1.15)
  - `SodaSFX.PitchVariation.WIDE` - ±0.3 (0.7 to 1.3)
  - `SodaSFX.PitchVariation.EXTREME` - ±0.5 (0.5 to 1.5)
- Returns self for chaining

**Examples:**

```gdscript
# Slow motion explosion effect
SodaAudioManager.play_sfx("res://explosion.wav").set_pitch(0.5)

# Speed up UI sound
SodaAudioManager.play_ui_sfx("res://whoosh.wav").set_pitch(1.8)

# Add subtle pitch variation to footsteps for realism
SodaAudioManager.play_sfx("res://footstep.wav").randomize_pitch(SodaSFX.PitchVariation.SUBTLE)

# Random hit sound with random pitch variation
var hit_sounds = ["res://hit1.wav", "res://hit2.wav", "res://hit3.wav"]
SodaAudioManager.play_random_sfx(hit_sounds).randomize_pitch()

# Full chain: random sound, pitch shift and callback
SodaAudioManager.play_random_sfx(["res://hit1.wav", "res://hit2.wav"]).randomize_pitch(1.2).when_is_finished(func(): 
	print("Hit sound finished!")
)

# Random sound then executing series of actions
SodaAudioManager.play_random_sfx(["res://yeah.mp3", "res://ok.wav"]).when_is_finished(
  func():
    print("Something, something...")
    print("Dark, side!")
)

# Extreme pitch variation for comedic effect
SodaAudioManager.play_ui_sfx("res://boing.wav").randomize_pitch(SodaSFX.PitchVariation.EXTREME)
```

---

## Tips for Integration

If your game uses a configuration system with settings stored in a file, integrating it with `SodaAudioManager` is simple. Just call the update_volume() function and pass it the volume parameters from your global configuration node or from your game's interface buttons. Below I show an example where you store your game's volume values in a global script called **GlobalConfig**

**Example:**

```gdscript
SodaAudioManager.update_volume(GlobalConfig.musicVolume, GlobalConfig.uiVolume, GlobalConfig.sfxVolume)
```

This ensures consistency with your game’s audio settings.


---

## Feedback and Contributions

Questions, suggestions, and contributions to improve this plugin are always welcome! Feel free to open discussions and submit issues or pull requests on GitHub!