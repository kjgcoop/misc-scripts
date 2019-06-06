#!/bin/bash

# Take a directory of images and create thumbnails.
#
# The thumbnails are squares from the center of images as opposed to
# shrinking the image
#
# See http://www.imagemagick.org/Usage/resize/#resize

# Arguments
# $1 - path to the images
# $2 - new suffix
# $3 - new size

usage="$0 [path] [suffix] [size]"

if [ "$1" == "" ] || [ ! -d "$1" ]; then
    echo Must include a path to a directory as the first argument
    echo $usage
    exit
else
    path=$1
fi

if [ "$2" == "" ]; then
    echo You must specify a new suffix for the images in the second argument
    echo $usage
    exit
else
    suffix=$2
fi

if [ "$3" == "" ]; then
    # Too lazy to confirm it's an integer; image magick will know to fail.
    # But if/when I do want to, SO is here for me:
    # https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
    echo You must supply a size for the new images to be in the third argument
    echo $usage
    exit
else
    size=$3
    dim_str="$size"x"$size" # 200x200 or whatever
fi

for img in $path/*; do
    if [ -d $path/$img ]; then
        continue;
    fi

    # Creating the new image name involves stripping the extension. There's
    # got to be a more elegant way, but this is what the inimitable Stack
    # Overflow provided:
    # https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
    filename=$(basename -- "$img")
    extension="${filename##*.}"
    new_name=$path/"${filename%.*}$suffix"

    echo convert $img -resize $dim_str $new_name
    convert $img -resize $dim_str $new_name
done
