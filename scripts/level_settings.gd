extends Resource
class_name LevelSettings

@export_group("Start Conditions")
@export var start_money: int = 300

@export_group("Towers")
@export var can_purchase_pippa: bool = true
@export var pippa_price: int = 250

@export var can_purchase_nitya: bool = true
@export var nitya_price: int = 250

@export var can_purchase_jelly: bool = true
@export var jelly_price: int = 250

@export_group("Win Conditions")
## The amount of time the command tower needs to stay alive for in minutes.
@export var survival_time: float = 10
