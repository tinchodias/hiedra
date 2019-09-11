Extension { #name : #GtkWidget }

{ #category : #'*Hiedra' }
GtkWidget >> getScaleFactor [
	"See https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-scale-factor"

	^ self ffiCall: #(gint gtk_widget_get_scale_factor #(self))
]
