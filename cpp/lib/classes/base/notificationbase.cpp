/*
 *
 * Copyright 2006 Blur Studio Inc.
 *
 * This file is part of the Resin software package.
 *
 * Resin is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Resin is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Resin; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#ifndef COMMIT_CODE

#include "notification.h"
#include "notificationmethod.h"

Notification Notification::create( const QString & component, const QString & event, const QString & subject, const QString & message )
{
	Notification n;
	n.setComponent( component );
	n.setEvent( event );
	n.setSubject( subject );
	n.setMessage( message );
	n.commit();
	return n;
}

NotificationDestination Notification::sendTo( const User & user, const QString & method )
{
	NotificationDestination nd;
	nd.setUser( user );
	nd.setNotificationMethod( NotificationMethod::recordByName( method ) );
	nd.setNotification( *this );
	nd.commit();
	return nd;
}

NotificationDestination Notification::sendTo( const QString & address, const QString & method )
{
	NotificationDestination nd;
	nd.setNotification( *this );
	nd.setNotificationMethod( NotificationMethod::recordByName( method ) );
	nd.setDestination( address );
	nd.commit();
	return nd;
}

#endif // CLASS_FUNCTIONS

