local mytable = {}
mytable[1] = "Lua"
mytable['lang'] = "Lua Language"

print("mytable:", mytable)
print("mytable[1]:", mytable[1])
print("mytable['lang']:", mytable['lang'])

table.foreach(mytable, print) 
