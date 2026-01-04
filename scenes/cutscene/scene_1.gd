extends BaseCutscene

var textures : Array[TextureRect]
var texture_index = -1

@export var textureContainer : Node2D
@export var whiteFade : TextureRect
@export var blackFade : TextureRect
func _init() -> void:
	super._init(&"scene_1")
	
func _init_textures(): #grabs all textures in the texture container
	for child in textureContainer.get_children():
		if child is TextureRect:
			child.visible = false
			textures.append(child)

func next(fadeInTime :float = 0.5) -> Signal:
	texture_index+=1
	var tx = textures[texture_index]
	tx.visible = true
	tx.modulate.a = 0
	var twn :Tween = get_tree().create_tween()
	twn.tween_property(tx, "modulate:a", 1, fadeInTime)
	return twn.finished
	
func fadeIn(fadeTime, black : bool = false)->Signal:
	var tx = blackFade if black else whiteFade
	tx.modulate.a = 1
	var twn :Tween = get_tree().create_tween()
	twn.tween_property(tx, "modulate:a", 0, fadeTime)
	return twn.finished
	
func fadeOut(fadeTime, black : bool = false)->Signal:
	var tx = blackFade if black else whiteFade
	tx.modulate.a = 0
	var twn :Tween = get_tree().create_tween()
	twn.tween_property(tx, "modulate:a", 1, fadeTime)
	return twn.finished

func wait_for_seconds(time : float)->Signal:
	return get_tree().create_timer(time).timeout

func moveContainer(x : float, y: float, scale : float, time :float = 0)->Signal:
	#moving the background container instead of the camera since the camera is global and not per-scene.
	var twn :Tween = get_tree().create_tween()
	twn.set_parallel(true)
	twn.tween_property(textureContainer, "position", Vector2(x, y), time)
	twn.tween_property(textureContainer, "scale",  Vector2(scale, scale), time)
	return twn.finished

func camZoomShake(initScale, zoomedScale):
	#zooming the texture instead of the camera due to pivot issues; this is pretty makeshift
	var twn :Tween = get_tree().create_tween()
	var obj = textures[texture_index]
	twn.set_trans(Tween.TRANS_QUAD)
	twn.tween_property(obj, "scale",  Vector2(zoomedScale, zoomedScale), 0.1)
	twn.tween_property(obj, "scale",  Vector2(initScale, initScale), 0.1)
	twn.tween_property(obj, "scale",  Vector2(zoomedScale, zoomedScale), 0.1)
	twn.tween_property(obj, "scale",  Vector2(initScale, initScale), 0.1)
	twn.tween_property(obj, "scale",  Vector2(zoomedScale, zoomedScale), 0.1)
	twn.tween_property(obj, "scale",  Vector2(initScale, initScale), 0.1)
	return twn.finished

func start_cutscene() -> void:
	is_cutscene_started = true
	_init_textures()
	await moveContainer(-433, 0 , 1, 0)
	await next(1) #show 1-1
	await wait_for_seconds(3)
	moveContainer(0, 0, 1, 1)	
	
	#TODO: play click/keyboard sfx
	await next(1) #show 1-2
	await wait_for_seconds(3)
	
	await fadeOut(0.5)
	await next(0) #show 2-1
	await fadeIn(0.5)
	await wait_for_seconds(1.5)
	await next() #show 2-2
	await wait_for_seconds(1.5)
	await next() #show 2-3
	await wait_for_seconds(3.5)
	
	await next() #show 3-1
	await wait_for_seconds(5.5)
	
	await fadeOut(2,true)
	await moveContainer(-1429.0, 101, 1.7, 0)
	await next(0)  #show 4-1
	await fadeIn(1,true)
	await wait_for_seconds(3)
	
	moveContainer(-1429.0, -822, 1.7, 1)
	#TODO: play 
	await next(1)#show 4-2
	await wait_for_seconds(3)
	#TODO: play water splash sfx 2
	await next()#show 4-3
	await wait_for_seconds(1)
	moveContainer(0, 0, 1, 1)
	await next(1)#show 4-4
	await wait_for_seconds(1.5)
	await next()#show 4-5
	await wait_for_seconds(1.5)
	await next()#show 4-6
	await wait_for_seconds(3)
	
	#TODO: play water splash sfx 3
	await fadeOut(0.05, false) #flash white
	await fadeIn(0.0, false)
	await wait_for_seconds(0.05)
	await fadeOut(0.05, true)  #flash black
	await fadeIn(0, true)
	await wait_for_seconds(0.05)
	await fadeOut(0.05, true)  #go black
	await moveContainer(-1000, -449, 2.25, 0)
	await wait_for_seconds(1)
	await next(0)#show 5-1
	await fadeIn(0.0, true)
	
	#TODO: play roar sfx
	await camZoomShake(1, 1.1)
	
	await wait_for_seconds(0.1)
	await moveContainer(0, 0, 1, 1)
	await wait_for_seconds(5.5)
	await fadeOut(2, true)
	
	await fadeIn(0, false) #resetting this, unsure if this is necessary 
	await fadeIn(0, true)
	stop_cutscene()
	
