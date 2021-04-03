from django.contrib import admin

from web.models import Library


@admin.register(Library)
class LibraryAdmin(admin.ModelAdmin):
    model = Library
    list_display = ("id", "address",)
