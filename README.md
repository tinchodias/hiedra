# Hiedra [![Build Status](https://travis-ci.org/tinchodias/hiedra.png)](http://travis-ci.org/tinchodias/hiedra)

Render a column that visually connects a list of items in a format that's commonly used for VCS commits. Implemented in Pharo, it uses Athens, and provides support for Morphic, FastTable, Spec and Spec2.


## Screenshots

Text and hiedra in the same column (the text sticks to the hiedra on each row):

![screenshotB](screenshotB.png)

Multiple columns, dark theme:

![screenshot](screenshot.png)

## Install it

Note this project is already part of Pharo 6, 7, 8 and 9-dev. But if you need to install it, the script is:

```
curl get.pharo.org/64/80+vmHeadlessLatest | bash
```

2. Open image with `./pharo-ui Pharo.image`.

3. Evaluate:

```Smalltalk
	{
		{ 'Mars'. 'github://pharo-spec/mars-gtk' }.
		{ 'Hiedra'. 'github://tinchodias/hiedra:gtk/src' }
	}
	do: [ :each |
		Metacello new
			baseline: each first;
			repository: each second;
			load ].
```

:warning:
The [Pharo repository](https://github.com/pharo-project/pharo) might have a more recent version of this project, as the code is embedded (it's not maintained as an external project).
:warning:

5. Re open image.


## Try it

## License

The code is licensed under [MIT](LICENSE).

## What's *hiedra*?

It's the name in Spanish of [this plant](https://en.wikipedia.org/wiki/Hedera).
