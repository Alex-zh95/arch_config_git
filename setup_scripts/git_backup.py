import os
import shutil
import re
import argparse


def copy_all(source_dir: str, dest_dir: str) -> None:
    # Check if the source directory exists
    if not os.path.exists(source_dir):
        raise EnvironmentError(f"Source directory '{source_dir}' does not exist.")

    # Check if the destination directory exists, and create it if it doesn't
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)

    # Iterate through subfolders in the source directory
    for subdir, _, _ in os.walk(source_dir):
        # Calculate the corresponding subdirectory in the destination folder
        dest_subdir = os.path.join(dest_dir, os.path.relpath(subdir, source_dir))

        print(f"Copying changes from '{subdir}' to '{dest_subdir}'")

        if os.path.exists(dest_subdir):
            # dest_mod = dest_subdir.replace('.', '')
            dest_mod = re.sub(u'\.$', '', dest_subdir)
            shutil.rmtree(dest_mod)  # Remove the destination subfolder

        shutil.copytree(subdir, dest_subdir)  # Copy the source subfolder


def get_backup_list(path: str) -> list[str]:
    try:
        with open(path, 'r') as file:
            lines = file.readlines()
    except FileNotFoundError:
        print(f'File {path} not found')
        lines = []

    return lines


if __name__ == "__main__":
    # Set up the argument parser for direction of copy
    parser = argparse.ArgumentParser()
    parser.add_argument('-r', '--restore', type=bool, default=False, required=False)
    args = parser.parse_args()

    # Main folder path prefixes for source and destination
    source_folder = os.path.expanduser("~/.config")

    # Ensure we are always working in root of this
    if os.getcwd().endswith('arch_config_git'):
        destination_folder = "config"
    else:
        print('Please run this script from the root folder of this git repo.')
        exit(1)

    # If we are in restore mode, swap destination and source around
    if args.restore:
        source_folder, destination_folder = destination_folder, source_folder

    # Get the list of all folders we want to back up
    directories = get_backup_list('setup_scripts/git_backup_list.txt')

    for directory in directories:
        # Each directory string contains a "\n" break, which we need to remove
        mod_dir = directory.replace('\n', '')

        src = f'{source_folder}/{mod_dir}'
        dst = f'{destination_folder}/{mod_dir}'
        copy_all(src, dst)
