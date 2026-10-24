from django.urls import path
from . import views
from django.views.generic import TemplateView

urlpatterns = [
    path('', views.index, name='index'),
	path('connection/',TemplateView.as_view(template_name='login.html')),
	path('login/',views.login,name='login'),
	
]