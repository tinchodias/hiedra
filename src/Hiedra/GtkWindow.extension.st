Extension { #name : #GtkWindow }

{ #category : #'*Hiedra' }
GtkWindow >> getScaleFactor [
	"See https://developer.gnome.org/gdk3/stable/gdk3-Windows.html#gdk-window-get-scale-factor"

	^ self ffiCall: #(gint gdk_window_get_scale_factor #(self))
]
