import csv

csvData=[]
with open('Book1.csv','r')as csvFile:
    reader = csv.reader(csvFile)
    for row in reader:
        csvData.append(row[0].split(','))
with open('Book2.csv','w',newline='') as csvFile:
    writer =  csv.writer(csvFile)
    writer.writerows(csvData)
csvFile.close()
print("Action Done")
print (csvData)
