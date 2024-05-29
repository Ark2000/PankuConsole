@tool
class_name PankuConsolePlugin
extends EditorPlugin

const SINGLETON_NAME = "Panku"
const SINGLETON_PATH = "res://addons/panku_console/console.tscn"
const SINGLETON_OPTION = "autoload/" + SINGLETON_NAME


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
		var disable_activated: bool = ProjectSettings.get_setting(
			PankuConfig.panku_option(PankuConfig.OPTIONS.DISABLE_ON_RELEASE)
		)

		if not is_debug and disable_activated:
			need_restore_singleton = ProjectSettings.has_setting(SINGLETON_OPTION)
			owner.safe_remove_singleton()


	func _export_end() -> void:
		if need_restore_singleton:
			owner.safe_add_singleton()

# A helper function to add custom project settings
# See https://dfaction.net/handling-custom-project-settings-using-gdscript/
static func add_custom_project_setting(name: String, default_value, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:
	if ProjectSettings.has_setting(name): return

	var setting_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string
	}

	ProjectSettings.set_setting(name, default_value)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(name, default_value)
	ProjectSettings.set_as_basic(name, true)


# Adding singleton with preliminary check to avoid any conflicts.
func safe_add_singleton() -> void:
	if not ProjectSettings.has_setting(SINGLETON_OPTION):
		add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)


# Removing singleton with preliminary check to avoid any conflicts.
func safe_remove_singleton() -> void:
	if ProjectSettings.has_setting(SINGLETON_OPTION):
		remove_autoload_singleton(SINGLETON_NAME)

func create_setting() -> void:
	# Seems we can't add descriptions to custom settings now.

	# Disable Panku Console in release builds
	add_custom_project_setting(
		PankuConfig.panku_option(PankuConfig.OPTIONS.DISABLE_ON_RELEASE),
		false,
		TYPE_BOOL
	)
	# Path to the custom `res://` path default config file, useful if you are going to keep panku console in release builds.
	add_custom_project_setting(
		PankuConfig.panku_option(PankuConfig.OPTIONS.CUSTOM_DEFAULT_CONFIG),
		PankuConfig.INITIAL_DEFAULT_CONFIG_FILE_PATH,
		TYPE_STRING,
		PROPERTY_HINT_FILE,
		"*.cfg"
	)

	var error:int = ProjectSettings.save()
	if error != OK:
		push_error("Encountered error %d when saving project settings." % error)

func _enter_tree() -> void:
	# See https://github.com/godotengine/godot/issues/73525
	exporter = (PankuExporter as Variant).new()
	exporter.owner = self
	add_export_plugin(exporter)
	create_setting()

	safe_add_singleton()
	print("[Panku Console] initialized! Project page: https://github.com/Ark2000/PankuConsole")

	if not PankuConfig.is_custom_default_config_exists():
		push_warning("[Panku Console] Default config file not found. Using code-level default config.")

func _exit_tree() -> void:
	remove_export_plugin(exporter)


func _disable_plugin() -> void:
	safe_remove_singleton()

	for option in PankuConfig.OPTIONS.values():
		var opt: String = PankuConfig.panku_option(option)
		if ProjectSettings.has_setting(opt):
			ProjectSettings.clear(opt)
	ProjectSettings.save()

	print("[Panku Console] disabled.")
