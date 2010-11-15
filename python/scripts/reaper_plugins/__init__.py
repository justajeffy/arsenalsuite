# copy all 4 lines for each plugin
try:
    import denyjob
    reload(denyjob)
except: traceback.print_exc()
