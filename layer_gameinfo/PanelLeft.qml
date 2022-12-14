// Pegasus Frontend
// Copyright (C) 2017-2018  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


import QtQuick 2.6
import QtGraphicalEffects 1.0
import "qrc:/qmlutils" as PegasusUtils


Item {
    property var game

    signal launchRequested

    onVisibleChanged: 
    {
        if (visible)
            scrollArea.restartScroll();
        else
            scrollArea.stopScroll();
    }

    Column
    {
        id : fileProps
        width: parent.width

            // File Name
            Text 
            {
                
                color: "#f5425d"
                text: (game && game.files.get(0).path.replace(/^.*[\\\/]/, '')) || ""


                font 
                {
                    pixelSize: vpx(16)
                    family: globalFonts.sans
                    underline : true
                }
            }//end of Text


            //FilePath
            Text 
            {
                width: parent.width
                color: "#f5425d"
                text: (game && game.files.get(0).path) || ""
                elide: Text.ElideRight


                font 
                {
                    pixelSize: vpx(16)
                    family: globalFonts.condensed
                }
                horizontalAlignment: Text.AlignLeft
            }//end of Text
            bottomPadding: vpx(8)
    }




    // description
    PegasusUtils.AutoScroll 
    {
        id: scrollArea
        width: parent.width
        anchors.top: fileProps.bottom
        anchors.bottom: playtimes.top

        Text 
        {
            color: "#eee"
            text: (game && game.description) || ""
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignJustify
            font 
            {
                pixelSize: vpx(16)
                family: globalFonts.sans
            }
        }
    }



    Column 
    {
        id: playtimes
        width: parent.width
        anchors.bottom: actionButtons.top

        topPadding: labelFontSize * 1.5
        bottomPadding: topPadding
        spacing: vpx(4)

        readonly property color labelColor: "#f5425d";
        readonly property int labelSpacing: labelFontSize / 2
        readonly property int labelFontSize: vpx(17)

        Row 
        {
            width: parent.width
            spacing: playtimes.labelSpacing

            Text {
                text: "last played:"
                width: parent.width * 0.5
                color: playtimes.labelColor
                font {
                    pixelSize: playtimes.labelFontSize
                    family: globalFonts.sans
                    capitalization: Font.AllUppercase
                }
                horizontalAlignment: Text.AlignRight
            }

            Text {
                text: {
                    if (!game)
                        return "-";
                    if (isNaN(game.lastPlayed))
                        return "never";

                    var now = new Date();

                    var diffHours = (now.getTime() - game.lastPlayed.getTime()) / 1000 / 60 / 60;
                    if (diffHours < 24 && now.getDate() === game.lastPlayed.getDate())
                        return "today";

                    var diffDays = Math.round(diffHours / 24);
                    if (diffDays <= 1)
                        return "yesterday";

                    return diffDays + " days ago"
                }
                color: "#eee"
                font {
                    pixelSize: playtimes.labelFontSize
                    family: globalFonts.sans
                }
            }
        }//end of Row 

        Row 
        {
            width: parent.width
            spacing: playtimes.labelSpacing

            Text {
                text: "play time:"
                width: parent.width * 0.5
                color: playtimes.labelColor;
                font {
                    pixelSize: playtimes.labelFontSize
                    family: globalFonts.sans
                    capitalization: Font.AllUppercase
                }
                horizontalAlignment: Text.AlignRight
            }

            Text 
            {
                text: {
                    if (!game)
                        return "-";

                    var minutes = Math.ceil(game.playTime / 60)
                    if (minutes <= 90)
                        return Math.round(minutes) + " minutes";

                    return parseFloat((minutes / 60).toFixed(1)) + " hours"
                }
                color: "#eee"
                font {
                    pixelSize: playtimes.labelFontSize
                    family: globalFonts.condensed
                }
            }


        }
    }

    Column 
    {
        id: actionButtons
        width: parent.width
        anchors.bottom: parent.bottom
        spacing: vpx(4)

        GamePanelButton 
        {
            id: toggleFavBtn
            text: "Genre Filter"

            KeyNavigation.up: launchBtn
            KeyNavigation.down: launchBtn
            Keys.onPressed: 
            {
                if (api.keys.isAccept(event) && !event.isAutoRepeat) 
                {
                    event.accepted = true;
                    filtersRequested();
                }
            }
            onClicked: 
            {
                focus = true;
                filtersRequested();
            }
        }
        GamePanelButton 
        {
            id: launchBtn
            text: "Launch"
            lineHeight: 2

            focus: true
            Keys.onPressed: 
            {
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    launchRequested();
                }
            }
            onClicked: 
            {
                focus = true;
                launchRequested();
            }
        }
    }
}
