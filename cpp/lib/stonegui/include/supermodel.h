
#ifndef SUPER_MODEL_H
#define SUPER_MODEL_H

#include <qabstractitemmodel.h>
#include <qbitarray.h>
#include <qlist.h>
#include <qstringlist.h>
#include <qvector.h>

#include <stdio.h>
#include <typeinfo>

#include "stonegui.h"

#include "modeliter.h"
class QVariant;

class ModelDataTranslator;
class ModelNode;
class SuperModel;

/**
 * This class is used to dynamically build the tree hierarchy of the model
 * as children are requested.  It also allows you to define sorting between
 * different types of items.
 *
 * This class only needs to be used if you doing one or more of the following
 * 1) Generating the hierarchy on demand
 * 2) Using more than one item type and need to sort them based on the type
 *
 * Because the types are not tied directly to the ModelTreeBuilder, you can
 * provide different implementations of the ModelTreeBuilder that share types
 * in order to provide different hierarchies without rewriting the type code
 */
class STONEGUI_EXPORT ModelTreeBuilder : public QObject
{
public:
	ModelTreeBuilder( SuperModel * parent );
	~ModelTreeBuilder();
	/// Return true if the parentIndex has children
	/// If you return true you should load the children in the loadChildren method
	/// Default implementation returns false
	virtual bool hasChildren( const QModelIndex & parentIndex, SuperModel * model );
	/// Called to load children of parentIndex. Default implementation does nothing
	virtual void loadChildren( const QModelIndex & parentIndex, SuperModel * model );
	/// This is used to compare to rows of different types
	/// Rows of the same type are compared through the translator
	virtual int compare( const QModelIndex & a, const QModelIndex & b, QList<int> columns, bool asc );
	SuperModel * model() { return mModel; }

	ModelDataTranslator * defaultTranslator();

protected:
	void _loadChildren( const QModelIndex & parentIndex, SuperModel * model, ModelNode * node );
	SuperModel * mModel;
	ModelNode * mLoadingNode;

	void setTranslator( ModelDataTranslator * trans );
	void addTranslator(ModelDataTranslator *);
	QList<ModelDataTranslator*> mTranslators;
	friend class ModelDataTranslator;
	friend class SuperModel;
	friend class ModelNode;
};

/// This class is used to interface between the generic data storage of 
/// the SuperModel's ModelNode class, and between a specific type of data
/// Usually this class is to be used through the TemplateDataTranslator
class STONEGUI_EXPORT ModelDataTranslator
{
public:
	// builder takes ownership of this
	ModelDataTranslator( ModelTreeBuilder * builder );
	virtual ~ModelDataTranslator() {};

	// These methods are used by SuperModel/ModelNode

	/// This function must return the same value throughout the life of the object
	virtual int dataSize() = 0;
	virtual QVariant modelData( void * dataPtr, const QModelIndex &, int role ) const = 0;
	virtual bool setModelData( void * dataPtr, const QModelIndex &, const QVariant & value, int role ) = 0;
	virtual Qt::ItemFlags modelFlags( void * dataPtr, const QModelIndex & ) const = 0;
	virtual int compare( void * dataPtr, void * dataPtr2, const QModelIndex & idx1, const QModelIndex & idx2, int column, bool asc ) const = 0;
	virtual void deleteData( void * dataPtr ) = 0;
	virtual void constructData( void * dataPtr, void * copy = 0 ) = 0;
	virtual void copyData( void * dataPtr, void * copy ) = 0;
	virtual const void * iface( const char * ) const { return 0; }
	QModelIndex insert( int row, const QModelIndex & parent = QModelIndex() );
	QModelIndex append( const QModelIndex & parent = QModelIndex() );

	static void * dataPtr( const QModelIndex & idx );
	static ModelDataTranslator * translator( const QModelIndex & idx );
	SuperModel * model() { return mBuilder->model(); }
protected:
	ModelTreeBuilder * mBuilder;
};

