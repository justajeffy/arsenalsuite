TARGET = phonon.so
OFILES = sipphononcmodule.o sipphononQList0101PhononEffect.o sipphononQHash0100QByteArray0100QVariant.o sipphononQList0100PhononMediaSource.o sipphononQMultiMap0100QString0100QString.o sipphononQList0100PhononSubtitleDescription.o sipphononQList0100PhononAudioChannelDescription.o sipphononQList0100PhononEffectParameter.o sipphononQList0100PhononAudioCaptureDevice.o sipphononQList0100PhononEffectDescription.o sipphononQList0100PhononAudioOutputDevice.o sipphononQList0100PhononPath.o sipphononPhononVolumeSlider.o sipphononPhononVideoWidget.o sipphononPhononVideoPlayer.o sipphononPhononSeekSlider.o sipphononPhononPath.o sipphononPhononEffectDescriptionModel.o sipphononPhononAudioOutputDeviceModel.o sipphononPhononAudioCaptureDevice.o sipphononPhononAudioChannelDescription.o sipphononPhononSubtitleDescription.o sipphononPhononEffectDescription.o sipphononPhononAudioOutputDevice.o sipphononPhononMediaSource.o sipphononPhononMediaObject.o sipphononPhononMediaControllerFeatures.o sipphononPhononMediaController.o sipphononPhononEffectWidget.o sipphononPhononEffectParameterHints.o sipphononPhononEffectParameter.o sipphononPhononEffect.o sipphononPhononBackendCapabilitiesNotifier.o sipphononPhononBackendCapabilities.o sipphononPhononAudioOutput.o sipphononPhononAbstractVideoOutput.o sipphononPhononAbstractAudioOutput.o sipphononPhononMediaNode.o sipphononPhonon.o
HFILES = sipAPIphonon.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_PHONON_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/phonon -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=phonon.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lphonon -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtDBus -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtXml -pthread -L/lib64 -pthread -pthread -pthread -pthread -pthread -lQtGui -L/usr/X11R6/lib64 -pthread -lfreetype -lgobject-2.0 -lSM -lICE -pthread -pthread -lXrender -lfontconfig -lXext -lX11 -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
MOC = /usr/local/Trolltech/Qt-4.5.3/bin/moc
.SUFFIXES: .c .o .cpp .cc .cxx .C


.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.cc.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.cxx.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.C.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

all: $(TARGET)

$(OFILES): $(HFILES)

$(TARGET): $(OFILES)
	@echo '{ global: initphonon; local: *; };' > phonon.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/phonon || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/phonon
	cp -f ../sip/phonon/medianode.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/medianode.sip
	cp -f ../sip/phonon/seekslider.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/seekslider.sip
	cp -f ../sip/phonon/path.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/path.sip
	cp -f ../sip/phonon/effect.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/effect.sip
	cp -f ../sip/phonon/effectparameter.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/effectparameter.sip
	cp -f ../sip/phonon/mediasource.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/mediasource.sip
	cp -f ../sip/phonon/effectwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/effectwidget.sip
	cp -f ../sip/phonon/phononmod.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/phononmod.sip
	cp -f ../sip/phonon/backendcapabilities.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/backendcapabilities.sip
	cp -f ../sip/phonon/mediaobject.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/mediaobject.sip
	cp -f ../sip/phonon/abstractaudiooutput.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/abstractaudiooutput.sip
	cp -f ../sip/phonon/objectdescription.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/objectdescription.sip
	cp -f ../sip/phonon/videowidget.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/videowidget.sip
	cp -f ../sip/phonon/volumeslider.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/volumeslider.sip
	cp -f ../sip/phonon/abstractvideooutput.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/abstractvideooutput.sip
	cp -f ../sip/phonon/phononnamespace.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/phononnamespace.sip
	cp -f ../sip/phonon/audiooutput.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/audiooutput.sip
	cp -f ../sip/phonon/mediacontroller.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/mediacontroller.sip
	cp -f ../sip/phonon/videoplayer.sip $(DESTDIR)/usr/share/sip/PyQt4/phonon/videoplayer.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipphononcmodule.o
	-rm -f sipphononQList0101PhononEffect.o
	-rm -f sipphononQHash0100QByteArray0100QVariant.o
	-rm -f sipphononQList0100PhononMediaSource.o
	-rm -f sipphononQMultiMap0100QString0100QString.o
	-rm -f sipphononQList0100PhononSubtitleDescription.o
	-rm -f sipphononQList0100PhononAudioChannelDescription.o
	-rm -f sipphononQList0100PhononEffectParameter.o
	-rm -f sipphononQList0100PhononAudioCaptureDevice.o
	-rm -f sipphononQList0100PhononEffectDescription.o
	-rm -f sipphononQList0100PhononAudioOutputDevice.o
	-rm -f sipphononQList0100PhononPath.o
	-rm -f sipphononPhononVolumeSlider.o
	-rm -f sipphononPhononVideoWidget.o
	-rm -f sipphononPhononVideoPlayer.o
	-rm -f sipphononPhononSeekSlider.o
	-rm -f sipphononPhononPath.o
	-rm -f sipphononPhononEffectDescriptionModel.o
	-rm -f sipphononPhononAudioOutputDeviceModel.o
	-rm -f sipphononPhononAudioCaptureDevice.o
	-rm -f sipphononPhononAudioChannelDescription.o
	-rm -f sipphononPhononSubtitleDescription.o
	-rm -f sipphononPhononEffectDescription.o
	-rm -f sipphononPhononAudioOutputDevice.o
	-rm -f sipphononPhononMediaSource.o
	-rm -f sipphononPhononMediaObject.o
	-rm -f sipphononPhononMediaControllerFeatures.o
	-rm -f sipphononPhononMediaController.o
	-rm -f sipphononPhononEffectWidget.o
	-rm -f sipphononPhononEffectParameterHints.o
	-rm -f sipphononPhononEffectParameter.o
	-rm -f sipphononPhononEffect.o
	-rm -f sipphononPhononBackendCapabilitiesNotifier.o
	-rm -f sipphononPhononBackendCapabilities.o
	-rm -f sipphononPhononAudioOutput.o
	-rm -f sipphononPhononAbstractVideoOutput.o
	-rm -f sipphononPhononAbstractAudioOutput.o
	-rm -f sipphononPhononMediaNode.o
	-rm -f sipphononPhonon.o
	-rm -f phonon.exp
