# Miscellaneous Commands

| Command | Description |
| --- | --- |
| `help` | List all environment variables |
| `helpe(obj:Object)` | Provide detailed information about one specific environment variable |
| `screen_notifier.notify(any)` | Generate a popup notification, you can also call this in you code by `Panku.notify(any)` |
| `check_latest_release.check()` | Fetch latest release information from Github |
| `system_report.execute()` | Display detailed OS report |
| `screen_crt_effect.toggle()` | A fancy screenspace shader |
| `engine_tools.toggle_fullscreen` | Toggle [fullscreen / windowed] mode |
| `engine_tools.set_time_scale(val:float)` | Equals to `Engine.time_scale` |
| `engine_tools.get_performance_info()` | Show performance info |
| `engine_tools.take_screenshot()` | Snap a screenshot of current window |
| `engine_tools.quit()` | Quit application |
| `engine_tools.toggle_2d_collision_shape_visibility()` | Toggle visibility of 2D collision shapes, useful for debugging |
| `engine_tools.reload_current_scene()` | Reload current scene |

## Related Files

`panku_console/modules/system_report/*`

`panku_console/modules/screen_crt_effect/*`

`panku_console/modules/engine_tools/*`

`panku_console/modules/check_latest_release/*`
