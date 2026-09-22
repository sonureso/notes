from django.contrib import admin
from django.urls import path
from myapp import views

urlpatterns = [
	path('',views.check),
	path('data/', views.Student_List.as_view()),
	path('data2/', views.check2),
    path('admin/', admin.site.urls),
]
