import traceback
# copy all 4 lines for each plugin
try:
    import denyjob
    reload(denyjob)
except: traceback.print_exc()

try:
    import adjustPriority
    reload(adjustPriority)
except: traceback.print_exc()

try:
    import addServices
    reload(addServices)
except: traceback.print_exc()

try:
    import addFastLane
    reload(addFastLane)
except: traceback.print_exc()
