/*
 *
 * Copyright 2003, 2004 Blur Studio Inc.
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

#include <qcheckbox.h>
#include <qcombobox.h>
#include <qgroupbox.h>
#include <qlineedit.h>
#include <qpushbutton.h>

#include "elementui.h"
#include "host.h"
#include "userdialog.h"
#include "groupsdialog.h"
#include "database.h"

/**
 * Adds all of the host names to the combobox cb, and
 * sets the selected item to the host sel, if sel.isRecord()
 * returns true
 **/
void addHosts( QComboBox * cb, const Host & sel = Host() )
{
	cb->clear();
	QStringList hostSort = Host::select().names();
	hostSort.sort();
	
	cb->addItem( "Host not set" );
	cb->addItems( hostSort );
	
	int idx = cb->findText( sel.name() );
	if( idx >= 0 )
		cb->setCurrentIndex( idx );
}

UserDialog::UserDialog( QWidget * parent )
: QDialog( parent )
, mIsEmp( true )
{
	setupUi( this );

	connect( mEmployeeGroup, SIGNAL( toggled( bool ) ), SLOT( slotEmpToggle( bool ) ) );
	connect( mEditGroups, SIGNAL( clicked() ), SLOT( slotEditGroups() ) );
	addHosts( mHostCombo );
	
	if( !User::hasPerms( "UsrGrp", true ) ) {
		mEditGroups->setText( "View Groups" );
		mEditGroups->setEnabled( User::hasPerms( "UsrGrp" ) && User::hasPerms( "Group" ) );
	}
	
	mUser = Employee();
}

Employee UserDialog::employee() const
{
	Employee e( user() );
	if( !e.isRecord() ){
		e.setElementType( User::type() );
		e.setDateOfTermination( QDate() );
	}
	e.setName( mUserName->text() );
	e.setPassword( mPassword->text() );
	e.setEmail( mEmail->text() );
	e.setFirstName( mFirst->text() );
//	e.setMiddleName( mMiddle->text() );
	e.setLastName( mLast->text() );
	e.setJid( mJid->text() );
	return e;
}

User UserDialog::user() const
{
	mUser.setName( mUserName->text() );
	mUser.setUsr( mUserName->text() );
	mUser.setPassword( mPassword->text() );
	mUser.setThreadNotifyByEmail( mNotifyEmailCheck->isChecked() ? 1 : 0 );
	mUser.setThreadNotifyByJabber( mNotifyJabberCheck->isChecked() ? 1 : 0 );
	mUser.setHomeDir( "/home/netftp/ftpRoot/" + mUserName->text() );
	mUser.setShell( mShellCheck->isChecked() ? "/bin/bash" : "/bin/false" );
	mUser.setHost( Host::recordByName( mHostCombo->currentText() ) );
	if( !mUser.gid() )
		mUser.setGid( User::nextGID() );
	if( !mUser.uid() )
		mUser.setUid( User::nextUID() );
	return mUser;
}

void UserDialog::setUser( const User & u )
{
	mUserName->setText( u.name() );
	mPassword->setText( u.password() );
	Host h = u.host();
	int idx = mHostCombo->findText( h.name() );
	mHostCombo->setCurrentIndex( qMax(0,idx) );
	mNotifyEmailCheck->setChecked( u.threadNotifyByEmail() );
	mNotifyJabberCheck->setChecked( u.threadNotifyByJabber() );
	mShellCheck->setChecked( u.shell() == "/bin/bash" );
	slotEmpToggle( Employee( u ).isRecord() );
	
	mPixmapLabel->setPixmap( ElementUi(u).image( mPixmapLabel->size() ) );

	bool canEdit = User::hasPerms( "Usr", true );
	mAdminGroup->setEnabled( canEdit );
	mEmployeeGroup->setEnabled( canEdit );

	mUser = u;
}

void UserDialog::setEmployee( const Employee & e )
{
	mFirst->setText( e.firstName() );
	mLast->setText( e.lastName() );
	mJid->setText( e.jid() );
	mEmail->setText( e.email() );
	setUser( e );
}

void UserDialog::slotEmpToggle( bool emp )
{
	mIsEmp = emp;
	mEmployeeGroup->setChecked( emp );
}

void UserDialog::accept()
{
	if( !mUser.isRecord() ) {
		User u;
		if( mIsEmp ) {
			mUser = Employee();
			u = employee();
		} else {
			mUser = User();
			u = user();
		}
		u.commit();
		u.setKeyUsr( u.key() );
		u.commit();
		UserGroupList ugl;
		foreach( Group g, mNewUserGroups )
		{
			UserGroup ug;
			ug.setUser( u );
			ug.setGroup( g );
			ugl += ug;
		}
		ugl.commit();
	} else {
		if( Employee( mUser ).isRecord() != mIsEmp ) {
			// FIXME
		}
		if( mIsEmp )
			employee().commit();
		else
			user().commit();
	}
	QDialog::accept();
}

void UserDialog::slotEditGroups()
{
	GroupsDialog * gd = new GroupsDialog( this );
	Database::current()->beginTransaction( "Edit User Group Associations" );

	if( mUser.isRecord() )
		gd->setUser( mUser );
	else
		gd->setCheckedGroups( mNewUserGroups );
	if( gd->exec() == QDialog::Accepted )
		Database::current()->commitTransaction();
	else
		Database::current()->rollbackTransaction();

	if( !mUser.isRecord() )
		mNewUserGroups = gd->checkedGroups();
	delete gd;
}




