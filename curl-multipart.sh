#!/bin/bash
# Author: Diego Pereira (@diegodsp)
# Based on project written by <Param Aggarwal (@paramaggarwal)>
# Multipart parallel downloader in Shell using cURL
echo

# check parameters
if [[ $# -lt 1 || $1 == '--manual' ]]; then
    echo "-- Multipart cURL --"
    echo "Oh no, I need arguments to run!!!"
    echo "    The first and no named parameter is the URL. Seriously that is important? Hahahaha"
    echo "    -p or --parts is a number of parts, or default 10."
    echo "    -o or --output is the name of output file, or default is the name of your desired file."
    echo
    echo "EXAMPLE:"
    echo "    ./curl-multipart.sh http://blabla.com/file.zip -p=8 -o=downloaded.zip"
    echo
    exit 1
fi

# parse parameters
for i in "$@"
do
case $i in
    -p=*|--parts=*)
    parts="${i#*=}"
    shift
    ;;
    -o=*|--output=*)
    output="${i#*=}"
    shift
    ;;
    *)
    # assume as url
    url=$1
    ;;
esac
done

# make parameters useful
[[ ! -z $parts || $parts > 0 ]] || parts=10
[[ ! -z $output ]] || output="$(expr $url : '.*/\(.*\)')"

# create a session, which allows you to download several files in the same folder at the same time
session="$(uuidgen)"

# get the size of remote file
size="$(curl --head --silent $url | grep -E "[Cc]ontent-[Ll]ength" | sed 's/[^0-9]*//g')"

# feedback
echo "Your download session: $session"
echo "URL: $url"
echo "Output: $output"
echo "Size: $size"
echo "Downloading in $parts parts..."
echo

# run forest!
for (( c=1; c<=$parts; c++ ))
do
    from="$(echo $[$size*($c-1)/$parts])"
    if [[ $c != $parts ]]; then
        to="$(echo $[($size*$c/$parts)-1])"
    else
        to="$(echo $[$size*$c/$parts])"
    fi 

    out="$(printf $session'-temp.part'$c)"
    
    echo "Downloading part: $c range: $from-$to"
    curl --silent --range $from-$to -o $out $url &
done

echo
echo "Gusfraba... Gusfraba..."
echo "Patience is a virtude"
echo "Wait"
wait

# concat all parts into a single file 
for (( c=1; c<=$parts; c++ ))
do
    cat $(printf $session'-temp.part'$c) >> $output
    rm $(printf $session'-temp.part'$c)
done

# goodbye
echo
echo "Your file $output was downloaded!"
echo "My job has done!"
echo "This is the end of line for me... bye!"
echo
