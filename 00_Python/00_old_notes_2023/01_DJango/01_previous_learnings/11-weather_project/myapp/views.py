from django.shortcuts import render
from django.http import HttpResponse
import requests
from myapp.models import city as city_table
from myapp.forms import CityForm

def index(request):
    url = 'http://api.openweathermap.org/data/2.5/weather?q={}&units=imperial&appid=271d1234d3f497eed5b1d80a07b3fcd1'
    
    if request.method == 'POST':
        form = CityForm(request.POST)
        form.save()

    form = CityForm()

    weather_data = []
    cities = city_table.objects.all()
    try:
        r = requests.get(url.format(cities[0])).json()
    except:
        return HttpResponse("Error Reaching to the API Call.")

    for city in cities:
        r = requests.get(url.format(city)).json()
        city_weather = {
                'city' : city,
                'temperature':round((r['main']['temp'] - 32) * (5/9),2),
                'desc':r['weather'][0]['description'],
                'icon':r['weather'][0]['icon']
            }
        weather_data.append(city_weather)
    
    context = {'weather_data':weather_data,'form':form}

    return render(request,'weather.html',context)
