from django.shortcuts import render
from django.http import HttpResponse
from django.views.generic import TemplateView

def index(request):
	return HttpResponse('Hello There.')

class StaticView(TemplateView):
   template_name = "hello_static.html"

