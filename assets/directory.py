import os

toMakeListFrom = []
toWrite = "package assets\n{\nimport net.flashpunk.graphics.Image;\nimport net.flashpunk.Sfx;\n\npublic class A\n{"
lists = ""


def xmlFile(path, filename):

    path = path.replace(file_path_replace, "")

    filename = formatFilename(filename)

    string = "\n\n// XML: " + filename + " embedding from " + path + "\n"
    string += "[Embed(source = '" + path + "', mimeType = 'application/octet-stream')] public static const " + filename + "XML:Class;"

    return string

def ogmoLevel(path, filename):

    path = path.replace(file_path_replace, "")

    filename = formatFilename(filename)

    string = "\n\n// LEVEL: " + filename + " embedding from " + path + "\n"
    string += "[Embed(source = '" + path + "', mimeType = 'application/octet-stream')] public static const " + filename + "Map:Class;"

    return string


def image(path, filename):

    path = path.replace(file_path_replace, "")

    if "tiles" in filename.lower():
        tiles.append('"' + formatFilename(getFileExt(filename)[0]) + '"' + " : " + formatFilename(getFileExt(filename)[0]) )


    filename = formatFilename(filename)

    string = "\n\n// IMAGE: " + filename + " embedding from " + path + "\n"
    string += "[Embed(source = '" + path + "')] public static const " + filename + ":Class;"
    string += "\n"
    string += "public static const " + filename + "Image:Image = new Image(" + filename + ");"

    return string

def mp3File(path, filename):

    path = path.replace(file_path_replace, "")

    filename = formatFilename(filename)

    string = "\n\n// SOUND: " + filename + " embedding from " + path + "\n"
    string += "[Embed(source = '" + path + "')] public static const " + filename + ":Class;"
    string += "\n"
    string += "public static const " + filename + "Sound:Sfx = new Sfx(" + filename + ");"

    return string

def formatFilename(s):

    s = s.replace("_"," ").replace("/"," ").replace("."," ")

    if (len(s) != 0 and s[0].isupper() and " " not in s):
        return s

    if (" " not in s):
        return s.title()

    if (len(s) == 0  or not s.istitle()):
        return s.title().replace(" ","")

    return s.replace(" ","")

def getFileExt(name):
    return os.path.splitext(name)

def indexOf(s):
    try:
        return file_extensions.index(ext)
    except:
        return None

file_extensions = ["oel", "png", "xml", "mp3"]
file_handlers = [ogmoLevel, image, xmlFile, mp3File]
file_suffixes = ["Map", "", "", ""]
levels = []
sounds = []
tiles = []

relation_to_asset_file = "./"
file_path_replace = ""



file = open(relation_to_asset_file + "A.as","w")


for dirname, dirnames, filenames in os.walk(relation_to_asset_file):

    print(dirname)

    if (formatFilename(dirname.replace(relation_to_asset_file, "")) != ""):


        test = "\n\n// VECTOR: \n"
        test += "public static const " + formatFilename(dirname.replace(relation_to_asset_file,"")) + "List:Vector.<Class> = new <Class>["

        for filename in filenames:
            ext = getFileExt(filename)[1][1:]

            if (filename[0] != "_" and (getFileExt(filename)[1][1:] in file_extensions)):




                print(formatFilename(getFileExt(filename)[0]) + file_suffixes[indexOf(ext)] + ",")
                test += formatFilename(getFileExt(filename)[0])
                test += file_suffixes[indexOf(ext)]

                if (file_suffixes[indexOf(ext)] == "Map"):
                    levels.append('"' + formatFilename(getFileExt(filename)[0]) + '"' + " : " + formatFilename(getFileExt(filename)[0]) + file_suffixes[indexOf(ext)] )

                if (indexOf(ext) == 3):
                    sounds.append('"' + formatFilename(getFileExt(filename)[0]) + '"' + " : " + formatFilename(getFileExt(filename)[0]) + "Sound" )

                test += ","

        #Remove trailing ,
        if (test[-1] == ","):
            test = test[:-1]

            test += "];"

            lists += "\n" + test

    # print path to all filenames.
    for filename in filenames:
        if filename[0] != "_":
            path = os.path.join(dirname, filename)[2:]

            ext = getFileExt(filename)[1][1:]
            name = getFileExt(filename)[0]

            if (ext in file_extensions):
                toWrite += "\n" + file_handlers[indexOf(ext)](path, name)

    #Create the lookup for all level files
    levelDict = "public static const LEVELS:Object = {";

    for level in levels:
        levelDict += level + ",\n"

    levelDict = levelDict[:-2]


    levelDict += "};"

    #Create the lookup for all sound files
    soundDict = "public static const SOUNDS:Object = {";

    for sound in sounds:
        soundDict += sound + ",\n"

    soundDict = soundDict[:-2]


    soundDict += "};"

    #Create the lookup for all sound files
    tileDict = "public static const TILES:Object = {";

    for tile in tiles:
        tileDict += tile + ",\n"

    tileDict = tileDict[:-2]


    tileDict += "};"



file.write(toWrite + lists + "\n" + levelDict + "\n" + soundDict + "\n" + tileDict + "}\n}")
file.close()



