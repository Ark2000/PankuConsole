# Native Logger

![Native Logger](./assets/logger.png)

With this logger, there's no need to modify any code. It's built upon Godot's native file logging system ,which means it automatically monitors Godot's native log functions like `print`, `printt`, `push_warning` and `push_error`.

To help you easily filter through logs, you can use tags.

known issue: [Does not support `print_rich`](https://github.com/Ark2000/PankuConsole/issues/133)

## Related Commands

- `native_logger.open_window()`

    Open the logger window.

- `native_logger.toggle_overlay()`

    Toggle the logger overlay.

- `native_logger.clear()`

    Clear the logger output.

You can change more settings in [general settings](./general_settings.md).

## Related Files

`panku_console/modules/native_logger/*`