extends Sprite2D
class_name VFXSprite

var playing:bool = false

signal expire
func _expire() -> void:
	playing = false
	expire.emit()

func stop() -> void:
	playing = false

func play(s: VFX.Subframes, loops:int = 1) -> void:
	assert(not playing)
	playing = true
	while playing:
		for i in range(s.end - s.start + 1):
			frame = s.start + i
			await get_tree().create_timer(1.0/s.rate).timeout
			if not playing:
				break
		loops -= 1
		if not playing:
			break
		playing = loops != 0 #therefore negative numbers loop infinitely
	_expire()

func _ready() -> void:
	hframes = texture.get_size().x / texture.get_size().y
