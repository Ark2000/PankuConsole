@tool
extends EditorPlugin

const SINGLETON_NAME = "Panku"
const SINGLETON_PATH = "res://addons/panku_console/console.tscn"
const SINGLETON_OPTION = "autoload/" + SINGLETON_NAME

const CONFIG_SECTION = "panku"
const OPTIONS = {
	DISABLE_ON_RELEASE = 'disable_on_release'
}

var exporter: PankuExporter


# Custom export plugin to automatically disable console in release builds
class PankuExporter extends EditorExportPlugin:
	const NAME = "Panku"
	var owner: EditorPlugin
	var need_restore_singleton: bool


	func _get_name() -> String:
		# Have no clue where this name will be used
		# It just should be implemented according the docs
		return NAME


	func _export_begin(_features: PackedStringArray, is_debug: bool, _path: String, _flags: int) -> void:
		need_restore_singleton = false
		var disable_activated: bool = ProjectSettings.get_setting(owner.panku_option(OPTIONS.DISABLE_ON_RELEASE))

		if not is_debug and disable_activated:
			need_restore_singleton = ProjectSettings.has_setting(SINGLETON_OPTION)
			owner.safe_remove_singleton()


	func _export_end() -> void:
		if need_restore_singleton:
			owner.safe_add_singleton()


# Full option name in project settings.
func panku_option(option: String) -> String:
	return CONFIG_SECTION + "/" + option


# Adding singleton with preliminary check to avoid any conflicts.
func safe_add_singleton() -> void:
	if not ProjectSettings.has_setting(SINGLETON_OPTION):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)


# Removing singleton with preliminary check to avoid any conflicts.
func safe_remove_singleton() -> void:
	if ProjectSettings.has_setting(SINGLETON_OPTION):
		remove_autoload_singleton(SINGLETON_NAME)


func create_setting() -> void:
	if not ProjectSettings.has_setting(panku_option(OPTIONS.DISABLE_ON_RELEASE)):
		ProjectSettings.set_setting(panku_option(OPTIONS.DISABLE_ON_RELEASE), false)
		ProjectSettings.set_initial_value(panku_option(OPTIONS.DISABLE_ON_RELEASE), false)
		ProjectSettings.save()


func _enter_tree() -> void:
	exporter = PankuExporter.new()
	exporter.owner = self
	add_export_plugin(exporter)
	create_setting()

	safe_add_singleton()
	print("Panku Console initialized! Project page: https://github.com/Ark2000/PankuConsole")


func _exit_tree() -> void:
	remove_export_plugin(exporter)


func _disable_plugin() -> void:
	safe_remove_singleton()

	for option in OPTIONS.values():
		var opt: String = panku_option(option)
		if ProjectSettings.has_setting(opt):
			ProjectSettings.clear(opt)
	ProjectSettings.save()

	print("Panku Console disabled.")
