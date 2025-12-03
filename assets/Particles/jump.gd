extends Node2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
func play_particle():
	cpu_particles_2d.emitting = true
	
