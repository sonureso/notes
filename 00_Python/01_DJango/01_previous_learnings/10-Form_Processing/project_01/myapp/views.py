from django.shortcuts import render
from django.http import HttpResponse
from myapp.forms import LoginForm

def index(request):
    return HttpResponse("Hello, world. You're at the First Page.")
	
def login(request):
	
	username = "1"
	if request.method == "POST":
		username = 'trbj'
		#Get the posted form
		MyLoginForm = LoginForm(request.POST) 
		username = MyLoginForm.errors
		# Now do all validations here.
		if MyLoginForm.is_valid():
			username = '3'
			username = MyLoginForm.cleaned_data['username']
			username += MyLoginForm.cleaned_data['password']
	else:
		MyLoginForm = LoginForm()
		
	return render(request, 'loggedin.html', {"username" : username})
	


