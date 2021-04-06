from rest_framework import serializers
from drf_extra_fields.geo_fields import PointField

from web.models import Library


class LibrarySerializer(serializers.ModelSerializer):
    queryset = Library.objects.all()

    location = PointField()
    source_display = serializers.CharField(source='get_source_display', read_only=True)

    class Meta:
        model = Library
        fields = ("id", "address", "location", "source", "source_display")
