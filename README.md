# Updates

- [20240606] Unfortunately, this widget isn't compatible with KDE 6 so is currently broken. 
- [20240904] Update: This widget is currently installable in Plasma 6.1.4 😃. However, There is a bug that prevents the widget from showing when the countdown expires. More Plasma API digging is necessary!

# Motivation

Protect your eyes!! Without them you cannot see!!
Also, this widget functions as a pomodoro timer. If you know the pomodoro technique, you would definitely like it.

# Screenshots

## Widget view
![](https://i.imgur.com/lxajTMz.png)

## Config view
![](https://i.imgur.com/97HP1ki.png)

# Building and Installing

This project is a KDE plasmoid. If you want to build it you should have the plasma and Qt SDK installed.
```
cmake -Bbuild/ . && make -C build/ && sudo make install -C build/
```
