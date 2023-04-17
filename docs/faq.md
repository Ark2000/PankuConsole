# 🤔 **FAQ**

- How to reset the plugin?

  Panku Console has its own persistent data, which is stored in the `user://panku_config.cfg` file. If you want to reset the plugin, you can simply delete this file.

- How to change the default key binding?

  Currently there's a bug in Godot (See https://github.com/godotengine/godot/issues/25865). You have to add a random input action first to update the input map list, then you can change the default key binding by modifying the `toggle_conosle` action.