template<class TYPE, class BASE = ModelDataTranslator> class TemplateDataTranslator : public BASE
{
public:
	// builder takes ownership of this
	TemplateDataTranslator( ModelTreeBuilder * builder )
	: BASE(builder) {}

	int dataSize();
	QVariant modelData( void * dataPtr, const QModelIndex & idx, int role ) const;
	bool setModelData( void * dataPtr, const QModelIndex & idx, const QVariant & value, int role );
	Qt::ItemFlags modelFlags( void * dataPtr, const QModelIndex & idx ) const;
	int compare( void * dataPtr, void * dataPtr2, const QModelIndex & idx1, const QModelIndex & idx2, int column, bool asc ) const;
	void deleteData( void * dataPtr );
	void constructData( void * dataPtr, void * copy = 0 );
	void copyData( void * dataPtr, void * copy );
	static bool equals( const TYPE & t1, const TYPE & t2 );
	static TYPE & data( const QModelIndex & idx );

	using BASE::insert;
	using BASE::append;
	template<class PARAM> QModelIndex insert( int row, const PARAM &, const QModelIndex & parent = QModelIndex() );
	template<class PARAM> QModelIndex append( const PARAM &, const QModelIndex & parent = QModelIndex() );

	template<class LIST> QModelIndexList insertList( int row, const LIST &, const QModelIndex & parent = QModelIndex() );
	template<class LIST> QModelIndexList appendList( const LIST &, const QModelIndex & parent = QModelIndex() );

	static bool isType( const QModelIndex & idx );
	static QModelIndex findFirst( ModelIter it, const TYPE & type );
};

/// This is the generic base class for TemplateDataTranslator items types
/// It provides qVariantCmp based sorting, and defaults to enabled and selectable items
struct STONEGUI_EXPORT ItemBase {
	bool operator==(const ItemBase & other) const { return &other == this; }
	QVariant modelData( const QModelIndex & idx, int role ) const { 
		Q_UNUSED(idx);
		Q_UNUSED(role);
		return QVariant(); 
	}
	bool setModelData( const QModelIndex &, const QVariant &, int ) { return false; }
	Qt::ItemFlags modelFlags( const QModelIndex & ) { return Qt::ItemFlags(Qt::ItemIsEnabled | Qt::ItemIsSelectable); }
	int compare( const QModelIndex & idx, const QModelIndex & idx2, int column, bool ) const;
};

/// StandardItem/StandardTranslator provides a simple type that allows
/// Storing QVariant data per column and role.  Useful when more complicated
/// storage and functionality is not required.  This also serves as an
/// example of how to implement a custom type
struct STONEGUI_EXPORT StandardItem : public ItemBase
{
	struct DataItem {
		int role, column;
		QVariant data;
	};
	QList<DataItem> mData;
	int findItem(int column, int role) const;
	QVariant modelData( const QModelIndex & idx, int role ) const;
	bool setModelData( const QModelIndex &, const QVariant &, int );
};

typedef TemplateDataTranslator<StandardItem> StandardTranslator;

class STONEGUI_EXPORT ModelNode
{
public:
	ModelNode( ModelNode * parent = 0, int parentRow = 0 );
	~ModelNode();

	ModelDataTranslator * translator() const { return mTranslator; }
	void setTranslator( ModelDataTranslator * translator );

	// Tree Builder is responsible for initializing the
	// data after calling insertChildren
	bool insertChildren( int index, int count, ModelDataTranslator * trans = 0 );

	// Tree Builder is responsible for clearing the data
	// before calling removeChildren
	bool removeChildren( int index, int count );
	void clearChildren( const QModelIndex & idx );
	void clear();

	void swap( const QModelIndex & a, const QModelIndex & b );

	int rowCount();

	bool hasChildren( const QModelIndex & idx, bool insert = false );
	QVariant data( const QModelIndex & idx, int role );
	bool setData( const QModelIndex & idx, const QVariant & value, int role );
	Qt::ItemFlags flags( const QModelIndex & idx );
	bool childrenLoaded( const QModelIndex & idx );
	int compare( const QModelIndex & idx1, const QModelIndex & idx2, const QList<int> & columns, bool asc );

	ModelNode * child( const QModelIndex & idx, bool insert = false );

	void sort ( const QList<int> & columns, bool asc, bool recursive, const QModelIndex & parent, int startRow, int endRow );

