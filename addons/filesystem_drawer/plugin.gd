@tool
extends EditorPlugin
## Converts the FileSystem dock to a FileSystem Drawer at the bottom of the editor.

const DRAWER_SETTING: StringName = "plugins/filesystem_drawer/drawer_enabled"
const SHORTCUT_SETTING: StringName = "plugins/filesystem_drawer/shortcut"

var _filesystem: FileSystemDock
var _drawer: bool = true
var _open: bool = false
var _editor_settings: EditorSettings

func _enter_tree() -> void:
	set_process(false)
	set_process_input(false)
	_filesystem = get_editor_interface().get_file_system_dock()
	# TODO: Get rid of this somehow?
	await get_tree().create_timer(0.1).timeout
	
	_editor_settings = get_editor_interface().get_editor_settings()
	_editor_settings.settings_changed.connect(_on_editor_settings_changed)
	_drawer = _get_or_set_drawer_setting()
	_get_or_set_shortcut()
	
	if _drawer:
		_move_filesystem_dock()
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if not _drawer:
		return
	
	var shortcut = _get_or_set_shortcut()
	if shortcut == null:
		return
	if not shortcut.matches_event(event) or not event.is_released() or event.is_echo():
		return
	
	_open = not _open
	if _open:
		make_bottom_panel_item_visible(_filesystem)
	else:
		hide_bottom_panel()


func _exit_tree() -> void:
	if _drawer:
		_drawer = false
		_move_filesystem_dock()


func _get_or_set_drawer_setting() -> bool:
	if not _editor_settings.has_setting(DRAWER_SETTING):
		_editor_settings.set_setting(DRAWER_SETTING, true)
	_editor_settings.set_initial_value(DRAWER_SETTING, true, false)

	return _editor_settings.get_setting(DRAWER_SETTING)


func _get_or_set_shortcut() -> Shortcut:
	if not _editor_settings.has_setting(SHORTCUT_SETTING):
		var default_shortcut := preload("./default_shortcut.tres")
		var path := default_shortcut.resource_path
		var property_info := {
			"name": SHORTCUT_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres" 
		}
		_editor_settings.set_setting(SHORTCUT_SETTING, path)
		_editor_settings.add_property_info(property_info)
	
	var shortcut_path: String = _editor_settings.get_setting(SHORTCUT_SETTING)
	if shortcut_path == "":
		return null
	
	return load(shortcut_path)


func _move_filesystem_dock() -> void:
	if _drawer:
		remove_control_from_docks(_filesystem)
		add_control_to_bottom_panel(_filesystem, "FileSystem")
			
		# Setup padding
		var _padding: float = EditorInterface.get_editor_scale() * 75.0
		var size: Vector2 = _filesystem.get_parent().size
		_filesystem.get_child(3).get_child(0).size.y = size.y - _padding
		_filesystem.get_child(3).get_child(1).size.y = size.y - _padding
	else:
		remove_control_from_bottom_panel(_filesystem)
		add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, _filesystem)


func _on_editor_settings_changed() -> void:
	if _get_or_set_drawer_setting() == _drawer:
		return
	
	_drawer = _get_or_set_drawer_setting()
	_move_filesystem_dock()
