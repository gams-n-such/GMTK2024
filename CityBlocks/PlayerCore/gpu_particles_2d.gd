extends GPUParticles2D
var time=0.1;
@export var c:Color

func _on_cannon_on_shoot() -> void:
	self.emitting=true
	time=0.2

func _process(delta: float) -> void:
	if emitting:
		time-=delta
		if time<0.0:
			emitting=false
	var dir=self.global_transform*Vector2.UP-self.global_transform*Vector2.ZERO
	self.process_material.direction=Vector3(dir.x,dir.y,0)
	#print(Vector3(dir.x,dir.y,0))
	self.process_material.color=c
