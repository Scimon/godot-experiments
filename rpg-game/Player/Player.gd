extends KinematicBody2D

export var max_speed = 80
export var roll_speed = 120
export var acceleration = 500
export var friction = 500
export var roll_slow = 0.5

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitBox
onready var hurtBox = $HurtBox
const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

const BLEND_POSITIONS = [
	"parameters/Idle/blend_position", 
	"parameters/Run/blend_position", 
	"parameters/Attack/blend_position",
	"parameters/Roll/blend_position"
]

func _ready():
	randomize()
	animationTree.set_active(true)
	swordHitbox.knockback_vector = roll_vector
	stats.connect("no_health", self, "queue_free")
	if stats.target_locator:
		var node = get_tree().current_scene.find_node(stats.target_locator)
		if node:
			global_position = node.global_position
		stats.target_locator = ""

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		for position in BLEND_POSITIONS:
			animationTree.set(position, input_vector)
		animationState.travel("Run")
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animationState.travel("Idle")
		
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(_delta):
	velocity = roll_vector * roll_speed
	animationState.travel("Roll")
	move()

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = velocity * roll_slow
	state = MOVE


func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.6)
	hurtBox.create_hit_effect()
	get_tree().current_scene.add_child(PlayerHurtSound.instance())


func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
