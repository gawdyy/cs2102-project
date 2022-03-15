from random import *

def textAutomater(filename):
    seed(2102)
    FILE = open(filename, "w")
    for i in range(1, 41):
        temp = round(uniform(34.1, 37.4), 1)
        L = "EXECUTE FUNCTION declare_health({}, {})\n".format(i, temp)
        FILE.writelines(L)
    FILE.close()
    return FILE 
    

file = "declare.txt"
textAutomater(file)