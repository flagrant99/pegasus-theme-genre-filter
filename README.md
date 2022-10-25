# pegasus-theme-genre-filter
The genre filter theme is based on the Grid theme located here https://github.com/mmatyas/pegasus-theme-grid.
## Changes From Grid Theme
1. Added Genre Filter
2. Removed favorites filter
3. Removed Multiplayer filter
4 Changed some colors and moved around some in Game Details

# Screenshots

# Installation


# Populating genre categories
Inside of metadata.pegasus.txt fill in genre tags with your genres. genre tags should be single string with / or \ splitting up parent child genres. For example

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
