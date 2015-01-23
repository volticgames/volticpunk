import os

toMakeListFrom = []
toWrite = "package entities.loadable\n{\npublic class E\n{\npublic function E()\n{\n"
lists = ""

file = open("E.as","w")


for dirname, dirnames, filenames in os.walk("./"):

    print(filenames)

    for filename in filenames:
        if filename != "E.as" and filename != "generate.py":
            lists += filename.split(".")[0] + ";\n"

    
file.write(toWrite + lists + "}\n}\n}")
file.close()




