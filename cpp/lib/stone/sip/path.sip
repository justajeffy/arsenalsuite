


QString makeFramePath( const QString & base, uint frameNumber, uint padWidth = 4 );

QStringList filesFromFramePath( const QString & basepath, QList<int> * frames, int * padWidth = 0 );

QString framePathBaseName( const QString & framePath, int * frameNumber = 0 );

QList<int> expandNumberList( const QString & list, bool * valid = 0 );

QString compactNumberList( const QList<int> & list );

QString readFullFile( const QString & path, bool * error = 0 );
bool writeFullFile( const QString & path, const QString & contents );

class Path
{
public:
	Path();
	Path( const QString & path );
	
	Path operator+( const Path & ) const;
	Path & operator+=( const Path & );
	
	Path operator+( const QString & ) const;
	Path & operator+=( const QString & );
	
	bool isRelative() const;
	bool isAbsolute() const;

	Path chopLevel( int level ) const;
	
	int level() const;

	QString operator[](int level);

	QString drive() const;

	QString stripDrive() const;

	QString path() const;
	
	QString fileName() const;
	
	QString dirName() const;
	
	QString dirPath() const;
	
	QString dbDirPath() const;
	
	QString dbPath() const;

	Path dir() const;
	
	Path parent() const;
	
	bool fileExists() const;
	
	bool dirExists() const;
	
	bool symLinkExists() const;
	
	bool exists() const;
	
	bool mkdir( int makeParents = 0 );
	
	bool move( const Path & dest ) const;
	
	bool copy( const Path & dest ) const;
	
	bool remove( bool dirRecursive = false, QString * error=0 );

	static bool copy( const QString &, const QString & );
	static bool move( const QString &, const QString & );
	static bool exists( const QString & );
	static bool mkdir( const QString & path, int makeParents=0 );
	static bool remove( const QString & path, bool dirRecursive = false, QString * error=0 );

	static QString winPath( const QString & );
	static QString unixPath( const QString & );
	static QString osPath( const QString & );

	static bool checkFileFree( const QString & path );

	static long long dirSize( const QString & path );

};

/*
QString driveMapping( char driveLetter );

bool mapDrive( char driveLetter, const QString & uncPath, QString * errMsg=0 );
//QValueList< QPair<char,QString> > driveMappings();
*/




