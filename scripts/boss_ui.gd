extends Control

func set_label_text(text: String) -> void:
	$Label.text = text

func change_hp_bar(data: float) -> void:
	$ProgressBar.value = data
