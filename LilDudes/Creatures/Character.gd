tool
extends KinematicBody2D
class_name Character

const SHEETS = [
	preload("res://SpriteSheets/CastleSpriteSheet.png"),
	preload("res://SpriteSheets/InfernoSpriteSheet.png"),
	preload("res://SpriteSheets/NecromancerSpriteSheet.png"),
	preload("res://SpriteSheets/RampartSpriteSheet.png"),
	preload("res://SpriteSheets/StrongholdSpriteSheet.png"),
	preload("res://SpriteSheets/TowerSpriteSheet.png"),
]

enum CharacterTypes {
	Spearman,
	Crossbowman,
	Griffon,
	Swordsman,
	Priest,
	Mounted_Knight,
	Knight,
	Pikeman,
	Armoured_Crossbowman,
	Grey_Griffon,
	Paladin,
	Warrior_Priest,
	Mounted_Lord,
	Lord,
	Spear_Imp,
	Fire_Imp,
	Hellhound,
	Demon,
	Flail_Demon,
	Effret,
	Demon_Lord,
	Pike_Imp,
	Armoured_Fire_Imp,
	Frilled_Hellhound,
	Armoured_Demon,
	Flail_Demon_Lord,
	Effret_Mage,
	Demon_Count,
	Skeleton_Scythe,
	Zombie_Cleaver,
	Spider,
	Vampire,
	Vampire_Lord,
	Necromancer,
	Mounted_Vampire,
	Skeleton_Sword,
	Zombie_Mace,
	Giant_Spider,
	Banshee,
	Ancient_Vampire,
	Necromancer_Lord,
	Dark_Knight,
	Magic_Sprite,
	Dwarf,
	Satyr,
	Elf,
	Magic_Deer,
	Elf_Wizard,
	Entling,
	Fairie,
	Dawrf_Lord,
	Saytr_Lord,
	Elf_Lord,
	Stag,
	Elf_Wizard_Load,
	Ent,
	Goblin,
	Harpy,
	Warg_Rider,
	Centaur,
	Druid,
	Hobgoblin_Rock_Lobber,
	Ogre,
	Forest_Goblin,
	Harpy_Lord,
	Armoured_Warg_Rider,
	Armoured_Centaur,
	Druid_Lord,
	Minotaur,
	Ogre_Lord,
	Gremlin_Shotgun,
	Gargoyle,
	Golem,
	Carpet_Mage,
	Djinn,
	Leonin,
	Titan,
	Gremlin_Lord,
	Gargoyle_Lord,
	Rollin_Golem,
	Carpet_Mage_Lord,
	Djinn_Lord,
	Leonin_king,
	Titan_Lord
}

export( CharacterTypes ) var character_type = 0 setget set_character_type

var character_offset : int = 0 setget set_character_offset
var face_left : bool = false setget set_face_left
export var max_move_distance : int = 200
export var speed : float = 25.0
export var attack_speed : float = 1.0
export var retreat_timer : int = 120
export var boredom_threshold : int = 120
export var attack_distance : float = 24.0
export var min_damage : int = 1
export var max_damage : int = 10
export var hit_points : int = 10

onready var anim = $AnimationPlayer
onready var sprite = $CharacterSprite

var team_id : int = 0
var move_to_location
var target
var direction
var current_retreat = 0
var current_walk = 0
var current_boredom = 0
var flee_vector

enum STATE { IDLE, ORDERED, TRACKING, RETREATING, ATTACKING, HIT, DEAD }
var state = STATE.IDLE setget set_state

func set_state( value : int ) -> int:
	if ( state == STATE.DEAD ):
		return state
	state = value
	return value

func set_face_left( value : bool ) -> bool:
	if (sprite):
		sprite.flip_h = value
	face_left = value
	return value

func set_character_type( value : int ) -> String :
	var offset = value % 14
	var sheet = floor(value/14)
	character_type = value
	if (sprite):
		sprite.texture = SHEETS[sheet]
	self.character_offset = offset
	return character_type

func set_character_offset( value : int ) -> int :
	value = clamp( value, 0, 13 )
	character_offset = value
	return value

func init(t_id : int, pos : Vector2):
	self.position = pos
	self.team_id = t_id
	
func _ready():
	self.anim.update_animations()
	self.anim.play("Idle")
	EventBus.connect("move_to_location", self, "_on_move_to_updated")
	EventBus.connect("creature_died", self, "_on_creature_died")
	EventBus.connect("creature_hit", self, "_on_creature_hit")
	anim.connect("animation_finished", self, "_on_animation_finished")

func _on_move_to_updated(position, team):
	if (team == self.team_id):
		if ( self.position.distance_to(position) <= max_move_distance ):
			self.begin_follow_orders(position)
	
