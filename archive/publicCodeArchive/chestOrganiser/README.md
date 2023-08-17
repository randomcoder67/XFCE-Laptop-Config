## Chest Organiser 

Python program to help organise items in a Minecraft storage system. WIP. 

### Setup 

A list of all Minecraft items and a picture for each is needed. These can be obtained in the following way:

`unzip` the minecraft.jar file, copy the textures  
`curl "https://minecraft.fandom.com/wiki/Block" > blocks.html`  
`python3 parseHTML.py > toDownload.csv`  
`mkdir files`  
`python3 download.py toDownload.csv`  
`cp *unzippedJar*/assets/minecraft/textures/item images`  
`mv files/* images/`  
`python3 matchFilesnames.py stuff/items.txt`  

### Usage 

`python3 gtkPython.py`  
Select which category you want to add to at the top, then click on an item to add it. To remove, click on an item in a category page when that category is selected. 
