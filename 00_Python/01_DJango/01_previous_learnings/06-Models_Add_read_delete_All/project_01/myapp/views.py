from django.shortcuts import render
from django.http import HttpResponse
from myapp.models import Dreamreal

def index(request):
	return HttpResponse("Congo, You reached Home.")

def add(request):
	dreamreal = Dreamreal(website = "mysksongs.online", mail = "sk@gmail.com",
							name = "sonu", phonenumber = "002376970")
	dreamreal.save()
	return HttpResponse('Data Saved')

def read(request):
	objects = Dreamreal.objects.all()
	res =''
	
	for elt in objects:
		res += "Name: "+elt.name+", Mail: "+elt.mail+"\n\n"
	return render(request,'print.html',{'data':res})
	
def delete(request):
	rows = Dreamreal.objects.all()
	for i in range(0,len(rows)):
		if(rows[i].name=='sonu'):
			rows[i].delete()
	objects = Dreamreal.objects.all()
	res =''
	for elt in objects:
		res += "Name:"+elt.name+", E-mail:"+elt.mail+"------"
	return render(request,'print.html',{'data':res})