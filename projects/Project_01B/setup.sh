#!/bin/csh -f

# Check command-line arguments
if ($#argv != 3) then
    echo "Usage: csh setup.sh projectname path technology"
    echo "Technology: gpdk045 or sky130"
    exit 1
endif

# Read user arguments
set PROJECT = "$argv[1]"
set BASE_BATH = "$argv[2]"
set TECHNOLOGY = "$argv[3]"

# Select technology library
switch ("$TECHNOLOGY")
    case "gpdk":
    case "gpdk045":
        set TECH_LIB = "/home/eee/rizvi/gpdk045/lib"
        breaksw

    case "sky":
    case "sky130":
    case "sky130_cadence":
        set TECH_LIB = "/home/eee/rizvi/sky130_cadence/lib"
        breaksw
    default:
    echo "Error: Unsupported technology: $TECHNOLOGY"
    echo "Use gpdk045 or sky130"
    exit 1
endsw

# Check weither technology library exists
if (! -d "$TECH_LIB") then
    echo "ERROR: Technology library not found:"
    echo "$TECH_LIB"
    exit 1
endif

# Create project path
set PROJECT_DIR = "$BASE_PATH/$PROJECT"

# Prevent accidental overwrite
if (-e "$PROJECT_DIR") then
    echo "ERROR: Project already exists: $PROJECT_DIR"
    exit 1
endif

# Create project directory
mkdir -p "$PROJECT_DIR"
if ($status !=0) then
    echo "ERROR: Could not create project directory."
    exit 1
endif

# Create requried subdirectorys
mkdir -p "$PROJECT_DIR/rtl"
mkdir -p "$PROJECT_DIR/tb"
mkdir -p "$PROJECT_DIR/constraints"
mkdir -p "$PROJECT_DIR/synth"

cp -r "$TECH_LIB" "$PROJECT_DIR/synth/lib"

if ($status != 0) then
    echo "ERROR: Technology library copy failed."
    exit 1
endif

echo "____________________________"
echo "Project setup completed successfully!"
echo "Project Name: $PROJECT"
echo "Technology: $TECHNOLOGY"
echo "Project Path: $PROJECT_DIR"
echo "___________________________"

echo "Directory structure"
find "PROJECT_DIR" -type d

