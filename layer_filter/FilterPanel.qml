// Pegasus Frontend
// Copyright (C) 2017-2020  Mátyás Mustoha
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
import "../folders.js" as Fldrs

FocusScope 
{
    ListModel
    {
        id: genreModel
    }


    id: root

    //property alias withFolder: selectedFolder
    property string withFolder : "ALL"



    //******************INIT_GENRE_MODEL************************
    function initGenreModel() 
    {
        //console.log("initGenreModel()")
        //console.log(topbar.currentIndex);
        var selectedCollection = api.collections.get(topbar.currentIndex);
        //console.log(selectedCollection.name)
        
        Fldrs.InitFolders(selectedCollection.games.toVarArray());

        genreModel.clear();
        genreModel.append({"genre": "ALL"});

        for (const [key, value]  of Fldrs.g_FoldersMap.entries())
        {
            //console.log(key  +' -> ' + value);
            genreModel.append({"genre": key});
        }

        //console.log("INIT GENRE MODEL COMPLETED")
    }


    //***********GENRE VIEW ITEM CHANGED**********************
    function gvOnItemChanged()
    {
        //console.log("gvOnItemChanged")
        filterDelay.restart();
    }

    // a small delay to avoid applying filter to much during scrolling
    Timer {
        id: filterDelay
        interval: 300
        onTriggered: 
        {
            var selectedGenre = genreModel.get(genreView.currentIndex).genre;
            //console.log("filterDelay")
            console.log(selectedGenre);
            withFolder=selectedGenre;
        }
    }    


    //***********************ON_RETURN_PRESSED*******************f*****
    function gvOnReturnPressed()
    {
        //var selectedGenre = genreModel.get(genreView.currentIndex).genre;
        //console.log("gvOnReturnPressed")
        //console.log(selectedGenre);
        //withFolder=selectedGenre;
        closeRequested();
    }

    ListView 
    {
        id: genreView
        z: 500
        model: genreModel
        focus: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        keyNavigationWraps: true        
        delegate : genreDelegate
        onCurrentItemChanged : gvOnItemChanged()

        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 0
        preferredHighlightBegin: height * 0.5 - vpx(18)
        preferredHighlightEnd: height * 0.5 + vpx(18)
    }//end of ListView 

    Component
    {
        id: genreDelegate

        Item
        {
            width:vpx(500);
            height:genreView.currentIndex == index ? vpx(filter.gf_fontsizeSel) : vpx(filter.gf_fontsize);
            Keys.onReturnPressed: gvOnReturnPressed();
            Keys.onRightPressed:  closeRequested();
            Keys.onLeftPressed:  closeRequested();

            //Rectangle 
            //{
              //  id: backgroundRect
//                width: parent.width
  //              height: parent.height
    //            color: index % 2 ? "green" : "blue"
      //      }            

            Text
            {
                id : txtRow
                width: parent.width
                height: parent.height
                text: genre
                font.family: globalFonts.condensed
                font.pixelSize: parent.height;
                font.bold: genreView.currentIndex == index ? true : false
                color: genreView.currentIndex == index ? "orange" : "white"
            }//end ot Text

            MouseArea
            {
                anchors.fill: parent
                onClicked: 
                {
                    console.log("Mouse Clicked in ListView");
                    genreView.currentIndex = index;
                }
            }//end of MouseArea            
        }//end of Item
    }//end of Component

}//end of FocusScope
