from django.db import models

class book(models.Model):
	name = models.CharField(max_length=60)
	author = models.CharField(max_length=60)
	price = models.IntegerField()

	def __str__(self):
		return self.name
