from django.shortcuts import render
from django.http import HttpResponse
import datetime

def index(request):
	return HttpResponse("Hello World.")
	
def msg(request):
	name = 'Learning Django'
	# will see filter built-ins on this a.html page.
	return render(request,'a.html',{'name':name})
	
def date(request):
	today = datetime.datetime.now().date()
	Week_days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
	return render(request,'date.html',{'today':today,'Week_days':Week_days})
