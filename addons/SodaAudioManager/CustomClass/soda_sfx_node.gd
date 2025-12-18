class_name SodaSFX
extends AudioStreamPlayer

enum SodaSfxTypes { UI, GENERAL }
enum PitchVariation { SUBTLE, MODERATE, WIDE, EXTREME }

var current_type: SodaSfxTypes = SodaSfxTypes.GENERAL


func _ready() -> void:
	# Bind the cleanup to the AudioStreamPlayer finished signal.
	finished.connect(queue_free)


func get_type() -> SodaSfxTypes:
	return current_type


## New feature v1.3
## Chains a callable to be executed when a specific sound finishes.
## Returns self to allow further chaining if needed.
func when_is_finished(callback: Callable) -> SodaSFX:
	finished.connect(callback)
	return self


## New feature v1.3
## Sets the pitch scale of the sound effect.
## Pitch values are clamped between 0.1 and 3.0.
## Returns self to allow further chaining.
func set_pitch(pitch_scale_value: float) -> SodaSFX:
	pitch_scale = clamp(pitch_scale_value, 0.1, 3.0)
	return self


## New feature v1.3
## Applies random pitch variation around 1.0 based on the variation intensity.
## Variation options: SUBTLE (±0.05), MODERATE (±0.15), WIDE (±0.3), EXTREME (±0.5)
## Returns self to allow further chaining.
func randomize_pitch(variation: PitchVariation = PitchVariation.MODERATE) -> SodaSFX:
	var variation_amount: float

	match variation:
		PitchVariation.SUBTLE:
			variation_amount = 0.3
		PitchVariation.MODERATE:
			variation_amount = 0.5
		PitchVariation.WIDE:
			variation_amount = 1.0
		PitchVariation.EXTREME:
			variation_amount = 1.5
		_:
			variation_amount = 0.5 # Default to MODERATE

	pitch_scale = randf_range(1.0 - variation_amount, 1.0 + variation_amount)
	return self
