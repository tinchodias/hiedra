# Hiedra

It is a small Pharo project to visually connect items in a history-like graph. It uses Athens, and provides support for Morphic, FastTable and Spec.

![screenshot](screenshot.png)

## Install it

Note this project is already part of Pharo 6, 7 and 8. But if you need to install it, the script is:

```Smalltalk
		Metacello new
			repository: 'github://tinchodias/hiedra/src';
			baseline: 'Hiedra';
			load.
```

## GTK prototype

Get pharo from Terminal:

```
curl get.pharo.org/64/80+vmHeadlessLatest | bash
```

Evaluate:

```Smalltalk

		{
			{ 'Mars'. 'github://pharo-spec/mars-gtk' }.
		}
		do: [ :each |
			Metacello new
				baseline: each first;
				repository: each second;
				load ].

		Metacello new
			repository: 'github://tinchodias/hiedra:gtk/src';
			baseline: 'Hiedra';
			load.
```

:warning:
The [Pharo repository](https://github.com/pharo-project/pharo) might have a more recent version of this project, as the code is embedded (it's not maintained as an external project as Iceberg).
:warning:


## Use it

You can find the classes named `HiFastTableExample` and `HiSpecExample` with executable examples (class-side).
