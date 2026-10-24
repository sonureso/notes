from django.db import models

class Dreamreal(models.Model):
	website = models.CharField(max_length = 50)
	mail = models.CharField(max_length = 50)
	name = models.CharField(max_length = 50)
	phonenumber = models.IntegerField()
	
	class Meta:
		db_table = "dreamreal"
	def __str__(self):
		return self.name
	#above method will make: Dreamreal.objects.all()
	# to return objects by their names.
