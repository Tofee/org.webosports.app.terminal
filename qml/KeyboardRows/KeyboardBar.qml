/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQml.Models 2.1

import LuneOS.Components 1.0
import LunaNext.Common 0.1

Item {
    id: rootItem

    property int selectedLayoutIndex: 0
    property color backgroundColor: "black"
    property color foregroundColor: "white"

    signal simulateCommand(string command);
    signal simulateSequence(var sequence, string text);

    JsonListModel {
        id: layoutsList
        filePath: Qt.resolvedUrl("Layouts/Layouts.json")

        onCountChanged: {
            if(count>0 && !keybordLayoutModel.filePath) {
                keybordLayoutModel.filePath = Qt.resolvedUrl("Layouts/"+layoutsList.get(0).file);
            }
        }
    }

    ExpandableButton {
        id: keyboardSelector
        height: parent.height
        width: Units.gu(4)

        z: parent.z + 0.01

        backgroundColor: rootItem.backgroundColor
        textColor: rootItem.foregroundColor

        actionsModel: layoutsList
        actionsDelegate: Action {
            property string filePath: model.file
            text: model.text
            onTriggered: {
                console.log("Loading layout Layouts/" + filePath + "...");
                keybordLayoutModel.filePath = Qt.resolvedUrl("Layouts/"+filePath);
            }
        }

        enabled: layoutsList.count != 0

        Image {
            anchors {
                fill: parent
                leftMargin: Units.gu(0.5)
                rightMargin: Units.gu(0.5)
                topMargin: Units.gu(1)
                bottomMargin: Units.gu(1)
            }
            source: Qt.resolvedUrl("../images/drawer.png")
        }
    }

    KeyboardRow {
        id: keyboardContainer
        anchors.left: keyboardSelector.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        layoutModel: JsonListModel {
            id: keybordLayoutModel
        }

        color: rootItem.backgroundColor
        textColor: rootItem.foregroundColor

        onSimulateCommand: rootItem.simulateCommand(command);
        onSimulateSequence: rootItem.simulateSequence(sequence, text);
    }
}
