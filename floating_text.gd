extends Control

# Hàm này nhận nội dung (chữ) và màu sắc (Color) từ file Main truyền sang
func setup(noi_dung: String, mau_sac: Color):
	# 1. Gán nội dung cho Label (Ví dụ: +1, -5 Mạng, v.v.)
	$SoHienThi.text = noi_dung
	
	# 2. Ép màu sắc cho toàn bộ Node (Đảm bảo hiện đúng Xanh, Đỏ, Đen)
	self.modulate = mau_sac
	
	# 3. Kích hoạt hiệu ứng bay lên đã thiết kế trong AnimationPlayer
	$AnimationPlayer.play("bay_len")
