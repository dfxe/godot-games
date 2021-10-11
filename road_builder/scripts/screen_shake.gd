extends Node

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
	

func do_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	
	$ShakeTween.interpolate_property(cam2D,"offset",cam2D.offset,rand,$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()
	
	
func _ready():
	#start()
	pass

func _reset():
	$ShakeTween.interpolate_property(cam2D,"offset",cam2D.offset,Vector2(),$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()
	
func _on_Frequency_timeout():
	do_shake()
	#pass

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
	
