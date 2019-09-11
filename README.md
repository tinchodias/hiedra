# Hiedra in GTK - prototype


## Install it

1. Get pharo 8 headless from Terminal:

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

4. Save and quit. Reason: I understood from Esteban that reopening the image after installing mars is a good trick to avoid some problems.

5. Re open image.


## Try it

### Example 1 (2870 commits):

```Smalltalk
HiGtkSpecExample example2870IcebergCommits.
```

### Example 2 (493 commits): 

```Smalltalk
HiGtkSpecExample example493PharoCommits.
```
