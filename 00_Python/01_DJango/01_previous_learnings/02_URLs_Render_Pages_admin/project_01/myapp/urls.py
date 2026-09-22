from django.urls import path, re_path
from . import views

urlpatterns = [
    path('hello/', views.index, name='index'),
    re_path(r'^article/(?P<id>[0-9]{4})/$', views.viewarticle, name='article'),
    re_path(r'^name/([0-9]{4})/$', views.name, name='nm'),
]