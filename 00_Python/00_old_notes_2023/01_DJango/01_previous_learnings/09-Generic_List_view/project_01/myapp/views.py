from django.shortcuts import render
from django.http import HttpResponse
from myapp.models import book

def index(request):
	return HttpResponse('Hello Everyone')

def add(request):
	book1 = book(name = 'The Truth',author = 'Mr. Ranjan', price = '250')
	book1.save()
	return HttpResponse('Data Saved')

def read(request):
	books = book.objects.all()
	d = ''
	for b in books:
		d+="Name: "+b.name+", Price: "+str(b.price)+"\n"
	return render(request,'print.html',{'data':d})

def delete(request):
	books = book.objects.all()
	for i in range(len(books)):
		books[i].delete()
	return HttpResponse('All Books Deleted.')