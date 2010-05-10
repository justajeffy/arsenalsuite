if [ "v$V" == "v" ]; then
V=`svn info | grep Revision | cut -f2 -d' '`
fi

if [ `uname -s` == "Linux" ]; then
ARCH="lin64"
PYPATH="/usr/lib/python2.5/site-packages"
SIPPATH="/usr/share/sip"
else
ARCH="osx"
PYPATH="/Library/Python/2.5/site-packages"
SIPPATH="/System/Library/Frameworks/Python.framework/Versions/2.5/share/sip"
fi

echo '***' release stone libs
STONEDIR=/drd/software/ext/stone/$ARCH/$V
mkdir $STONEDIR
rsync -ac $DESTDIR/usr/local/lib/libass* $STONEDIR/
rsync -ac $DESTDIR/usr/local/lib/libabsubmit* $STONEDIR/
rsync -ac $DESTDIR/usr/local/lib/libstone* $STONEDIR/
rsync -ac $DESTDIR/usr/local/lib/libclasses* $STONEDIR/
rsync -ac $DESTDIR/usr/local/lib/libbrainiac* $STONEDIR/
rsync -rtvc --exclude=.svn cpp/lib/stone/include $STONEDIR/
rsync -rtvc --exclude=.svn cpp/lib/stone/.out/*.h $STONEDIR/include/
rsync -rtvc $DESTDIR/usr/bin/sip $STONEDIR/sip
rsync -rtvc --exclude=.svn $SIPPATH/ $STONEDIR/sip.include/
rsync -rtvc --exclude=.svn cpp/lib/stonegui/include $STONEDIR/
rsync -rtvc --exclude=.svn cpp/lib/stonegui/.out/*.h $STONEDIR/include/

rsync -ac cpp/apps/classmaker/classmaker $STONEDIR/
rsync -ac cpp/apps/classmaker/classmaker.ini $STONEDIR/
mkdir $STONEDIR/templates
rsync -ac cpp/apps/classmaker/templates/* $STONEDIR/templates/

echo '***' release python libs
rsync -acv --exclude=wx* $DESTDIR/$PYPATH/blur /drd/software/ext/python/$ARCH/2.5/stone/$V/
rsync -acv $DESTDIR/$PYPATH/sipconfig.py /drd/software/ext/python/$ARCH/2.5/stone/$V/
rsync -acv $DESTDIR/$PYPATH/stoneconfig.py /drd/software/ext/python/$ARCH/2.5/stone/$V/

echo '***' release applications
DIR=/drd/software/ext/ab/$ARCH/$V
mkdir $DIR
rsync -c cpp/apps/assburner_1_3/assburner $DIR/ab
rsync -c cpp/apps/assburner_1_3/assburner.ini $DIR/ab.ini
rsync -c cpp/apps/assburner_1_3/ab-offline.py $DIR/
rsync -ac --exclude=.svn cpp/apps/assburner_1_3/plugins/ $DIR/plugins/
rsync -c cpp/apps/assfreezer/assfreezer $DIR/af
rsync -c cpp/apps/assfreezer/assfreezer.ini $DIR/assfreezer.ini
rsync -ac --exclude=.svn cpp/apps/assfreezer/afplugins/ $DIR/afplugins/

rsync -c cpp/apps/absubmit/absubmit $DIR/
rsync -c cpp/apps/absubmit/py2ab.py $DIR/
rsync -c cpp/apps/absubmit/maya/*py $DIR/
rsync -c cpp/apps/absubmit/maya/*ui $DIR/
rsync -c cpp/apps/absubmit/nukesubmit/nuke2AB.py $DIR/nukesubmit/
rsync -c cpp/apps/absubmit/nukesubmit/*ui $DIR/nukesubmit/

rsync -c python/scripts/manager.py $DIR/
rsync -c python/scripts/reaper.py $DIR/
rsync -c python/scripts/reclaim_tasks.py $DIR/
rsync -c python/scripts/initab.py $DIR/

ln -s /drd/software/ext/ab/images $DIR/images

echo '***' released $V

