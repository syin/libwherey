import os

from rest_framework import generics

from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D
from django.shortcuts import render

from web.models import Library
from web.serializers import LibrarySerializer


class LibraryList(generics.ListAPIView):
    serializer_class = LibrarySerializer

    def get_queryset(self):
        default_location = Point(-123.120735, 49.282730)

        if "location" in self.request.GET:
            latitude, longitude = self.request.GET['location'].split(',')
            location = Point(float(longitude), float(latitude))
        else:
            location = default_location

        queryset = Library.objects.filter(
            location__distance_lte=(location, D(m=10000)))

        return queryset


class LibraryDetail(generics.RetrieveAPIView):
    queryset = Library.objects.all()
    serializer_class = LibrarySerializer


def homepage(request):
    context = {
        "mapbox_api_key": os.environ.get("MAPBOX_API_KEY")
    }

    return render(request, "index.html", context)
