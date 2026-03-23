extends Control

@onready var total_roses_label = $TotalRosesLabel
@onready var high_score_label = $HighScoreLabel
# Khai báo loa cho nút bấm
@onready var sfx_click = $SfxClickMenu

func _ready() -> void:
	# Cập nhật text từ biến toàn cục
	total_roses_label.text = "Tổng hoa: " + str(Global.total_roses_owned)
	high_score_label.text = "Kỷ lục cao nhất: " + str(Global.high_score)
	
	# Đảm bảo nhạc nền vang lên khi ở Menu
	if not NhacNenToanCuc.playing:
		NhacNenToanCuc.play()

func _on_btn_start_pressed():
	sfx_click.play() # Phát tiếng click
	# Chờ 0.1 giây để tiếng click kịp kêu rồi mới chuyển cảnh
	await get_tree().create_timer(0.1).timeout 
	get_tree().change_scene_to_file("res://main.tscn")

func _on_btn_achieve_pressed():
	sfx_click.play() # Phát tiếng click
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://thanh_tuu.tscn")

func _on_btn_credit_pressed():
	sfx_click.play() # Phát tiếng click
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://credit.tscn")
