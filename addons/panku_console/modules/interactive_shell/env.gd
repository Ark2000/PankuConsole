var _module:PankuModuleInteractiveShell

func open_window(): _module.open_window()

func open_launcher(): _module.open_launcher()

func set_unified_window_visibility(enabled:bool):
    _module.unified_window_visibility = enabled
    _module.update_gui_state()

func set_pause_if_popup(enabled:bool):
    _module.pause_if_input = enabled
    _module.update_gui_state()
