from rest_framework import serializers
from drf_extra_fields.geo_fields import PointField

from web.models import Library


class LibrarySerializer(serializers.ModelSerializer):
    queryset = Library.objects.all()

    location = PointField()
    source = serializers.CharField(source='get_source_display')

    class Meta:
        model = Library
        fields = ("id", "address", "location", "photos", "source")
