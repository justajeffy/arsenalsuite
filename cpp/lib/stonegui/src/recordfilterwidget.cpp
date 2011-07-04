
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of libstone.
 *
 * libstone is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * libstone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with libstone; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id:$
 */

#include <qlayout.h>
#include <qwidget.h>
#include <qgridlayout.h>
#include <qboxlayout.h>
#include <qscrollarea.h>
#include <qscrollbar.h>
#include <qlineedit.h>
#include <qtimer.h>
#include <qheaderview.h>

#include "iniconfig.h"
#include "recordfilterwidget.h"
#include "recordtreeview.h"

RecordFilterWidget::RecordFilterWidget(QWidget * parent)
: QScrollArea(parent)
{
    setMaximumHeight(20);

    widget = new QWidget(this);
    layout = new QGridLayout(widget);
    layout->setSpacing(0);
    layout->setContentsMargins(0, 0, 0, 0);

    setWidget(widget);
    setWidgetResizable(true);
    setFrameShape(QFrame::NoFrame);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
}

void RecordFilterWidget::setupFilters(QTreeView * tree, const ColumnStruct columns [], IniConfig & ini)
{
    mTree = tree;

	int i;
	for (i = 0; i < mTree->header()->count(); i++) {

		int visIndex = mTree->header()->visualIndex(i);

		if (columns[i].filterEnabled) {

			QLineEdit * edit = new QLineEdit(this);
			edit->setMaximumHeight(18);
			edit->setToolTip(QString("Filter by: %1").arg(columns[i].name));

			QString filterText = ini.readString( columns[i].iniName + QString("ColumnFilter"), "" );
			if( !filterText.isEmpty() ) {
				edit->setText( filterText );
				SuperModel * sm = (SuperModel *)(tree->model());
				sm->setColumnFilter( i, filterText );
			}

			mFilterMap[i] = edit;

			connect(mFilterMap[i], SIGNAL(textChanged(const QString)), this, SLOT(textFilterChanged()));
		} else {
			mFilterMap[i] = new QWidget();
		}

		mFilterMap[i]->setFixedWidth( mTree->columnWidth( i ) );
		layout->addWidget(mFilterMap[i], 0, visIndex);

		mFilterIndexMap[mFilterMap[i]] = i;
		mTabIndexMap[visIndex]         = mFilterMap[i];
	}

	layout->addItem(new QSpacerItem(1, 1, QSizePolicy::Expanding, QSizePolicy::Expanding), 1, i);

	setTabOrder();

    connect(mTree->header(), SIGNAL(sectionResized(int, int, int)), this, SLOT(resizeColumn(int, int, int)));
    connect(mTree->header(), SIGNAL(sectionMoved(int, int, int)), this, SLOT(moveColumn(int, int, int)));
    connect(mTree->horizontalScrollBar(), SIGNAL(valueChanged(int)), horizontalScrollBar(), SLOT(setValue(int)));
}

void RecordFilterWidget::resizeColumn(int column, int oldValue, int newValue)
{
    mFilterMap[column]->setFixedWidth(newValue);
}

void RecordFilterWidget::moveColumn(int, int, int)
{
    for (int i = 0; i < mTree->header()->count(); i++) {
		int visIndex = mTree->header()->visualIndex(i);

        layout->removeWidget(mFilterMap[i]);
        if( !mTree->header()->isSectionHidden(i) ) {
            layout->addWidget(mFilterMap[i], 0, visIndex);

            mFilterIndexMap[mFilterMap[i]] = i;
			mTabIndexMap[visIndex]         = mFilterMap[i];
        }
    }

	setTabOrder();
}

void RecordFilterWidget::textFilterChanged()
{
    QLineEdit *filter = qobject_cast<QLineEdit*> (sender());
    if( mFilterIndexMap.contains(filter) ) {
        int column = mFilterIndexMap.value(filter);
        SuperModel * sm = (SuperModel *)(mTree->model());
        sm->setColumnFilter( column, filter->text() );
    }
    QTimer::singleShot(300, this, SLOT(filterRows()));
}

void RecordFilterWidget::filterRows()
{
    SuperModel * sm = (SuperModel *)(mTree->model());

    int numRows = mTree->model()->rowCount();
    int mapSize = mFilterMap.size();
	QStringList strs;
    for ( int row = 0; row < numRows; row++ ) {
        mTree->setRowHidden(row, mTree->rootIndex(), false);
        for ( int col = 0; col < mapSize; col++ ) {
            QLineEdit *filter = qobject_cast<QLineEdit*> (mFilterMap[col]);

            if ( filter && filter->isVisible() && !filter->text().isEmpty() ) {
                QString cell       = mTree->model()->data(mTree->model()->index(row, mFilterIndexMap[mFilterMap[col]])).toString();
                QString filterText = filter->text();

				if ( ! cell.contains(QRegExp(filterText, Qt::CaseInsensitive)) )
					mTree->setRowHidden(row, mTree->rootIndex(), true);

                sm->setColumnFilter( col, filterText );
            } else {
			    // Set the filter to empty so that the highlighted text gets un-highlighted in recorddelegate
                sm->setColumnFilter( col, "" );
			}
        }
    }
}

void RecordFilterWidget::clearFilters()
{
	int mapSize = mFilterMap.size();
	for ( int col = 0; col < mapSize; col++ ) {
		QLineEdit *filter = qobject_cast<QLineEdit*> (mFilterMap[col]);

		if ( filter ) 
			filter->clear();
	}
}

void RecordFilterWidget::setTabOrder()
{
    QLineEdit *prev = NULL;
    QLineEdit *cur  = NULL;
    for (int i = 0; i < mTabIndexMap.size(); i++) {
        if (i > 0) {

            QLineEdit *filter1 = qobject_cast<QLineEdit*> (mTabIndexMap[i-1]);
            QLineEdit *filter2 = qobject_cast<QLineEdit*> (mTabIndexMap[i]);

            if (filter1)
                prev = filter1;
            if (filter2)
                cur = filter2;

            if (prev && cur && prev != cur)
                QWidget::setTabOrder(prev, cur);
        }
    }
}
