import pandas as pd
import numpy as np
from bs4 import BeautifulSoup as soup
from urllib.request import Request, urlopen

#----------function for scrap---------------------------#
def printque(d):
    print('No:',d.find("td",{"class":"bix-td-qno"}).text)
    print('Question:',d.find("td",{"class":"bix-td-qtxt"}).text)
    opt = d.findAll("td",{"class":"bix-td-option"})
    t = int(len(opt)/2)
    for i in range(0,t):
        print("Op",opt[2*i].text," ",opt[2*i+1].text)
        
    ans = d.find("div",{"class":"bix-div-answer"})
    print(ans.p.text)
    print("desc:",ans.div.text)
#--------------------------------------------------------#
req = Request('https://www.indiabix.com/verbal-ability/spotting-errors/', headers={'User-Agent': 'Mozilla/5.0'})
client = urlopen(req)
webpage = client.read()
client.close()

page_soup = soup(webpage,"html.parser")
containers = page_soup.findAll("div",{"class":"bix-div-container"})
desc = page_soup.find("div",{"class":"div-spacer"})
print(desc.text)
for cont in containers:
    printque(cont)
    print('\n')

