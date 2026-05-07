from datetime import datetime


class FileMover:
    def __init__(self, dbutils, logger):
        self.dbutils = dbutils
        self.logger = logger

    def move_files(self, source_path, backup_base_path, entity):
        """
        Move source files from raw volume to backup volume.

        Example:
        source_path:
          /Volumes/banking_catalog/raw/sample_data

        backup_base_path:
          /Volumes/banking_catalog/raw/backup
        """

        backup_date = datetime.now().strftime("%Y-%m-%d")
        backup_path = f"{backup_base_path}/{entity}/backup_date={backup_date}"

        self.logger.info(f"Creating backup path: {backup_path}")
        self.dbutils.fs.mkdirs(backup_path)

        files = self.dbutils.fs.ls(source_path)

        moved_files = 0

        for file in files:
            if file.isDir():
                continue

            source_file = file.path
            target_file = f"{backup_path}/{file.name}"

            self.logger.info(f"Moving file from {source_file} to {target_file}")

            self.dbutils.fs.mv(
                source_file,
                target_file
            )

            moved_files += 1

        self.logger.info(
            f"Moved {moved_files} files from {source_path} to {backup_path}"
        )

        return moved_files
