
#include "resultset.h"

RecordList ResultSet::row(int row) const
{
	RecordList ret;
	for( int i = 0; i < columns(); i++ )
		ret += at(row,i);
	return ret;
}

Record ResultSet::at(int row, int column) const
{
	if( row < 0 || column < 0 || column >= mData.size() )
		return Record();
	const RecordList & rl = mData.at(column);
	if( row >= rl.size() )
		return Record();
	return rl[row];
}

ResultSet & ResultSet::append( ResultSet rs )
{
	if( !mData.isEmpty() && rs.columns() != columns() ) {
		LOG_1( "Attempt to append a resultset with different number of columns" );
		return *this;
	}
	
	if( mData.isEmpty() )
		*this = rs;
	else
		for( int i = 0; i < columns(); ++i )
			mData[i] += rs.column(i);
	return *this;
}
