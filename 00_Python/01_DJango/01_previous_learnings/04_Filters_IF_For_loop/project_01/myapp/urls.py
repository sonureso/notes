from django.urls import path
from . import views

urlpatterns = [
	path('',views.index,name='index'),
	path('msg/',views.msg,name='display'),
	path('date/',views.date,name='date'),
]