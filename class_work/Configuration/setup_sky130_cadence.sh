mkdir PRACTICE1
cd PRACTICE1

mkdir rtl
mkdir tb
mkdir constraints
mkdir synth
echo "Created directory in: `pwd`"
cp -r /home/eee/rizvi/sky130_cadence/lib synth/lib
echo "Copying liberty (.lib) files from /home/rizvi/"
cd ..
echo "Going back to parent directory now: `pwd`"

