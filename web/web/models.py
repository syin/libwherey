from django.contrib.gis.db import models
from django.contrib.gis.db.models import PointField
from django.contrib.postgres.fields import ArrayField


class Library(models.Model):
    location = PointField()
    address = models.CharField(
        max_length=255, help_text="Text description of location")
    photos = ArrayField(
        models.ImageField(upload_to='libraries', blank=True, null=True),
        blank=True, null=True)

    class Meta:
        verbose_name_plural = "Libraries"
