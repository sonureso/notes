from django.shortcuts import render
from django.http import HttpResponse

def index(Request):
	return render(Request, "hello.html")

def viewarticle(request,id):
	text = "Displaying : ",id
	return HttpResponse(text)

def name(request,nm):
	return HttpResponse(nm) 