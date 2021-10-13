extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

onready var cam2D = self

func start_shaker(duration=0.1,freq=15,ampl=2):
	self.amplitude = ampl
	$Duration.wait_time = duration
	$Frequency.wait_time = 1/float(freq)
	$Duration.start()
	$Frequency.start()
	do_shake()

onready var can_rotate = false
func start_rotate(duration=10,freq=15,ampl=2):
		"""self.amplitude = ampl
		$Duration.wait_time = duration
		$Frequency.wait_time = 1/float(freq)
		$Duration.start()
		$Frequency.start()
		do_rotate()
		"""
		can_rotate = true

	
func do_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	
	$ShakeTween.interpolate_property(cam2D,"offset",cam2D.offset,rand,$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()

func do_rotate():
	var rand = Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	$ShakeTween.interpolate_property(cam2D,"offset",Vector2(1,1),rand,10,EASE,EASE)
	$ShakeTween.start()
	
func _ready():
	#start()
	pass

var clockwise_rotation = false
func _process(delta):
	if can_rotate:
		if clockwise_rotation:
			rotation_degrees += delta
			if rotation_degrees > 7:
				clockwise_rotation = false
		else:
			rotation_degrees -= delta
			if rotation_degrees < -7:
				clockwise_rotation = true

func _reset():
	$ShakeTween.interpolate_property(cam2D,"offset",cam2D.offset,Vector2(),$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()
	
func _on_Frequency_timeout():
	do_shake()
	#pass

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
	
