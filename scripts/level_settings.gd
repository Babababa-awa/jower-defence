extends Resource
class_name LevelSettings

@export_group("Start Conditions")
@export var start_money: int = 200

@export_group("Towers")
@export var can_purchase_pippa: bool = true
@export var pippa_price: int = 100

@export var can_purchase_shiina: bool = false
@export var shiina_price: int = 200

@export var can_purchase_jelly: bool = false
@export var jelly_price: int = 400

@export_group("Win Conditions")
## The amount of time the command tower needs to stay alive for in minutes.
@export var survival_time: float = 10
