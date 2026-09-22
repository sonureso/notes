from django.urls import path
from . import views
from django.views.generic import TemplateView

urlpatterns = [
	path('',views.index,name='home'),
	path('static',views.StaticView.as_view()),
	path('static2/',TemplateView.as_view(template_name='hello_static.html'))
]