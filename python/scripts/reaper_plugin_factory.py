
class ReaperPluginFactory:
    sReaperFactory = None
    sReaperPlugins = {}

    def __init__(self):
        pass

    def registerPlugin(self, name, pluginFunc):
        ReaperPluginFactory.sReaperPlugins[name] = pluginFunc

    def instance():
        if( not ReaperPluginFactory.sReaperFactory ):
            ReaperPluginFactory.sReaperFactory = ReaperPluginFactory()
        return ReaperPluginFactory.sReaperFactory

