
HEADERS += idle/idle.h
SOURCES += idle/idle.cpp

unix:!mac {
	SOURCES += idle/idle_x11.cpp
}
win32: {
	SOURCES += idle/idle_win.cpp
}
mac: {
	SOURCES += idle/idle_mac.cpp
}