func play_anim(name : String, stop : bool = false):
	if (self.anim):
		if(stop):
			self.anim.stop()
		self.anim.play(name)

func begin_idle():
	self.state = STATE.IDLE
	self.target = self
	if(self.current_boredom <= 0):
		self.current_boredom = self.boredom_threshold

func do_idle():
	self.play_anim("Idle")
	if Engine.is_editor_hint():
		return
	self.get_new_target()
	self.current_boredom -= 1
	if (self.current_boredom <= 0):
		self.begin_retreat()
	
		
func get_new_target():
	var poss = $AttackView.get_overlapping_bodies()
	var p_target
	var p_dist = 10000
	for p in poss:
		var d = self.position.distance_to(p.position)
		if (p.state != STATE.DEAD && p.team_id != self.team_id && d < p_dist ):
			p_target = p
			p_dist = d
	if (p_target):
		begin_tracking(p_target)

func begin_tracking(n_target):
	target = n_target
	self.state = STATE.TRACKING
	if(self.current_walk <= 0):
		self.current_walk = self.boredom_threshold

func do_tracking():
	self.play_anim("Walk")
	direction = self.position.direction_to(target.position).normalized() * speed
	self.current_walk -= 1
	if (self.current_walk <= 0):
		self.begin_idle()
	
func begin_retreat():
	self.state = STATE.RETREATING
	if (self.current_retreat <= 0):
		self.current_retreat = self.retreat_timer
		self.flee_vector = Vector2( rand_range(-1,1), rand_range(-1,1))
	
func do_retreating():
	self.play_anim("Walk" )
	self.current_retreat = self.current_retreat - 1
	direction = self.flee_vector.normalized() * speed
	if (self.current_retreat <= 0):
		self.begin_idle()

func begin_follow_orders(position):
	if (self.state == STATE.ORDERED || self.state == STATE.IDLE || self.state == STATE.RETREATING):
		self.move_to_location = position
		self.state = STATE.ORDERED
		if(self.current_walk <= 0):
			self.current_walk = self.boredom_threshold

func do_follow_orders():
	self.play_anim("Walk")
	direction = self.position.direction_to(self.move_to_location).normalized() * speed
	self.current_walk -= 1
	if (self.current_walk <= 0):
		self.begin_idle()

func move_to(direction,delta):
	direction = direction
	self.move_and_slide(direction)
	self.face_left = direction.x < 0
	
func do_attack():
	if ( self.anim.current_animation != "Attack"):
		self.state = STATE.ATTACKING
		self.play_anim("Attack")

func _physics_process(delta):
	if (direction):
		self.move_to(direction,delta)
	direction = null

func _process(delta : float):
	if (state == STATE.HIT || state == STATE.DEAD || state == STATE.ATTACKING):
		return
	if (state == STATE.ORDERED):
		self.do_follow_orders()
		return
	if (state == STATE.RETREATING):
		self.do_retreating()
		return
	if (target && 
	target != self && 
	state == STATE.TRACKING && 
	self.position.distance_to(target.position) < self.attack_distance ):
		self.do_attack()
		return
	if (target && target != self && state == STATE.TRACKING):
		self.do_tracking()
		return
	
	self.begin_idle()
	self.do_idle()

func _on_animation_finished(name):
	if (name == "Attack"):
		self.begin_idle()
		var hit
		if ( self.face_left ):
			hit = $AttackLeft.get_collider()
		else:
			hit = $AttackRight.get_collider()
		if ( hit ):
			if ( hit.state != STATE.DEAD ):
				EventBus.emit_signal("creature_hit", hit, int( rand_range(self.min_damage, self.max_damage)))
			else:
				self.begin_retreat()
		else :
			self.begin_retreat()

	if (name == "Hit"):
		self.begin_retreat()

func _on_creature_died(character):
	if ( target == character ):
		self.begin_idle()
		
func _on_creature_hit(hit, damage):
	if( hit != self):
		return
	if(state == STATE.DEAD):
		return
	self.play_anim("Hit", true)
	state = STATE.HIT
	self.hit_points -= clamp( damage, 0, self.hit_points )
	if self.hit_points <= 0:
		self.state = STATE.DEAD
		EventBus.emit_signal("creature_died", self)
		self.play_anim("Death", true)
		$DeathTimer.start()

func _on_AttackView_body_entered(body : Character):
	if (body.team_id == self.team_id):
		return
	if (body.state == STATE.DEAD):
		return
	if ( ! target || target == self ):
		self.begin_tracking(body)
	elif ( target && self.position.distance_to(target.position) > self.position.distance_to(body.position) ):
		self.begin_tracking(body)

func _on_DeathTimer_timeout():
	self.target = null
	self.queue_free()
