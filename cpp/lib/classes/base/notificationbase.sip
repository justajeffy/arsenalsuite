
static MappedRecord create( const QString & component, const QString & event, const QString & subject, const QString & message = QString() );

MappedRecord sendTo( const User & user, const QString & method = QString() );
MappedRecord sendTo( const QString & address, const QString & method );
