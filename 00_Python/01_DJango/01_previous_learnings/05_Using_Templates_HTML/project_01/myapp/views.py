from django.shortcuts import render
from django.http import HttpResponse

def index(request):
	name = 'Shubham'
	return render(request,'hello.html',{'name':name})