	ModelDataTranslator * translator(const QModelIndex & idx);
protected:
	void * itemData( const QModelIndex & );
	void * _itemData( int dataIndex );
	ModelDataTranslator * _translator(int translatorIndex) const;
	SuperModel * model(const QModelIndex &idx);

	//ModelNode * childNode(int dataIndex, bool allowLoad);

	// Currently no entries are ever removed, they are just
	// no longer used due to having no entry in mRowDataIndexVector
	// pointing to them
	// TODO: Add empty entry reuse, and possible defrag when wasted space gets high
	QBitArray mNoChildrenArray;
	
	// Since 
	QVector<ModelNode *> mChildren;

	struct ItemInfo {
		// Offset into the mItemData bytearray
		int dataOffset;

		// Index into mNoChildrenArray and mChildren vector
		uint index:22; // Allows 4 million rows

		// Index into the translator list
		uint translatorIndex:10; // Allows 1024 translators (row types)
	};

	ItemInfo & rowToItemInfo(int row);

	QVector<ItemInfo> mItemInfoVector;

	int mRowCount;
	QByteArray mItemData;

	// Since majority of uses only have 1 translator, keeping
	// it directly in a variable will allow us to avoid allocating
	// any memory for the list	
	ModelDataTranslator * mTranslator;

	QList<ModelDataTranslator*> mTranslatorList;

	ModelNode * mParent;
	int mParentRow;
	
	struct NodeSorter;
	friend class SuperModel;
	friend class ModelDataTranslator;
};

class STONEGUI_EXPORT SuperModel : public QAbstractItemModel
{
public:
	SuperModel( QObject * parent );
	~SuperModel();

	void setTreeBuilder( ModelTreeBuilder * treeBuilder );
	/// O(1) - Constant Runtime
	QModelIndex parent( const QModelIndex & idx ) const;

	/// O(1) - Constant Runtime
    /// this is not virtual from QAbstractItemModel for some reason..
	QModelIndex sibling( int row, int column, const QModelIndex & idx ) const;

/*
 * BEGIN AbstractItemModel functions
 */	

	/// O(1) - Constant Runtime
	/// Runtime dependent on node->child call, which could 
	/// be loading the data on demand
	virtual QModelIndex index( int row, int column, const QModelIndex & parent = QModelIndex() ) const;

	/// O(1) - Constant Runtime
	/// Runtime dependent on childNode->rowCount call, which could 
	/// be loading the data on demand
	virtual int rowCount( const QModelIndex & parent = QModelIndex() ) const;

	/// O(1) - Constant Runtime
	/// Runtime dependent on node->hasChildren call, which could 
	/// be loading the data on demand
	virtual bool hasChildren( const QModelIndex & parent ) const;

	virtual int columnCount ( const QModelIndex & parent = QModelIndex() ) const;

	virtual QVariant data ( const QModelIndex & index, int role = Qt::DisplayRole ) const;

	virtual bool setData ( const QModelIndex & index, const QVariant & value, int role = Qt::EditRole );

	virtual bool dropMimeData ( const QMimeData * data, Qt::DropAction action, int row, int column, const QModelIndex & parent );

	virtual Qt::ItemFlags flags ( const QModelIndex & index ) const;

	virtual QVariant headerData ( int section, Qt::Orientation orientation, int role = Qt::DisplayRole ) const;

	virtual bool removeRows( int start, int count, const QModelIndex & parent = QModelIndex() );

	virtual void sort ( int column, Qt::SortOrder order = Qt::DescendingOrder)
	{ sort( column, order, true ); }

/*
 * END AbstractItemModel functions
 */

    // convenience function to append rows
	QModelIndex append( const QModelIndex & par = QModelIndex(), ModelDataTranslator * trans = 0 )
	{ return insert( par, rowCount(par), trans ); }

	QList<QModelIndex> append( const QModelIndex & par, int cnt, ModelDataTranslator * trans = 0 )
	{ return insert( par, rowCount(par), cnt, trans ); }

	QModelIndex insert( const QModelIndex & par, int row, ModelDataTranslator * = 0 );

