from django.contrib.gis.db import models
from django.contrib.gis.db.models import PointField

USER_SUBMITTED = 'user'
LITTLE_FREE_LIBRARY = 'little-free-library'

SOURCE_CHOICES = (
    (USER_SUBMITTED, 'User-submitted'),
    (LITTLE_FREE_LIBRARY, 'Little Free Library'),
)


class Library(models.Model):
    location = PointField()
    address = models.CharField(
        max_length=255, null=True, blank=True,
        help_text="Text description of location")
    source = models.CharField(
        max_length=255, null=True, blank=True,
        choices=SOURCE_CHOICES,
        help_text="Data source of library")
    photos = models.ImageField(upload_to='media/libraries', blank=True, null=True)
    verified = models.BooleanField(null=True, blank=True)

    last_updated = models.DateTimeField('date modified', auto_now=True)
    created = models.DateTimeField('date created', auto_now_add=True)

    class Meta:
        verbose_name_plural = "Libraries"

    def __str__(self):
        return self.address

    def get_latitude(self):
        if self.location:
            return self.location[1]
        else:
            return None

    def get_longitude(self):
        if self.location:
            return self.location[0]
        else:
            return None
