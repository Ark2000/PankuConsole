# Built-in Snippets

Panku Console provides a set of built-in command snippets, which can be used to quickly access some of the internal state of the engine, and can also be used to quickly execute some common operations.

The built-in commands are defined in the `addons/panku_console/default_repl_envs` folder, you can add your own commands by modifying the corresponding files.

## **Command List**

| Command | Description |
| --- | --- |
| `current` | The current scene root, which will be automatically updated |
| `help` | List all environment variables |
| `helpe(obj:Object)` | Provide detailed information about one specific environment variable |
| `console.cls` | Clear interactive shell's output |
| `console.notify` | Generate a notification |
| `console.check_update` | Fetch latest release information from Github |
| `console.open_settings` | Open settings window |
| `console.open_keybindings` | Open expression key bindings window, see [Expression Shortcut](expression_shortcut.md) |
| `console.open_history` | Open expression history window, see [History Manager](history_manager.md) |
| `console.open_logger` | Open logger window, see [Logger](logger.md) |
| `console.toggle_logger_overlay` | Toggle visibility of logger overlay |
| `console.add_exp_monitor(exp:String)` | Add an expression monitor, see [Expression Monitor](expression_monitor.md) |
| `console.add_exp_button(exp:String, display_name:String)` | Add an expression button, see [Expression Monitor](expression_monitor.md) |
| `console.monitor_user_obj(obj:Object)` | Show all public script properties of a user object |
| `console.add_profiler` | Add a simple profiler |
| `console.add_exporter(obj_exp:String)` | Add a window to show and modify export properties, see [Inspector Panel](generating_inspector_panel.md) |
| `console.toggle_crt_effect()` | The good old days |
| `engine.set_fullscreen(b:bool)` | Set [fullscreen / windowed] mode |
| `engine.toggle_fullscreen` | Toggle [fullscreen / windowed] mode |
| `engine.time_scale(val:float)` | Equals to `Engine.time_scale` |
| `engine.performance_info` | Show performance info |
| `engine.snap_screenshot` | Snap a screenshot of current window |
| `engine.quit` | Quit application |
| `engine.show_os_report()` | Display detailed OS report |
| `engine.toggle_2d_collision_shape_visibility()` | Toggle visibility of 2D collision shapes, useful for debugging |
| `engine.reload_current_scene()` | Reload current scene |
