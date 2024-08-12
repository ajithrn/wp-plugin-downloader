#!/bin/bash

# Set paths (assuming script is in wp-content folder)
wp_content_dir="$(pwd)"
plugins_dir="${wp_content_dir}/plugins"
plugins_list_file="${wp_content_dir}/plugins.list"
premium_plugins_list_file="${wp_content_dir}/plugins_not_fetched.list"

# Clear the premium plugins list at the start of each run
> "$premium_plugins_list_file"

# Create the plugins directory if it doesn't exist
mkdir -p "$plugins_dir"

# Array to store not downloaded plugins
not_downloaded=()

# Function to download and extract a WordPress plugin
download_and_extract_plugin() {
  local plugin_slug="$1"
  local api_url="https://api.wordpress.org/plugins/info/1.2/?action=plugin_information&request[slug]=${plugin_slug}"

  echo "Fetching information for ${plugin_slug}..."
  
  # Get plugin information from the WordPress API
  plugin_info=$(wget -qO- "$api_url")
  
  # Extract download link from the API response and unescape it
  download_url=$(echo "$plugin_info" | grep -o '"download_link":"[^"]*"' | cut -d'"' -f4 | sed 's/\\\//\//g')
  
  if [ -n "$download_url" ]; then
    echo "Download URL: $download_url"
    
    local zip_file_path="${plugins_dir}/${plugin_slug}.zip"

    echo "Downloading ${plugin_slug}..."
    if wget -q -O "$zip_file_path" "$download_url"; then
      echo "Extracting ${plugin_slug}..."
      unzip -q -o "$zip_file_path" -d "$plugins_dir" && rm "$zip_file_path"
      echo "Successfully downloaded and extracted ${plugin_slug}"
    else
      echo "Failed to download ${plugin_slug}. Adding to ${premium_plugins_list_file}"
      echo "$plugin_slug" >> "$premium_plugins_list_file"
      rm -f "$zip_file_path"  # Remove the zip file if download failed
      not_downloaded+=("$plugin_slug")
    fi
  else
    echo "Failed to get download link for ${plugin_slug}. Adding to ${premium_plugins_list_file}"
    echo "$plugin_slug" >> "$premium_plugins_list_file"
    not_downloaded+=("$plugin_slug")
  fi
}

# Read the plugins list file and download/extract each plugin
while IFS= read -r plugin_slug || [[ -n "$plugin_slug" ]]; do
  if [[ -n "$plugin_slug" ]]; then
    download_and_extract_plugin "$plugin_slug"
  fi
done < "$plugins_list_file"

echo "Plugin download and extraction complete."

# List plugins that were not downloaded
if [ ${#not_downloaded[@]} -ne 0 ]; then
  echo "The following plugins were not downloaded:"
  printf '%s\n' "${not_downloaded[@]}"
else
  echo "All plugins were successfully downloaded."
fi

# Ask user if they want to delete the script and list file
read -p "Do you want to delete the script and plugins list? (y/N): " delete_choice
delete_choice=${delete_choice:-n}

if [[ $delete_choice =~ ^[Yy]$ ]]; then
  rm -f "$0" "$plugins_list_file"
  echo "Script and plugins list have been deleted."
else
  echo "Script and plugins list have been kept."
fi
