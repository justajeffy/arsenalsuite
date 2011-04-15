	


#include <qpushbutton.h>
#include <qinputdialog.h>
#include <qmessagebox.h>

#include "groupsdialog.h"

struct UserGroupItem : public RecordItemBase
{
	UserGroup ug;
	QString name;
	void setup( const Record & r, const QModelIndex & = QModelIndex() );
	QVariant modelData( const QModelIndex & i, int role );
	bool setModelData( const QModelIndex & i, const QVariant & v, int role );
	Qt::ItemFlags modelFlags( const QModelIndex & i );
	int compare( const QModelIndex &, const QModelIndex &, int column, bool asc );
	Record getRecord() { return ug; }
};

typedef TemplateRecordDataTranslator<UserGroupItem> UserGroupTranslator;

void UserGroupItem::setup( const Record & r, const QModelIndex & )
{
	ug = r;
	name = ug.group().name();
}

QVariant UserGroupItem::modelData( const QModelIndex & i, int role )
{
	int col = i.column();
	if( col == 0 && role == Qt::CheckStateRole )
		return ug.isRecord() ? Qt::Checked : Qt::Unchecked;
	if( col == 0 && role == Qt::DisplayRole )
		return ug.group().name();
	return QVariant();
}

bool UserGroupItem::setModelData( const QModelIndex & i, const QVariant & v, int role )
{
	int col = i.column();
	if( col == 0 && role == Qt::CheckStateRole ) {
		Qt::CheckState cs = Qt::CheckState(v.toInt());
		if( cs == Qt::Checked )
			ug.commit();
		else
			ug.remove();
		return true;
	}
	return false;
}

Qt::ItemFlags UserGroupItem::modelFlags( const QModelIndex & i )
{
	if( i.column() == 0 )
		return Qt::ItemFlags( Qt::ItemIsUserCheckable | Qt::ItemIsEnabled );
	return Qt::ItemFlags( Qt::ItemIsEnabled );
}

int UserGroupItem::compare( const QModelIndex & idx, const QModelIndex & idx2, int column, bool asc )
{
	int diff = int(ug.isRecord()) - int(UserGroupTranslator::data(idx2).ug.isRecord());
	return diff ? diff : ItemBase::compare(idx,idx2,column,asc);
}

GroupsDialog::GroupsDialog( QWidget * parent )
: QDialog( parent )
{
	setupUi( this );
	connect( Group::table(), SIGNAL( added( RecordList ) ), SLOT( reset() ) );
	connect( Group::table(), SIGNAL( removed( RecordList ) ), SLOT( reset() ) );
	connect( mNewGroup, SIGNAL( clicked() ), SLOT( newGroup() ) );
	connect( mDeleteGroup, SIGNAL( clicked() ), SLOT( deleteGroup() ) );
	
	RecordSuperModel * sm = new RecordSuperModel( mGroupTree );
	new UserGroupTranslator(sm->treeBuilder());
	mGroupTree->setModel( sm );
	sm->setHeaderLabels( QStringList() << "Group" );
	sm->setAutoSort(true);
	sm->sort(0,Qt::DescendingOrder);

	if( !User::hasPerms( "Group", true ) ) {
		mNewGroup->setEnabled( false );
		mDeleteGroup->setEnabled( false );
	}
}

void GroupsDialog::reset()
{
}

void GroupsDialog::setUser( const User & u )
{
	reset();
	mUser = u;
	UserGroupList ugl = UserGroup::recordsByUser( u );
	GroupList gl = Group::select();
	gl -= ugl.groups();
	foreach( Group g, gl ) {
		UserGroup ug;
		ug.setUser( u );
		ug.setGroup( g );
		ugl += ug;
	}
	mGroupTree->model()->setRootList( ugl );
}

User GroupsDialog::user()
{
	return mUser;
}

void GroupsDialog::newGroup()
{
	QString groupName = QInputDialog::getText( this, "New Group", "Enter the Group Name:" );
	if( groupName.isEmpty() )
		return;
		
	if( Group::recordByName( groupName ).isRecord() ) {
		QMessageBox::warning( this, "Group Already Exists", "Group " + groupName + " already exists" );
		return;
	}
	
	Group newGrp;
	newGrp.setName( groupName );
	newGrp.commit();
}

void GroupsDialog::deleteGroup()
{
//	GroupItem * gi = (GroupItem*)mGroupList->currentItem();
//	if( gi ) {
//		gi->mGroup.remove();
//		delete gi;
//	}
}

void GroupsDialog::accept()
{
//	if( mUser.isRecord() ) {
//		mRemoved.remove();
//		mAdded.commit();
//	}
	
	QDialog::accept();
}

GroupList GroupsDialog::checkedGroups()
{
	GroupList gl;
//	for( Q3ListViewItemIterator it( mGroupList, Q3ListViewItemIterator::Checked ); it.current(); ++it )
//		gl += ((GroupItem*)it.current())->mGroup;
	return gl;
}
	
void GroupsDialog::setCheckedGroups( GroupList gl )
{
	reset();
//	st_foreach( GroupIter, it, gl )
//		if( mGroupMap.contains( *it ) )
//			mGroupMap[*it]->setOn( true );
}