	QModelIndexList insert( const QModelIndex & par, int rowStart, int cnt, ModelDataTranslator * = 0 );

	void remove( const QModelIndex & i );
	void remove( QModelIndexList );
	void clear();

	void swap( const QModelIndex & a, const QModelIndex & b );

	void sort ( int column, Qt::SortOrder order, bool recursive, int startRow=0, int endRow=-1 )
	{ sort( column, order, recursive, QModelIndex(), startRow, endRow ); }

	void sort ( int column, Qt::SortOrder order, bool recursive, const QModelIndex & parent, int startRow=0, int endRow=-1 );

	bool childrenLoaded( const QModelIndex & );

	void clearChildren( const QModelIndex & i );

	// Inform the model that you have changed some of the data
	void dataChange( const QModelIndex &, const QModelIndex & = QModelIndex() );

	// Sorts the model without changing any of the sort settings(column order, sort order)
	void resort();

	bool autoSort() const { return mAutoSort; }
	void setAutoSort( bool as );

	void setHeaderLabels( const QStringList & labels );
	QStringList headerLabels() const;

	QList<int> sortColumns() const { return mSortColumnOrder; }
	void setSortColumns( const QList<int> & sortColumns, bool forceResort = false );

	ModelTreeBuilder * treeBuilder();

	ModelDataTranslator * translator( const QModelIndex & ) const;

	struct STONEGUI_EXPORT InsertClosure {
		InsertClosure(SuperModel *);
		~InsertClosure();
		SuperModel * mModel;
	};

    void setColumnFilter( uint column, const QString & filterString );
    QMap<uint, QString> mColumnFilterMap;

protected:
	/// O(1) - Constant Runtime
	static inline ModelNode * indexToNode( const QModelIndex & idx )
	{
		return reinterpret_cast<ModelNode*>(idx.internalPointer());
	}

	QModelIndex nodeToIndex( int row, int column, ModelNode * node );
	using QAbstractItemModel::changePersistentIndexList;
	using QAbstractItemModel::persistentIndexList;

	void _sort ( int column, Qt::SortOrder order, bool recursive, const QModelIndex & parent, int startRow, int endRow, bool quiet );

	void openInsertClosure();
	void closeInsertClosure();

	void checkAutoSort(const QModelIndex & parent = QModelIndex(), bool quiet=false);

	ModelNode * rootNode() const;

	mutable ModelNode * mRootNode;
	ModelTreeBuilder * mTreeBuilder;
	struct InsertClosureNode {
		unsigned short count:14;
		unsigned short state:2; // 0 - NEW, 1 - Valid(Post beginInsertRows), 2 - Invalid(No beginInsertRows call)
		QPersistentModelIndex parent; // Used to check auto sort after the insert closure
		InsertClosureNode * next;
	};
	InsertClosureNode * mInsertClosureNode;
	mutable bool mBlockInsertNots;

	QStringList mHeaderData;
	QList<int> mSortColumnOrder;
	Qt::SortOrder mSortOrder;
	bool mAutoSort, mAssumeChildren, mDisableChildLoading;
	friend class ModelDataTranslator;
	friend class ModelNode;

};

template<class TYPE, class BASE> int TemplateDataTranslator<TYPE,BASE>::dataSize()
{ return sizeof(TYPE); }

template<class TYPE, class BASE> QVariant TemplateDataTranslator<TYPE,BASE>::modelData( void * dataPtr, const QModelIndex & idx, int role ) const
{ return ((TYPE*)dataPtr)->modelData(idx,role); }

template<class TYPE, class BASE> bool TemplateDataTranslator<TYPE,BASE>::setModelData( void * dataPtr, const QModelIndex & idx, const QVariant & value, int role )
{ return ((TYPE*)dataPtr)->setModelData( idx, value, role ); }

template<class TYPE, class BASE> Qt::ItemFlags TemplateDataTranslator<TYPE,BASE>::modelFlags( void * dataPtr, const QModelIndex & idx ) const
{ return Qt::ItemFlags(((TYPE*)dataPtr)->modelFlags( idx )); }

