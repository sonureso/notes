from django.urls import path
from . import views

urlpatterns=[
	path('',views.index,name='home'),
	path('add/',views.add,name='add'),
	path('read/',views.read,name='read'),
	path('delete/',views.delete,name='del')
]