
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of Assburner.
 *
 * Assburner is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Assburner is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Blur; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Author$
 * $LastChangedDate: 2007-06-19 04:27:47 +1000 (Tue, 19 Jun 2007) $
 * $Rev: 4632 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/include/imageview.h $
 */

#ifndef IMAGE_VIEW_H
#define IMAGE_VIEW_H

#include <qwidget.h>
#include <qdatetime.h>
#include <qlist.h>
#include <qpixmap.h>

#include "imagecache.h"

#include "afcommon.h"

class QImage;
class GLWindow;
class LTGA;
class LoadImageTask;

class ASSFREEZER_EXPORT ImageView : public QWidget
{
Q_OBJECT
public:
	ImageView(QWidget * parent=0);
	~ImageView();
	
	// Setup
	void setFrameRange(const QString & basePath, int start, int end );
	const QString & basePath() const;

	bool looping() const;

	float scaleFactor() const;
#ifdef USE_IMAGE_MAGICK
	static QImage loadImageMagick(const QString &);
#endif

public slots:

	// Navigation
	void setImageNumber(int in=-1);
	void showFrameCycler(int fn=-1);
	void showOutputPath(int fn=-1);
	void next();
	void prev();
	void play();
	void pause();

	void showAlpha( bool );
	void setScaleMode( int );
	void setScaleFactor( float );
	
	void destroyTexInfo( const TexInfo & );
	void setLooping( bool );

//	int cacheStatus( int fn );

signals:
	void scaleFactorChange( float sf );
	void scaleModeChange( int );
	void frameStatusChange(int,int);

protected:
	void customEvent( QEvent * );
    bool event( QEvent * );
	void showImage();
	virtual void paintEvent(QPaintEvent *);
	virtual void mousePressEvent(QMouseEvent *);
	virtual void mouseMoveEvent(QMouseEvent *);
	virtual void resizeEvent(QResizeEvent *);
	virtual void wheelEvent(QWheelEvent *);
	virtual void keyPressEvent( QKeyEvent * );

	void preloadImages();
	void loadImage( const QString & path, int image );
private:

	QString mBasePath;

	int mShown, mToShow;

	QImage mCurrentImage;
	QPixmap mScaled;
	
	bool mShowAlpha;
	bool mPlaying;
	bool mAllFramesLoaded;

	GLWindow * mGLWindow;

	ImageCache mImageCache;
	QTime mLastFrameTime;

	int mMinFrame, mMaxFrame;

	bool mLooping;

	// Mark the globalX pos on last most press/move
	int mMoveStartPos;

	QList<LoadImageTask*> mTasks;
};


#endif // IMAGE_VIEW_H

