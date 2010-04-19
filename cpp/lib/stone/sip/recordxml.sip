
class RecordXmlSaver
{
%TypeHeaderCode
#include <recordxml.h>
%End
public:
	RecordXmlSaver(RecordList rl = RecordList());

	QList<QDomElement> addRecords( RecordList rl );
	QDomElement addRecord( const Record & r );

	QDomDocument document() const;
	bool saveToFile(const QString & fileName, QString * errorMessage = 0);

	static bool toFile(RecordList rl, const QString & fileName, QString * errorMessage = 0);
	static QDomDocument toDocument(RecordList rl, QString * errorMessage = 0);
};


class RecordXmlLoader
{
%TypeHeaderCode
#include <recordxml.h>
%End
public:
	RecordXmlLoader(const QString & fileName);
	RecordXmlLoader(QDomDocument document);
	RecordXmlLoader();

	RecordList records() const;
	QMap<Record,QDomElement> recordElementMap() const;

	bool loadFile( const QString & fileName, QString * errorMessage = 0);
	bool loadDocument( const QDomDocument & document, QString * errorMessage = 0);

	static RecordList fromFile(const QString & fileName, QString * errorMessage = 0);
	static RecordList fromDocument(const QDomDocument & document, QString * errorMessage = 0);
};
