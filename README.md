# Panku Console ![](https://badgen.net/badge/Godot%20Compatible/4.0Beta6%2B/cyan) ![](https://badgen.net/github/release/Ark2000/PankuConsole) ![](https://badgen.net/github/license/Ark2000/PankuConsole)

[Godot 4](https://godotengine.org/) Plugin. Provide a runtime console so your can just run any script expression in your game!

[![z1GFnH.png](https://s1.ax1x.com/2022/11/22/z1GFnH.png)](https://imgse.com/i/z1GFnH)

# ✨Features

  ✅ Resizable conosle with edge snapping.

  ✅ No need to define complex commands, extremely easy to run code in your game.

  ✅ Nice-looking blur effect (Not sure if this is a point).

  ✅ Provide a notification panel that may help.

# 📦Installation

1. Clone or download a copy of this repository.
2. Copy the contents of `addons/panku_console` into your `res://addons/panku_console` directory.
3. Enable `PankuConsole` in your project plugins.

For more detailed information, please visit [Installing plugins](https://docs.godotengine.org/en/latest/tutorials/plugins/editor/installing_plugins.html)

# 🤔How does it work?

1. Enable this plugin, it will add an autoload singleton which named `Panku` in your project.
2. Run any scene, press `~` key, and the console window will pop up. (The key can be changed in the script)
3. The console window explanation:

    [![z1NQGq.png](https://s1.ax1x.com/2022/11/22/z1NQGq.png)](https://imgse.com/i/z1NQGq)

   1. The title, drag this to move the window around.
   2. Exit button, click to close the window.
   3. Env options, use `Panku.register_env()` to add more envs.
   4. Input field, press enter to submit, up/down to navigate history input.
   5. Resize button, drag this to resize the window.

4. Try to type 'abs(cos(PI))', you will see the result `1`.

5. Now, try to type `help` and you will get some basic hints.

    [![z1DXHf.png](https://s1.ax1x.com/2022/11/22/z1DXHf.png)](https://imgse.com/i/z1DXHf)

    How is this implemented? Well, it's EXTREMELY easy, just define a variable or constant like this in the `default_env.gd`, more details will be explained in the next step.
    ```gdscript
    const help = "available methods: say_hi(), enable_in_game_logs(bool), cls()"
    ```
6. The core execution procedure is implemented by `Expression` which is a class that stores an expression you can execute.

    For example, you can add `Panku.regiter_env("player", self)` in the `_ready()` function of your player script. 
    Once it's done, suppose there is a variable called `hp` in your player script, you can type `hp` (The left option button should be `player`) in the console, then you will get the actual value of player's hp. 
    What's more, you can type `set("hp", 100)` to change the value(Note that you can't use `hp=100` since this is not a valid expression).

    For more information about what is `Expression`, please visit [Evaluating expressions](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html)

7. Check `panku.gd` to see what you can do with the global singleton `Panku`

At last, please pay attention that while this plugin is powerful, it's not ready for players since `Expression` is unsafe and exposes lots of internal structure.

A safer command system is being actively developed which can be used by the players, see the Roadmap part below.

# 🗺Roadmap

We're planning to add more features to this plugin in the future, stay tuned!

Roadmap: [Panku Console Roadmap](https://github.com/users/Ark2000/projects/1)

# 🏗Contrubuting

You are welcome to make contributions, feel free to make [issues](https://github.com/Ark2000/PankuConsole/issues), [proposals](https://github.com/Ark2000/PankuConsole/issues) and [pull requests](https://github.com/Ark2000/PankuConsole/pulls).

# 📜License

Licensed under the MIT license, see `LICENSE` for more information.
