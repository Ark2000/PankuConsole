# Panku Console ![](https://badgen.net/badge/Godot%20Compatible/4.0Beta10%2B/cyan) ![](https://badgen.net/github/release/Ark2000/PankuConsole) ![](https://badgen.net/github/license/Ark2000/PankuConsole)

[![pSpJEjK.png](https://s1.ax1x.com/2022/12/30/pSpJEjK.png)](https://imgse.com/i/pSpJEjK)

A [Godot 4](https://godotengine.org/) Plugin. Panku Conosle is a set of tools to help you troubleshoot and iterate on game ideas on your target platform in realtime. On-device access to the GDScript REPL console and its many tools in any game build allows you to investigate bugs without deploying a debug build specific to your machine.

# ✨Features

  ✅ Flexible conosle window with edge snapping, resizing and dragging.

  ✅ No need to define complex commands, extremely easy to run code in your game directly.

  ✅ Simple but reliable notification system. Send notifications whenerver you want.

  ✅ Create expression monitors and buttons widgets in one click.

  ✅ Exported properties panel can help you find the perfect parameters for gameplay features in realtime.

  ✅ Auto-complete your expression using `tab` with help information extracted from your code.

  ✅ Navigate throught submit histories using `up`/`down`.

  ✅ You can always press F1 and search `PankuConsole` in your editor to get the coding documentation.

  ✅ A lot of useful expressions are prefined to suite your need.

[![pSpJ6DU.png](https://s1.ax1x.com/2022/12/30/pSpJ6DU.png)](https://imgse.com/i/pSpJ6DU)
*Plugin screenshot. The demo game here is OpenTTD.*

# 📦Installation

1. Clone or download a copy of this repository.
2. Copy the contents of `addons/panku_console` into your `res://addons/panku_console` directory.
3. Enable `PankuConsole` in your project plugins.

For more detailed information, please visit [Installing plugins](https://docs.godotengine.org/en/latest/tutorials/plugins/editor/installing_plugins.html)

# 🌊Getting Started

Quick setup and easy configuration were important goals when designing Panku Console.

After the installation, Panku Console will be accessible in all scenes of your project automatically.

## Opening the REPL Window

Panku Console is currently only designed for platforms with a keyboard and a mouse. The plugin will define an input action called "toggle_console" which is corresponding to the `~` key. You can change the way to call the REPL window later.

All Panku windows you created will be remembered so you don't have to open the windows again and again.

## What can you do in the default REPL environment?

Panku REPL can only execute GDScript expressions. An expression can be made of any arithmetic operation, built-in math function call, method call of environment objects, or built-in type construction call. For more information, please visit [Godot Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html)

Here are some example expressions.

```gdscript
#A simple math expression with built-in math function calls that you can find in @GlobalScope and @GDScript
round(sin(2*PI+1.7*4.2+0.6))
> 1

#Below are some predefined environment scripts. You can try to add some properties in <repl_base_instance.gd> to play around.

#Call a get method defined in <repl_base_instance.gd>
help
> ...

#Call a method defined in <repl_console_env.gd>
console.notify("[color=red]Hello![/color]")
> <null>

#Call a get method defined in <repl_engine_env.gd>
engine.snap_screenshot
> <null>

#Call a method defined in <repl_widgets_env.gd>
widgets.profiler
> <null>

#Invalid expression, since assignment is not allowed.
player.scale = Vector2(2, 2)
> Expected '='

#But you can use set method instead.
player.set("scale", Vector2(2, 2))
> <null>
```

By the way, the REPL input box provides auto completion and histories functionalities which means you only need to type `snap` and then press `TAB` to run `engine.snap_screenshot`.

[![pSpg26S.png](https://s1.ax1x.com/2022/12/30/pSpg26S.png)](https://imgse.com/i/pSpg26S)

## How to add your own objects in the REPL environment?

Panku Console provides an API to register objects in the REPL environment, so the process should be very easy.

Suppose the code below is your player script.

```gdscript
extends Node2D

func _ready():
    Console.register_env("player", self)

#the help info is optional
const _HELP_hello = "sample function"
func hello(name):
    return "hello! %s" % name

#...
```

And now you can type `player.hello("Jason")` in the REPL to call the function you have just defined.

By default, all properties that start with `_` will be ignored by hinting system but you can still access them anyway.


## How to monitor an expression or add an expression button?

The monitor widgets defined in `repl_widgets_env.gd` are very useful if you are instersted in some expressions.

For example, this predefined expression `engine.performance_info` will return a string shows the current performance information. It's very simple to monitor this expression, just type the expression you want to keep watching in the **input box** and then click the **hammer icon** right next to the input box and select `Make Monitor`, done! The monitor widget will pop up at the top left corner, and you may want to adjust its size to fit the output.

That's the monitor part. sometimes you want to create a button that execute an expression such as summon an enemy or recharge the health so you don't have to type it tediously, then you can create an expression button widget.

The process is exactly the same as creating a monitor widget, the only difference is that you have to select `Make Button` option.

In fact, the two widgets are the same thing, the only difference is their's update frenquency which you can change later in the widget settings tab.

## How to create an export properties panel?

It can be incredible useful to be able to modify gameplay parameters while on the target device. The export properties panel enables this by scanning for export properties.

The target object should be registered in the REPL environemnt.

As the picture below depicts, valid objects will be listed in the tool menu and you can select the target object to create its export properties panel.

[![pSpWlwQ.png](https://s1.ax1x.com/2022/12/30/pSpWlwQ.png)](https://imgse.com/i/pSpWlwQ)

This is the export properties defined in player script.

```gdscript
@export var simple_float_value:float = 123.0
@export_range(10, 30) var int_range:int = 1
@export var simple_int_value:int = 456
@export_range(400, 700, 0.1) var speed:float = 400.0
@export var bool1:bool = false
@export var player_name:String = "player"
@export var player_color:Color = Color.WHITE
@export_enum("Warrior", "Magician", "Thief") var character_class=0
```

And the result export properties panel will be like this.

[![pSpWwmF.png](https://s1.ax1x.com/2022/12/30/pSpWwmF.png)](https://imgse.com/i/pSpWwmF)

**Note**: Not all export variables are supported now. And if an export property's value is changed in code anywhere outside of the GUI, the new value won't be reflected there. Use monitor widget to listen values.

# 🏗Contrubuting

You are welcome to make contributions, feel free to make [issues](https://github.com/Ark2000/PankuConsole/issues), [proposals](https://github.com/Ark2000/PankuConsole/issues), [pull requests](https://github.com/Ark2000/PankuConsole/pulls) and [discussions](https://github.com/Ark2000/PankuConsole/discussions). Your feedback matters a lot to the project!

Commit messages should follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

# 📜License

Licensed under the MIT license, see `LICENSE` for more information.
