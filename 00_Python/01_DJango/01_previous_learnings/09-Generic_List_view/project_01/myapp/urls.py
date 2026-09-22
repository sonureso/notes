from django.urls import path
from . import views
from django.views.generic import ListView
from myapp.models import book

urlpatterns = [
	path('',views.index,name='home'),
	path('add/',views.add,name='add'),
	path('read/',views.read,name='read'),
	path('delete/',views.delete,name='delete'),
	path('list/',ListView.as_view(model=book,template_name='list_view.html')),
]