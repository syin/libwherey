import os

from rest_framework import generics

from django.shortcuts import render

from web.models import AppModel
from web.serializers import AppModelSerializer


class AppModelList(generics.ListCreateAPIView):
    queryset = AppModel.objects.all()
    serializer_class = AppModelSerializer


class AppModelDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = AppModel.objects.all()
    serializer_class = AppModelSerializer


def homepage(request):
    context = {
        "mapbox_api_key": os.environ.get("MAPBOX_API_KEY")
    }

    return render(request, "index.html", context)
