
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
    setMaximumHeight(24);

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
    int cnt = 0;
    for( cnt=0; columns[cnt].name; ++cnt );
    for( int i=0; i<cnt; i++ ) {
        if( columns[i].filterEnabled ) {
            QLineEdit * edit = new QLineEdit();
            edit->setFrame(false);
            edit->setToolTip(QString("Filter by: %1").arg(columns[i].name));

            QString filterText = ini.readString( columns[i].iniName + QString("ColumnFilter"), "" );
            if( !filterText.isEmpty() )
                edit->setText( filterText );

            mFilterMap[i] = edit;
            connect(mFilterMap[i], SIGNAL(textChanged(const QString)), this, SLOT(textFilterChanged()));
            //LOG_1(columns[i].name);
        } else {
            mFilterMap[i] = new QWidget();
        }
    }
    int i = 0;
    for (i = 0; i < mTree->header()->count(); i++) {
        //qDebug() << "Filter: " << filters[i] << ", Pos: " << header->visualIndex(i) << endl;

        if( !mTree->header()->isSectionHidden(i) ) {
            mFilterMap[i]->setFixedWidth( mTree->columnWidth( i ) );
            layout->addWidget(mFilterMap[i], 0, mTree->header()->visualIndex(i));
            mFilterIndexMap[mFilterMap[i]] = i;
        }
        if(i>0)
            QWidget::setTabOrder(mFilterMap[mTree->header()->visualIndex(i-1)], mFilterMap[mTree->header()->visualIndex(i)]);
    }
    if(i>0)
        QWidget::setTabOrder(mFilterMap[mTree->header()->visualIndex(i-1)], mFilterMap[mTree->header()->visualIndex(i)]);

    layout->addItem(new QSpacerItem(1, 1, QSizePolicy::Expanding, QSizePolicy::Expanding), 1, i);

    connect(mTree->header(), SIGNAL(sectionResized(int, int, int)), this, SLOT(resizeColumn(int, int, int)));
    connect(mTree->header(), SIGNAL(sectionMoved(int, int, int)), this, SLOT(moveColumn(int, int, int)));
    connect(mTree->horizontalScrollBar(), SIGNAL(valueChanged(int)), horizontalScrollBar(), SLOT(setValue(int)));

    QTimer::singleShot(900, this, SLOT(filterRows()));
}

void RecordFilterWidget::resizeColumn(int column, int oldValue, int newValue)
{
    mFilterMap[column]->setFixedWidth(newValue);
}

void RecordFilterWidget::moveColumn(int, int, int)
{
    for (int i = 0; i < mTree->header()->count(); i++) {
        //qDebug() << "Filter: " << filters[i] << ", Pos: " << header->visualIndex(i) << endl;
        layout->removeWidget(mFilterMap[i]);
        if( !mTree->header()->isSectionHidden(i) ) {
            layout->addWidget(mFilterMap[i], 0, mTree->header()->visualIndex(i));

            mFilterIndexMap[mFilterMap[i]] = i;
        }
    }
}

void RecordFilterWidget::textFilterChanged()
{
    QTimer::singleShot(300, this, SLOT(filterRows()));
}

void RecordFilterWidget::filterRows()
{
    int numRows = mTree->model()->rowCount();
    for ( int row = 0; row < numRows; row++ ) {
        mTree->setRowHidden(row, mTree->rootIndex(), false);

        int mapSize = mFilterMap.size();
        for ( int col = 0; col < mapSize; col++ ) {
            QLineEdit *le = qobject_cast<QLineEdit*> (mFilterMap.value(col));
            if ( le && !le->text().isEmpty() ) {
                QString filter = mTree->model()->data(mTree->model()->index(row, mFilterIndexMap.value(mFilterMap.value(col)))).toString();
                if( !filter.contains( le->text(), Qt::CaseInsensitive ) )
                    mTree->setRowHidden(row, mTree->rootIndex(), true);
            }
        }
    }
}

