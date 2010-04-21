
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

/* $Header$
 */

#ifndef GL_WINDOW_H
#define GL_WINDOW_H

//#define COMPILE_CG

#ifdef COMPILE_CG
#include <Cg/cg.h>
#include <Cg/cgGL.h>
#endif

#include <QGLWidget>

#include "afcommon.h"

class QImage;

struct ASSFREEZER_EXPORT TexInfo
{
	TexInfo()
	: handle( 0 )
	{}
	
	GLuint handle;
	float umax, vmax, aspect;
	int width, height;
};

class ASSFREEZER_EXPORT GLWindow : public QGLWidget
{
Q_OBJECT
public:
	GLWindow(QWidget * parent=0);
	~GLWindow();

	void setupTextureMode();
	void initializeGL();

	TexInfo loadImage( QImage * imgPtr );
	TexInfo loadImage( int w, int h, uchar * bits, GLenum format );

	void showImage( TexInfo texInfo );

	void paintGL();

	void resizeGL( int w, int h );
	void updateTextureCoords();

	enum {
		RedChannel,
		BlueChannel,
		GreenChannel,
		AlphaChannel,
		AllChannel
	};

	void setColorMode( int colorMode );
	
	/*
	 * Image scaling modes
	 */
	enum {
		ScaleNone = 0,
		ScaleDown = 1,
		ScaleUp = 2,
		ScaleAlways = 3
	};

	void setScaleMode( int scaleMode );
	int scaleMode() const;

	void setScaleFactor( float scaleFactor );
	float scaleFactor() const;

signals:
	void scaleFactorChange( float );

protected:

	float tex_x, tex_y, tex_w, tex_h;
	GLuint mTextureMode;

	TexInfo mCurrentTexture;

#ifdef COMPILE_CG
	CGprogram cgProgram;
	CGcontext cgContext;
	CGprofile cgFragmentProfile;

	CGparameter cgImageParam, cgColorClampParam;
#endif

	bool mUseCG;
	bool mTextureValid;
	int mColorMode, mScaleMode;
	float mScaleFactor;
	bool mUseGL_NV_texture_rectangle;
};


#endif // GL_WINDOW_H
