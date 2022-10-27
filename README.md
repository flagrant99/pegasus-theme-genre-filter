# pegasus-theme-genre-filter

A theme for the [Pegasus](http://pegasus-frontend.org) frontend.

The genre filter theme is based on the Grid theme located here https://github.com/mmatyas/pegasus-theme-grid.
## Changes From Grid Theme
1. Added Genre Filter
2. Removed favorites filter
3. Removed Multiplayer filter
4. Changed some colors and moved around some text in Game Details

# Screenshots

# Installation

If you wish to install a copy of it manually, just [download](https://github.com/flagrant99/pegasus-theme-genre-filter/archive/master.zip) and extract it to your [theme directory]
(http://pegasus-frontend.org/docs/user-guide/installing-themes). 
You can then select the theme in the settings menu of Pegasus.

# Populating genre categories
To make the genre filter work metadata.pegasus.txt has to have genre meta data populated. games without a genre tag in metadata.pegasus.txt will simply appear under the ALL genre. genre tags should be single string with / or \ splitting up parent child genres. For example

```
genre: Sports/Hockey
```

1. Sports/Baseball
2. Sports/Hockey
3. Sports/Football 

The Genre Filter selector will be populated with 
- Sports
- Sports/Baseball
- Sports/Hockey
- Sports/Football 

In this way we can sub categorize games into common genres like Platform, Fighter, Arcade, Sports, etc. 
Genres can include #'s so something like 0Best will appear at top of Genre List to get into your favorites quick.
Sorting is not case sensitive. 

# Settings
I never implemented a UI for config, however under theme_settings\pegasus-theme-genre-filter.json I did expose the fontsize for the genrefilter unselected text.

```
{"genrefilter.fontsize":32}
```
I default to large 32 Pixel font size for phone use. However on a Desktop it could go way smaller, so I exposed this prop to make it easy to change on different devices. The selected genre text is double this font size to make selection obvious.

# Known Issues
1. Swipe is not working on Genre Filter. It took forever to get mouse to work and I don't have a touch screen on dev environment so maybe some other time. 


## License

[![CC-BY-NC-SA](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

