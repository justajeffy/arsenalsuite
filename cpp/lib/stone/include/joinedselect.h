
#ifndef JOINED_SELECT_H
#define JOINED_SELECT_H

#include <qlist.h>
#include <qstring.h>
#include <qvariant.h>

#include "blurqt.h"

typedef QList<QVariant> VarList;

namespace Stone {

class Table;
class ResultSet;

enum JoinType {
	InnerJoin,
	LeftJoin,
	RightJoin,
	OuterJoin
};

class STONE_EXPORT JoinCondition
{
public:
	QString condition, alias;
	JoinType type;
	Table * table;
	bool ignoreResults;
};

class STONE_EXPORT JoinedSelect
{
public:
	JoinedSelect(Table * primaryTable, QList<JoinCondition> joinConditions = QList<JoinCondition>());
	JoinedSelect(Table * primaryTable, const QString & alias);
	
	QString alias() const;
	Table * table() const;
	QList<JoinCondition> joinConditions() const;

	JoinedSelect & join( Table * joinTable, const QString & condition = QString(), JoinType type = InnerJoin, bool ignoreResults = false, const QString & alias = QString() );
	template<typename T> JoinedSelect & join( QString condition = QString(), JoinType joinType = InnerJoin, bool ignoreResults = false, const QString & alias = QString() )
	{ return join( T::table(), condition, joinType, ignoreResults, alias ); }

	ResultSet select(const QString & where = QString(), VarList args = VarList());
	
protected:
	ResultSet selectSingleTable(const QString & where, VarList args);
	ResultSet selectInherited(int condInheritIndex, const QString & where, VarList args);
	JoinedSelect updateConditions( Table * oldTable, Table * newTable );
	bool finalize();
	
	Table * mTable;
	QString mAlias;
	QList<JoinCondition> mJoinConditions;
};

}; // namespace Stone

#include "resultset.h"

#endif // JOINED_SELECT_H
