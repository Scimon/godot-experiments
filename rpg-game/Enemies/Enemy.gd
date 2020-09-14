extends KinematicBody2D
class_name Enemy

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

var knockback = Vector2.ZERO
export var knockback_friction = 200
export var knockback_power = 150
export var acceleration = 200
export var max_speed = 50
export var friction = 200
export var emnity = 200

var velocity = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

export(DeathSpawnData.spawners) var spawnType = DeathSpawnData.spawners.BAT

signal died(spawnType, pos)

func _ready():
	var scene = get_tree().current_scene
	connect("died", scene, "_handle_dead_signal")
	update_wandering()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			check_for_wandering()
			seek_player()
			
		WANDER:
			accelerate_to_point(delta,wanderController.target_position)
			if global_position.distance_to(wanderController.target_position) <= max_speed * delta:
				update_wandering()
			else:
				check_for_wandering()
			seek_player()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_to_point(delta,player.global_position)
			else:
				update_wandering()

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * emnity
	velocity = move_and_slide(velocity)

func accelerate_to_point(delta,position):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	sprite.flip_h = velocity.x < 0

func check_for_wandering():
	if wanderController.get_time_left() == 0:
		update_wandering()
		
func update_wandering():
	state = pick_random_state( [IDLE,WANDER] )
	wanderController.start_wander_timer( rand_range(1,3) )	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * knockback_power
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.3)


func _on_Stats_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	emit_signal("died",spawnType,global_position)
	StoreDetails.on_death(self)
	queue_free()

func _on_HurtBox_invincibility_started():
	animationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	animationPlayer.play("Stop")

func _enter_tree():
	StoreDetails.on_creation(self)
	
func _exit_tree():
	StoreDetails.on_leave(self)
