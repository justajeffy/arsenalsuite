
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
 * $Id$
 */

#include <qabstractitemmodel.h>
#include <qcolordialog.h>
#include <qpainter.h>
#include <qevent.h>

#include "blurqt.h"
#include "recorddelegate.h"
#include "recordcombo.h"
#include "recordlist.h"
#include "recordtreeview.h"

ExtDelegate::ExtDelegate( QObject * parent )
: QItemDelegate(parent)
{
    setClipping(true);
}

QWidget * ExtDelegate::createEditor ( QWidget * parent, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	if( !index.isValid() ) return 0;
	return QItemDelegate::createEditor(parent,option,index);
}

bool ExtDelegate::editorEvent ( QEvent * event, QAbstractItemModel * model, const QStyleOptionViewItem & option, const QModelIndex & index )
{
	if( event->type() == QEvent::MouseButtonRelease && ((QMouseEvent*)event)->button() == Qt::LeftButton ) {
		QVariant v = model->data(index, Qt::EditRole);
		uint t = v.userType();
		if( t == QVariant::Color ) {
			QColor ret = QColorDialog::getColor(qvariant_cast<QColor>(v));
			if( ret.isValid() )
				model->setData(index,qVariantFromValue(ret),Qt::EditRole);
			return true;
		}
	}
	return QItemDelegate::editorEvent(event,model,option,index);
}

void ExtDelegate::setModelData ( QWidget * editor, QAbstractItemModel * model, const QModelIndex & index ) const
{
	QItemDelegate::setModelData(editor,model,index);
}

void ExtDelegate::setEditorData ( QWidget * editor, const QModelIndex & index ) const
{
	QItemDelegate::setEditorData(editor,index);
}

void ExtDelegate::paint ( QPainter * painter, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	painter->save();

    const QAbstractItemModel * model = index.model();
    QVariant val = model->data(index, Qt::DisplayRole);
    SuperModel * sm = (SuperModel *)model;

    if( !sm->mColumnFilterMap.value( index.column() ).isEmpty() ) {
        QItemDelegate::drawBackground( painter, option, index );

        QString filterText = sm->mColumnFilterMap.value(index.column());
        //LOG_1(QString("column %1 has a filter %2").arg(QString::number(index.column())).arg(filterText));
        QStringList nonMatchingBits = val.toString().split(filterText, QString::KeepEmptyParts, Qt::CaseInsensitive);
        QFontMetrics fm = painter->fontMetrics();
        painter->setClipRect(option.rect);

        int x = option.rect.x();
        int y = option.rect.y();
        //LOG_1(QString("column original max width is %1").arg(QString::number(maxWidth)));

        QTextOption TO(Qt::AlignLeft);
        for( int i = 0; i< nonMatchingBits.size(); i++ ) {
            QString bit = nonMatchingBits[i];

            // If the model provides its own foreground color/brush for this item
            const QVariant value = index.data(Qt::ForegroundRole);
            if (value.isValid())
                painter->setPen( (qvariant_cast<QBrush>(value)).color() );
            else
                painter->setPen( option.palette.text().color() );

            if( option.state & QStyle::State_Selected )
                painter->setPen( option.palette.highlightedText().color() );

            QRect bitRect = fm.boundingRect( bit );
            painter->drawText( x, y, bitRect.width()+1, bitRect.height(), TO.flags(), bit);
            x = x + bitRect.width();

            if( i == nonMatchingBits.size()-1 ) continue;

            QRect filterRect = fm.boundingRect( filterText );
            painter->setPen( QColor(Qt::yellow) );
            painter->drawText( x, y, filterRect.width()+1, filterRect.height(), TO.flags(), filterText);
            x = x + filterRect.width();
        }
    } else {
        QItemDelegate::paint(painter,option,index);
    }

	if( val.isValid() && val.type() == QVariant::Color && qvariant_cast<QColor>(val).isValid()  ) {
		painter->setPen( Qt::white );
		painter->setBrush( qvariant_cast<QColor>(val) );
		painter->drawRect( option.rect );
	}
	if( option.state & ExtTreeView::State_ShowGrid ) {
		bool sel = option.state & QStyle::State_Selected;
		painter->setPen( option.palette.color( QPalette::Dark ) );
		painter->drawLine( option.rect.right(), option.rect.y(), option.rect.right(), option.rect.bottom() );
		if( sel ) {
			painter->setPen( option.palette.color( QPalette::Light ) );
			painter->drawLine( index.column() == 0 ? 0 : option.rect.x(), option.rect.y()-1, option.rect.right(), option.rect.y()-1 );
		}
		painter->drawLine( index.column() == 0 ? 0 : option.rect.x(), option.rect.bottom(), option.rect.right(), option.rect.bottom() );
	}

	painter->restore();
}

RecordDelegate::RecordDelegate ( QObject * parent )
: ExtDelegate(parent)
{}

QWidget * RecordDelegate::createEditor ( QWidget * parent, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	if( !index.isValid() ) return 0;
	QVariant v = index.model()->data(index, Qt::EditRole);
	uint t = v.userType();
	LOG_5( "RecordDelegate::createEditor: " + QString( QMetaType::typeName(t) ));
	if( t == static_cast<uint>(qMetaTypeId<RecordList>()) ) {
		RecordCombo * ret = new RecordCombo(parent);
		ret->installEventFilter(const_cast<RecordDelegate*>(this));
		QVariant field = index.model()->data(index, RecordDelegate::FieldNameRole);
		ret->setColumn(field.toString());
		return ret;
	}
	return ExtDelegate::createEditor(parent,option,index);
}

bool RecordDelegate::editorEvent ( QEvent * event, QAbstractItemModel * model, const QStyleOptionViewItem & option, const QModelIndex & index )
{
	return ExtDelegate::editorEvent(event,model,option,index);
}

void RecordDelegate::setModelData ( QWidget * editor, QAbstractItemModel * model, const QModelIndex & index ) const
{
	if( editor->inherits( "RecordCombo" ) ) {
		LOG_5( "RecordDelegate::setModelData" );
		RecordCombo * rc = (RecordCombo*)editor;
		Record cur = rc->current();
		model->setData(index,qVariantFromValue(cur),Qt::EditRole);
		return;
	}
	ExtDelegate::setModelData(editor,model,index);
}

void RecordDelegate::setEditorData ( QWidget * editor, const QModelIndex & index ) const
{
	if( editor->inherits( "RecordCombo" ) ) {
		LOG_5( "RecordDelegate::setEditorData: Setting items and current for RecordCombo" );
		RecordCombo * rc = (RecordCombo*)editor;
		QVariant list = index.model()->data(index, Qt::EditRole);
		QVariant cur = index.model()->data(index, RecordDelegate::CurrentRecordRole);
		rc->setItems(qVariantValue<RecordList>(list));
		rc->setCurrent(qVariantValue<Record>(cur));
		return;
	}
	ExtDelegate::setEditorData(editor,index);
}

void RecordDelegate::paint ( QPainter * painter, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	ExtDelegate::paint(painter,option,index);
}

