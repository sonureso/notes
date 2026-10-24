file = open("file.txt", "w+")

for i in range(1,10001):
	s = "##########"*4+"\n           Table of :"+str(i)+" ->            \n"+"##########"*4+"\n"
	for j in range(1,11):
		t = str(i)+" * "+str(j)+" = "+str(i*j)+"\n"
		s = s+t
		file.write(s)
		s = ""
print("File Created!")