from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Student
from .serializers import StudentSerializer
def check(request):
	return HttpResponse('All Good')

class Student_List(APIView):
	
	def get(self,request):
		students = Student.objects.all()
		serializer = StudentSerializer(students, many=True)
		return Response(serializer.data)
	
	def post(self):
		pass
		
def check2(request):
	students = Student.objects.all()
	serializer = StudentSerializer(students, many=True)
	return HttpResponse(list(serializer.data))
		