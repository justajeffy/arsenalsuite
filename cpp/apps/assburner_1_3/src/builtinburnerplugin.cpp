
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of RenderLine.
 *
 * RenderLine is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * RenderLine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RenderLine; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id$
 */

#include "job.h"
#include "jobtype.h"

#include "builtinburnerplugin.h"
#include "jobburnerfactory.h"

#include "aftereffectsburner.h"
#include "autodeskburnburner.h"
#include "batchburner.h"
#include "mayaburner.h"
#include "max7burner.h"
#include "maxscriptburner.h"
#include "shakeburner.h"
#include "syncburner.h"

QStringList BuiltinBurnerPlugin::jobTypes()
{
	return QStringList() 
#ifdef COMPILE_MAX7_BURNER
	<< "Max7" << "Max8" << "Max9" << "Max10" << "Max2009"
#endif
#ifdef COMPILE_MAXSCRIPT_BURNER
	<< "MaxScript"
#endif
#ifdef COMPILE_MAYA_BURNER
	<< "Maya7" << "Maya8" << "Maya85" << "Maya2008" << "Maya2009" << "Maya2011"
#endif
#ifdef COMPILE_MENTALRAY_BURNER
	<< "MentalRay7" << "MentalRay8" << "MentalRay85"  << "MentalRay2009" << "MentalRay2011"
#endif
#ifdef COMPILE_BATCH_BURNER
	<< "Batch"
#endif
#ifdef COMPILE_SHAKE_BURNER
	<< "Shake"
#endif
#ifdef COMPILE_AFTER_EFFECTS_BURNER
	<< "AfterEffects" << "AfterEffects7" << "AfterEffects8"
#endif
#ifdef COMPILE_SYNC_BURNER
	<< "Sync"
#endif
#ifdef COMPILE_AUTODESK_BURNER
	<< "AutodeskBurn"
#endif
	;
}

JobBurner * BuiltinBurnerPlugin::createBurner( const JobAssignment & jobAssignment, Slave * slave )
{
	QString jt = jobAssignment.job().jobType().name();
#ifdef COMPILE_MAX7_BURNER
	if( jt == "Max7" || jt == "Max8" || jt == "Max9" || jt == "Max10" || jt == "Max2009" )
		return new Max7Burner( jobAssignment, slave );
#endif
#ifdef COMPILE_MAXSCRIPT_BURNER
	if( jt == "MaxScript" )
		return new MaxScriptBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_BATCH_BURNER
	if( jt == "Batch" )
		return new BatchBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_MAYA_BURNER
	if( jt.contains("Maya") || jt.contains("MentalRay") )
		return new MayaBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_SHAKE_BURNER
	if( jt == "Shake" )
		return new ShakeBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_AFTER_EFFECTS_BURNER
	if( jt.contains("AfterEffects") )
		return new AfterEffectsBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_SYNC_BURNER
	if( jt == "Sync" )
		return new SyncBurner( jobAssignment, slave );
#endif
#ifdef COMPILE_AUTODESK_BURNER
	if( jt == "AutodeskBurn" )
		return new AutodeskBurnBurner( jobAssignment, slave );
#endif
	return 0;
}

void registerBuiltinBurners()
{ JobBurnerFactory::registerPlugin( new BuiltinBurnerPlugin() ); }

