import json
import time

import requests

from django.contrib.gis.geos import Point
from django.core.management.base import BaseCommand

from web.models import LITTLE_FREE_LIBRARY, Library

API_URL = 'https://nominatim.openstreetmap.org/reverse?lat={lat}&lon={lon}&format=json'
DATA_FILE_PATH = 'data/littlefreelibrary.json'


class Command(BaseCommand):
    def handle(self, *args, **options):
        # load_lfls_from_json()
        reverse_geocode_libraries()


def load_lfls_from_json():
    f = open(DATA_FILE_PATH, 'r')
    data = json.loads(f.read())
    f.close()

    for entry in data:
        lat = entry['library']['Library_Geolocation__c']['latitude']
        lon = entry['library']['Library_Geolocation__c']['longitude']
        print(lat, lon)
        point = Point(float(lon), float(lat))

        try:
            Library.objects.get(location=point)
        except Library.DoesNotExist:
            Library.objects.create(
                location=point,
                source=LITTLE_FREE_LIBRARY)


def reverse_geocode_libraries():
    libraries = Library.objects.filter(location__isnull=False, address__isnull=True)
    print("libraries", libraries)

    for library in libraries:
        print("library", library.location)

        response = requests.get(API_URL.format(lat=library.get_latitude(), lon=library.get_longitude()))
        print("response", response, response.json())

        data = response.json()
        if 'address' in data:
            library.address = '{} {}'.format(
                data['address'].get('house_number', ''),
                data['address'].get('road', '')).strip()
            library.save()
            print("saved address", library.address)
        else:
            print("no address")

        time.sleep(1)
