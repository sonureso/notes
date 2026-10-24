from django.shortcuts import render
from django.http import HttpResponse
import datetime

def index(request):
	status = "How are you!"
	date = datetime.datetime.now().date()
	return render(request,'hello.html',{"status":status,"date":date})
	#Passing the argument in dictionary format of variables used in html.
	
def question(request):
	que = "What to do?"
	return render(request,'question.html',{'que':que})
	

