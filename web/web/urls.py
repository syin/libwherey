from django.contrib import admin
from django.urls import path
from django.conf.urls import url

import web.views

urlpatterns = [
    path('admin/', admin.site.urls),

    url(r"^$", web.views.homepage),
]
