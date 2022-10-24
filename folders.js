var g_FoldersMap;//Key = Unique Relative Subfolder, Value =Full Path to file


//*****************GET FILE DIRECTORY***************
function getFileDirectory(filePath) 
{
    if (filePath.indexOf("/") == -1) { // windows
      return filePath.substring(0, filePath.lastIndexOf('\\'));
    } 
    else 
    { // unix
      return filePath.substring(0, filePath.lastIndexOf('/'));
    }
}

//Initially I tried to use Folders, but ended up using genre instead with subfolder in that.
//*******************INIT FOLDERS****************************
function InitFolders(games_arr)
{
    //console.log("INITFOLDERS");  
    
    var FoldersMap = new Map();            

    for (let i = 0; i < games_arr.length; i++)
    {
        var game=games_arr[i];        

        var genreStr = game.genre;
        if (genreStr.length < 1)
            continue;

        genreStr=genreStr.trim();
        if (genreStr.length < 1)
            continue;


        if (FoldersMap.has(genreStr)==false)
        {
            FoldersMap.set(genreStr, game.files.get(0).path);
        }

        //If we have something like sports/hockey I want sports to also be a filter on it's own.
        var parentDir = "";
        parentDir = getFileDirectory(genreStr);
        if (parentDir.length>0)
        {
            if (FoldersMap.has(parentDir)==false)
            {
                FoldersMap.set(parentDir, game.files.get(0).path);
            }
        }
    }

    //Sort It. case INsensitive. so r comes before Z
    g_FoldersMap = new Map([...FoldersMap.entries()].sort(function (a, b) 
    {
        var aStr = String(a).toLowerCase();
        var bStr = String(b).toLowerCase()

        if (aStr < bStr) return -1;
        if (aStr > bStr) return 1;
        return 0;
    }))

    //Log g_FoldersMap TODO: comment out when done
    //console.log("g_FoldersMap >>>>>>>>>>>>>");
    //for (const [key, value]  of g_FoldersMap.entries()) 
    //{
        //console.log(key  +' -> ' + value);  
    //}       
 
return;
}