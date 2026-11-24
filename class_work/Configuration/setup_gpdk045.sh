set PROJECT = $1

mkdir "$PROJECT"
cd "$PROJECT"

mkdir rtl
mkdir tb
mkdir constraints
mkdir synth
echo "Created directory in: `pwd`"
cp -r /home/eee/rizvi/gpdk045/lib synth/lib
echo "Copying liberty (.lib) files from /home/rizvi/"
cd ..
echo "Going back to parent directory now: `pwd`"

