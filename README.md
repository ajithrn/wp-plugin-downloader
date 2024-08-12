# WordPress Plugin Downloader

This bash script automates the process of downloading and extracting WordPress plugins from the official WordPress.org repository directly into your wp-content/plugins directory.

## Prerequisites

- Bash shell
- `wget` for downloading files
- `unzip` for extracting zip files
- `grep`, `cut`, and `sed` for text processing (typically pre-installed on most Unix-like systems)

## Installation

1. Download the `wp-plugin-downloader.sh` file from the [GitHub repository](https://github.com/ajithrn/wp-plugin-downloader) and place it in your `wp-content` folder.

   You can use wget to download the script directly:
   ```
   wget https://raw.githubusercontent.com/ajithrn/wp-plugin-downloader/main/wp-plugin-downloader.sh -O wp-plugin-downloader.sh
   ```

2. Create a `plugins.list` file in the same `wp-content` folder with one plugin slug per line.

## Usage

1. Navigate to your `wp-content` folder:
   ```
   cd /path/to/your/wordpress/wp-content/
   ```

2. Make the script executable:
   ```
   chmod +x wp-plugin-downloader.sh
   ```

3. Run the script:
   ```
   ./wp-plugin-downloader.sh
   ```

## Configuration

- `plugins.list`: Add one plugin slug per line in this file.
- The script will create a `plugins_not_fetched.list` file for any plugins that couldn't be downloaded.

## Output

- Successfully downloaded plugins will be extracted to the `wp-content/plugins/` directory.
- Plugins that couldn't be downloaded (premium or unavailable) will be listed in `plugins_not_fetched.list`.
- The script will display a list of plugins that were not downloaded.

## Cleanup

After running, the script will ask if you want to delete the script and plugins list. The default is to keep these files.

## Contributing

Feel free to fork the [repository](https://github.com/ajithrn/wp-plugin-downloader) and submit pull requests for any improvements or bug fixes.

## License

This script is released under the MIT License. See the LICENSE file in the [repository](https://github.com/ajithrn/wp-plugin-downloader) for details.
