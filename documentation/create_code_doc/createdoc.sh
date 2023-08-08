#!/bin/bash
set +x

# Check if folder name is provided as command line argument
if [ $# -eq 0 ]; then
    echo "Please provide folder name as command line argument"
    exit 1
fi

# Get folder name from command line argument
folder=$1

# Check if folder exists
if [ ! -d "$folder" ]; then
    echo "Folder $folder does not exist"
    exit 1
fi

# Create document folder by prepending "doc" to folder name
doc_folder="doc_$folder"

# Create document folder if it does not exist
if [ ! -d "$doc_folder" ]; then
    mkdir "$doc_folder"
fi

# Copy directory structure to document folder
find "$folder" -type d -exec sh -c 'mkdir "$0"' {} "$doc_folder"/{} \;

# Create documentation for each file in folder and subfolders
find "$folder" -type f -name "*.sh" -o -name "*.py" -o -name "*.php" -o -name "*.js" | while read file; do
    # Get relative path of file from folder
    rel_path="${file#$folder/}"

    # Get directory path of file in document folder
    doc_dir="$doc_folder/$(dirname "$rel_path")"

    # Create directory if it does not exist
    if [ ! -d "$doc_dir" ]; then
        mkdir "$doc_dir"
    fi

    # Create documentation using bito and save it in document folder
    file2write="$doc_dir/$(basename "${file%.*}").md"
    echo $file2write
    # The below command does not work and gives following error
    # Only "-p" flag is applicable for this command. Remove any additional flags and then try again.
#    bito -p docprmt.txt -f "$file" >> "$file2write"
     cat $file | bito -p docprmt.txt > $file2write
done

echo "Documentation created in $doc_folder"
