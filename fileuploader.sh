#! /bin/bash


FILE_PATH=$1
BUCKET_NAME='test-givers-bash'

if [ -z "$FILE_PATH" ]; then
    echo "Please provide a file path as an argument."
    exit 1
fi

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "File not found: $FILE_PATH"
    exit 1
fi


## Upload the file  to specific cloud provider
upload_file() {
    read -p "Enter the file path to upload: " FILE_PATH
    if [ ! -f "$FILE_PATH" ]; then
        echo "File not found: $FILE_PATH"
        return 1
    fi

    read -p "Enter the file name to be saved in the bucket: " FILE_NAME
    gsutil cp "$FILE_PATH" "gs://$BUCKET_NAME/$FILE_NAME"
}


## List the files in the bucket
list_files() {
        gsutil ls gs://$BUCKET_NAME/
}

## Delete the file from the bucket
delete_file() {
    echo "Files in the bucket:"
    list_files
    read -p "Enter the file name to delete: " FILE_NAME
    gsutil rm "gs://$BUCKET_NAME/$FILE_NAME"

}

## Download the file from the bucket
download_file() {
    echo "Files in the bucket:"
    list_files
    read -p "Enter the file name to download: " FILE_NAME
    read -p "Enter the destination path: " DEST_PATH
    gsutil cp "gs://$BUCKET_NAME/$FILE_NAME" "$DEST_PATH"

}

## Validate the cloud provider connnection
validate_cloud_provider() {
        gcloud auth list --filter=status:ACTIVE 
}

# Función para mostrar el menú
show_menu() {
    echo "1. Upload a file"
    echo "2. Download a file"
    echo "3. List files"
    echo "4. Delete a file"
    echo "5. Exit"
}


# Loop para mostrar el menú hasta que se seleccione la opción 3
while true; do
    show_menu
    read -p "Select an option: " choice
    case $choice in
        1)
            upload_file
            ;;
        2)
            download_file 
            ;;
        3)
            list_files
            ;;
        4)
            delete_file
            ;;
        5)
            exit 0  
            ;;
        *)
            echo "Invalid choice"
    esac
done