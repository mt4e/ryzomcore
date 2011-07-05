// Translation Manager Plugin - OVQT Plugin <http://dev.ryzom.com/projects/nel/>
// Copyright (C) 2010  Winch Gate Property Limited
// Copyright (C) 2011  Emanuel Costea <cemycc@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#ifndef TRANSLATION_MANAGER_EDITOR_H
#define TRANSLATION_MANAGER_EDITOR_H

#include <QtCore/QObject>
#include <QtGui/QWidget>
#include <QtGui/QMdiArea>
#include <QtGui/QMdiSubWindow>

namespace Plugin {
    
class CEditor : public QMdiSubWindow {
Q_OBJECT
protected:
    QString current_file;
    int editor_type;
public:
    CEditor(QMdiArea* parent) : QMdiSubWindow(parent) {}
    CEditor() : QMdiSubWindow() {}
    virtual void open(QString filename) =0;
    virtual void save() =0;
    virtual void saveAs(QString filename) =0;
    virtual void activateWindow() =0;
public:
    QString subWindowFilePath()
    {
        return current_file;
    }
};

}


#endif	/* TRANSLATION_MANAGER_EDITOR_H */

