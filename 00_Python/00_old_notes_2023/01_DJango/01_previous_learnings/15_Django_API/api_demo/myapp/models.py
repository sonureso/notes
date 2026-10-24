from django.db import models

class Student(models.Model):
	name = models.CharField(max_length=25)
	city = models.CharField(max_length=25)
	roll =  models.IntegerField(unique=True)
	
	def __str__(self):
		return self.name