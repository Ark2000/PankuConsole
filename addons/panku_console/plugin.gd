@tool
class_name PankuConsolePlugin
extends EditorPlugin

const SINGLETON_NAME = "Panku"
const SINGLETON_PATH = "res://addons/panku_console/console.tscn"
const SINGLETON_OPTION = "autoload/" + SINGLETON_NAME

var exporter: PankuExporter


# Custom export plugin to automatically disable console in release builds
class PankuExporter extends EditorExportPlugin:
	const NAME = "PankuReleaseExporter"
	var owner: EditorPlugin
	var need_restore_singleton: bool


	func _get_name() -> String:
		# Have no clue where this name will be used
		# It just should be implemented according the docs
		return NAME


	func _export_begin(_features: PackedStringArray, is_debug: bool, _path: String, _flags: int) -> void:
		need_restore_singleton = false
		var disable_activated: bool = ProjectSettings.get_setting(
			PankuConfig.panku_option(PankuConfig.OPTIONS.DISABLE_ON_RELEASE)
		)

		if not is_debug and disable_activated:
			need_restore_singleton = ProjectSettings.has_setting(SINGLETON_OPTION)
			owner.safe_remove_singleton()


	func _export_end() -> void:
		if need_restore_singleton:
			owner.safe_add_singleton()


func _enable_exporter() -> void:
	if not exporter:
		# See https://github.com/godotengine/godot/issues/73525
		exporter = (PankuExporter as Variant).new()
		exporter.owner = self
	add_export_plugin(exporter)


func _disable_exporter() -> void:
	if exporter:
		remove_export_plugin(exporter)


# Adding singleton with preliminary check to avoid any conflicts.
func safe_add_singleton() -> void:
	if not ProjectSettings.has_setting(SINGLETON_OPTION):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)


# Removing singleton with preliminary check to avoid any conflicts.
func safe_remove_singleton() -> void:
	if ProjectSettings.has_setting(SINGLETON_OPTION):
		remove_autoload_singleton(SINGLETON_NAME)


func _enable_plugin() -> void:
	safe_add_singleton()

	print("[Panku Console] enabled.")


func _disable_plugin() -> void:
	safe_remove_singleton()
	PankuConfig.clear_all_project_settings()

	print("[Panku Console] disabled.")


func _enter_tree() -> void:
	PankuConfig.init_all_project_settings()
	_enable_exporter()

	print("[Panku Console] initialized! Project page: https://github.com/Ark2000/PankuConsole")


func _exit_tree() -> void:
	_disable_exporter()


