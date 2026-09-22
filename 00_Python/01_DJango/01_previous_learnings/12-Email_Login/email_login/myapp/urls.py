from django.urls import path,include
from . import views
from django.views.generic import TemplateView

urlpatterns = [
	path('home/',TemplateView.as_view(template_name='home.html'),name="home"),
	path('',views.index)
]
