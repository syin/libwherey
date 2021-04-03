from django.contrib.gis.db import models
from django.contrib.gis.db.models import PointField


class Library(models.Model):
    location = PointField()
    address = models.CharField(
        max_length=255, help_text="Text description of location")
    photos = models.ImageField(upload_to='media/libraries', blank=True, null=True)

    class Meta:
        verbose_name_plural = "Libraries"
