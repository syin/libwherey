import os

from rest_framework import generics

from django.shortcuts import render

from web.models import Library
from web.serializers import LibrarySerializer


class LibraryList(generics.ListCreateAPIView):
    queryset = Library.objects.all()
    serializer_class = LibrarySerializer


class LibraryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Library.objects.all()
    serializer_class = LibrarySerializer


def homepage(request):
    context = {
        "mapbox_api_key": os.environ.get("MAPBOX_API_KEY")
    }

    return render(request, "index.html", context)
