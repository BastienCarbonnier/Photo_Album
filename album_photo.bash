#!/bin/bash

echo "Quelles images souhaitez vous obtenir ?"
read img

rep=photo_album

# Create photo_album folder if it doesn't exist

if [ ! -e "$rep" ];then
    mkdir $rep
    cd $rep
else
    cd $rep
fi

#Initialize name of the picture
a=0

# Check if the folder of the picture exist
if [ ! -e "$img" ];then
    mkdir $img
    cd $img

    # Download page from pexels.com to get links of pictures
    curl https://www.pexels.com/search/$img/ -o $img.html

    # Take picture's links from website, the path where pictures are stored stay the same
    # We have to cut the link until the first <">
    # All picture's link are stored on links_jpg for jpg file and links_jpeg for jpeg file

    grep -oh 'https://images.pexels.com/photos/.*jpg' $img.html | cut -d'"' -f1 >links_jpg.txt
    grep -oh 'https://images.pexels.com/photos/.*jpeg' $img.html | cut -d'"' -f1 >links_jpeg.txt

    # Download all pictures from links get below
    wget -i links_jpg.txt
    wget -i links_jpeg.txt

    # Rename the picture to avoid the risk of having 2 pictures with the same name
    # Resize all pictures to the same size
    for i in `ls *.jpg*`
    do
        mv $i $a.jpg
        convert $a.jpg -resize 800x533 $a.jpg
        let a=a+1
    done
    b=$a
    # Convert jpeg file to jpg file
    for i in `ls *.jpeg*`
    do
        mv $i $b.jpeg
        convert $b.jpeg -resize 800x533 $b.jpg
        rm $b.jpeg
        let b=b+1
    done


    # Create a pdf with all pictures
    convert *.jpg $img.pdf

    echo "Vos images ont été télechargé dans le répertoire suivant : $img"
    echo "Voici votre album d'images !"
    open $img.pdf
else
    echo "Voici votre album d'images !"
    cd $img
    open $img.pdf
fi



