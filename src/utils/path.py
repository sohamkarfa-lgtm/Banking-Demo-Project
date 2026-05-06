class PathUtils:
    def __init__(self, config):
        self.config = config

    def raw_path(self, entity):
        return f"{self.config.raw_volume}/{entity}"

    def checkpoint_path(self, entity, layer):
        return f"{self.config.checkpoint_base}/{layer}/{entity}"
