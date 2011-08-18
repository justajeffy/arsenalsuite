

	QString sortString() const;

	QString displayNumber() const;

	static void checkForFrameFiles( ShotList, const Resolution &, bool fillMissing=false );
	static void deleteExtraFrameFiles( ShotList, const Resolution & );
	
	void createCompFileTrackers();
	void createRenderFileTrackers();
	void createFrames();

	MappedRecord sequence();