template<class TYPE, class BASE> int TemplateDataTranslator<TYPE,BASE>::compare( void * dataPtr, void * , const QModelIndex & idx1, const QModelIndex & idx2, int column, bool asc ) const
{ return ((TYPE*)dataPtr)->compare( idx1, idx2, column, asc ); }

template<class TYPE, class BASE> void TemplateDataTranslator<TYPE,BASE>::deleteData( void * dataPtr )
{ ((TYPE*)dataPtr)->~TYPE(); }

template<class TYPE, class BASE> void TemplateDataTranslator<TYPE,BASE>::constructData( void * dataPtr, void * copy )
{
	if( copy )
		new(dataPtr) TYPE(*((TYPE*)copy));
	else
		new(dataPtr) TYPE();
}

template<class TYPE, class BASE> void TemplateDataTranslator<TYPE,BASE>::copyData( void * dataPtr, void * copy )
{ *((TYPE*)dataPtr) = *((TYPE*)copy);}

template<class TYPE, class BASE> bool TemplateDataTranslator<TYPE,BASE>::equals( const TYPE & t1, const TYPE & t2 )
{ return t1 == t2; }

template<class TYPE, class BASE> bool TemplateDataTranslator<TYPE,BASE>::isType( const QModelIndex & idx )
{ return dynamic_cast<TemplateDataTranslator<TYPE,BASE> *>( BASE::translator(idx) ) != 0; }

template<class TYPE, class BASE> QModelIndex TemplateDataTranslator<TYPE,BASE>::findFirst( ModelIter it, const TYPE & type )
{
	for(; it.isValid(); ++it )
		if( isType(*it) && equals(data(*it),type) ) return *it;
	return QModelIndex();
}

template<class TYPE, class BASE> TYPE & TemplateDataTranslator<TYPE,BASE>::data( const QModelIndex & idx )
{
	if( isType(idx) ) return *(TYPE*)BASE::dataPtr(idx);
	const char * myType = typeid(TemplateDataTranslator<TYPE,BASE>).name();
	ModelDataTranslator * other = BASE::translator(idx);
	const char * otherType = other ? typeid(*other).name() : "unknown type";
	printf( "WARNING: Calling %s::data on %s index\n", myType, otherType );
	abort();
	return *(TYPE*)0;
}

template<class TYPE, class BASE> template<class PARAM> QModelIndex TemplateDataTranslator<TYPE,BASE>::insert( int row, const PARAM & param, const QModelIndex & parent )
{
	SuperModel * model = BASE::model();
	SuperModel::InsertClosure closure(model);
	QModelIndex idx = model->insert( parent, row, this );
	data(idx) = TYPE(param);
	return idx;
}

template<class TYPE, class BASE> template<class PARAM> QModelIndex TemplateDataTranslator<TYPE,BASE>::append( const PARAM & param, const QModelIndex & parent )
{
	SuperModel * model = BASE::model();
	SuperModel::InsertClosure closure(model);
	QModelIndex idx = model->append( parent, this );
	data(idx) = TYPE(param);
	return idx;
}

template<class TYPE, class BASE> template<class LIST> QModelIndexList TemplateDataTranslator<TYPE,BASE>::insertList( int row, const LIST & list, const QModelIndex & parent )
{
	if( list.size() <= 0 ) return QModelIndexList();
	SuperModel * model = BASE::model();
	SuperModel::InsertClosure closure(model);
	QModelIndexList ret = model->insert( parent, row, list.size(), this );
	for( int i=0; i < list.size(); ++i )
		data(ret[i]) = TYPE(list[i]);
	return ret;
}

template<class TYPE, class BASE> template<class LIST> QModelIndexList TemplateDataTranslator<TYPE,BASE>::appendList( const LIST & list, const QModelIndex & parent )
{
	if( list.size() <= 0 ) return QModelIndexList();
	SuperModel * model = BASE::model();
	SuperModel::InsertClosure closure(model);
	QModelIndexList ret = model->append( parent, list.size(), this );
	for( int i=0; i < list.size(); ++i )
		data(ret[i]) = TYPE(list[i]);
	return ret;
}


#endif // SUPER_MODEL_H
