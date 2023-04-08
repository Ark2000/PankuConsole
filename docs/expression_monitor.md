# Expression Monitor

![](assets/monitor.png)

With the expression monitor, you can watch the string result (or even textures) of an expression in real time.

You can customize the update frequency, window title, etc.

If you click on the title bar, the expression will be executed immediately. The update frequency of an expression monitor can be set to 0, so that it becomes a floating button.

When the project starts running, the plugin will automatically load the status information of all expression monitors from the last run that were save to the configuration file.

There are two ways to create expression monitors at runtime.

1. Create it by entering an expression directly in the REPL console and clicking the button to the right of the input box.

2. Create it via a predefined object, specifically `console.add_exp_monitor(...) `.
