# **Panku Console**
![](https://badgen.net/badge/Godot%20Compatible/4.0.stable%2B/cyan) ![](https://badgen.net/github/release/Ark2000/PankuConsole)

![logo](docs/assets/title.png)

All-in-One [Godot Engine 4](https://godotengine.org/) runtime debugging tool.

# ✨ **Features**

In short, the core function of Panku Console is to dynamically execute some simple expressions while the game is running. Of course, it is much more than that, in fact, Panku Console is a collection of many practical tools. Here is a brief description of its features.

✅ **Flexible Multi-window System**. Any windows can be scaled, snapped, dragged and even become an independent os window.

✅ **Out-of-the-box Developer Console**. No need to define complex commands, enter any expression, execute it and get the result.

✅ **Expression Monitoring**. Create windows to see the results of expressions in real time.

✅ **Quick Key Binding**. Bind expressions to keys for quick cheating.

✅ **Popup Notification**. Pop up any message that deserves your attention.

✅ **Powerful Inspector Generator**. Automatically convert all export properties in your script into an inspector window.

✅ **History Management**. Manage all your input history, pin or merge history expressions.

✅ **Logger System**. Powered by the native file logging system, simple yet powerful.

![](docs/assets/preview.webp)

# 🧪 **Installation**

1. Download [Latest commit](https://github.com/Ark2000/PankuConsole/archive/refs/heads/master.zip) or the stable [Release](https://github.com/Ark2000/PankuConsole/releases) version.

2. Copy the `addons` folder to your project root directory.

3. Enable `PankuConsole` in the Godot project addon settings.

For more information about plugin installation, you can visit the corresponding [Godot documentation](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

> **Note**: Panku Console only supports Godot version 4.x, and I personally do not plan to provide support for 3.x.

# 📚 **Quick Start**

Panku Console is designed to take advantage of Godot's native features as much as possible, to provide as little API as possible, to reduce the intrusiveness of the project, to allow most of the operations to be done at runtime without causing additional burden for the developer, and to use pure GDScript development to maximize applicability and maintenance efficiency.

Panku Console is a collection of many tools, and each tool has its own documentation, so I will not go into details here. If you want to know more about the plugin, you can read the following documents.

**Content:**

- [Interactive Shell](docs/interactive_shell.md)
- [Built-in Commands](docs/builtin_commands.md)
- [Expression Monitor](docs/expression_monitor.md)
- [Expression Shortcut](docs/expression_shortcut.md)
- [Generating Inspector Panel](docs/generating_inspector_panel.md)
- [History Manager](docs/history_manager.md)
- [Logger](docs/logger.md)

> **Note**: if you want to include the plugin in your released game, you may need to make some modifications to avoid players directly accessing internal state.

# **Contributors**

Thanks to these nice [people who contributed to this project](https://github.com/Ark2000/PankuConsole/graphs/contributors), you can also participate in ways including but not limited to:

1. if you find bugs or have any suggestions, you can submit [Issues](https://github.com/Ark2000/PankuConsole/issues)

2. if you have questions, you can discuss them in the [Discussion](https://github.com/Ark2000/PankuConsole/discussions)

3. You can also [Contribute Code](https://github.com/Ark2000/PankuConsole/pulls) directly to this project, please refer to [Recent Commits](https://github.com/Ark2000/PankuConsole/commits/master) for the specification of commit message or [here](https://www.conventionalcommits.org/en/v1.0.0/#summary)

See [CONTRIBUTING](CONTRIBUTING.md) for more details.

# **License**

[MIT License](LICENSE)

Copyright (c) 2022-present, Feo (k2kra) Wu