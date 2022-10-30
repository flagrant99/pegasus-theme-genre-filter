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


import QtQuick 2.0
import SortFilterProxyModel 0.2
import "layer_filter"
import "layer_gameinfo"
import "layer_grid"
import "layer_platform"

FocusScope {


    Keys.onPressed: 
    {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isPrevPage(event)) 
        {
            event.accepted = true;
            topbar.prev();
            return;
        }
        if (api.keys.isNextPage(event)) 
        {
            event.accepted = true;
            topbar.next();
            return;
        }
        if (api.keys.isDetails(event)) 
        {
            event.accepted = true;
            gamepreview.focus = true;
            return;
        }
        if (api.keys.isFilters(event)) 
        {
            event.accepted = true;
            filter.focus = true;
            return;
        }
    }

    PlatformBar 
    {
        id: topbar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 300

        model: api.collections
        onCurrentIndexChanged: onPlatformChanged();
    }

    //***********************ON_PLATORM_CHANGED***********************
    function onPlatformChanged() 
    {
        console.log("onPlatformChanged()");
        gamegrid.cells_need_recalc();
        initFolders();
    }

    //***********************INIT_FOLDERS********************************
    function initFolders()
    {
        //console.log("initFolders()");
        filter.init_genre_model();
    }

    BackgroundImage 
    {
        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        game: gamegrid.currentGame
    }

    GameGrid 
    {
        id: gamegrid

        focus: true

        gridWidth: (parent.width * 0.6) - vpx(32)
        gridMarginTop: vpx(32)
        gridMarginRight: vpx(6)

        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        baseCollection: topbar.currentCollection
        originalModel: topbar.currentCollection.games
        filteredModel: filteredGames
        onDetailsRequested: gamepreview.focus = true
        onLaunchRequested: launchGame()
    }

    GamePreview 
    {
        id: gamepreview

        panelWidth: parent.width * 0.7 + vpx(72)
        anchors {
            top: topbar.bottom; bottom: parent.bottom
            left: parent.left; right: parent.right
        }

        game: gamegrid.currentGame
        onOpenRequested: gamepreview.focus = true
        onCloseRequested: gamegrid.focus = true
        onFiltersRequested: filter.focus = true
        onLaunchRequested: launchGame()
    }

    FilterLayer 
    {
        id: filter
        //anchors.fill: parent
        onCloseRequested: gamegrid.focus = true
         anchors.top: topbar.bottom;
         anchors.bottom: parent.bottom;
         anchors.topMargin: vpx(40);
         anchors.bottomMargin: vpx(40);

        property int gf_fontsize : 24
        property int gf_fontsizeSel : 48         
    }//end of FilterLayer 

    SortFilterProxyModel 
    {
        id: filteredGames
        sourceModel: topbar.currentCollection.games
        filters: [
            RegExpFilter {
                roleName: "genre" //topbar.currentCollection.games[0].Field name to filter by
                pattern: filter.withFolder
                caseSensitivity: Qt.CaseInsensitive
                enabled: filter.withFolder == "ALL" ? false : true
            } 
        ]
    }//end of SortFilterProxyModel 

    Component.onCompleted: 
    {
        console.log("Component.onCompleted()");

        var genre_filter_font_size = api.memory.get('genrefilter.fontsize');
        if (!genre_filter_font_size)
        {
            console.log("Writing Font Size");
            genre_filter_font_size=32;
            api.memory.set('genrefilter.fontsize', genre_filter_font_size);
        }
        filter.gf_fontsize=genre_filter_font_size;
        filter.gf_fontsizeSel=genre_filter_font_size*2;

        const last_collection = api.memory.get('collection');
        if (!last_collection)
        {
            initFolders();
            return;
        }

        const last_coll_idx = api
            .collections
            .toVarArray()
            .findIndex(c => c.name === last_collection);
        if (last_coll_idx < 0)
        {
            initFolders();
            return;
        }

        topbar.currentIndex = last_coll_idx;
        initFolders();

        const last_game = api.memory.get('game');
        if (!last_game)
            return;

        const last_game_idx = api
            .collections
            .get(last_coll_idx)
            .games
            .toVarArray()
            .findIndex(g => g.title === last_game);
        if (last_game_idx < 0)
            return;

        gamegrid.currentIndex = last_game_idx;
        gamegrid.memoryLoaded = true;
    }

    function launchGame() 
    {
        api.memory.set('collection', topbar.currentCollection.name);
        api.memory.set('game', gamegrid.currentGame.title);
        gamegrid.currentGame.launch();
    }
}//end of FocusScope {
