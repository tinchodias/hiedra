# Hiedra

It is a small Pharo project to visually connect items in a history-like graph. It uses Athens, and provides support for Morphic, FastTable and Spec.

![screenshot](screenshot.png)

## Install it

Note this project is already part of Pharo 6, 7 and 8. However, if you need to install it anyway, the script to do it is:

```Smalltalk
		Metacello new 
			repository: 'github://tinchodias/hiedra/src';
			baseline: 'Hiedra';
			load.
```

:warning:
The [Pharo repository](https://github.com/pharo-project/pharo) might have a more recent version of this project.
:warning:


## Use it

You can see and run the examples via the classes named HiFastTableExample and HiSpecExample.
