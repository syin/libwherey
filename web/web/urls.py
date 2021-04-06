from django.contrib import admin
from django.urls import path
from django.conf.urls import url

import web.views

urlpatterns = [
    path('admin/', admin.site.urls),

    url(r"^$", web.views.homepage),
    url(r"^about$", web.views.about),
    url(r"^api/libraries/(?P<pk>[0-9]+)$", web.views.LibraryDetail.as_view()),
    url(r"^api/libraries$", web.views.LibraryList.as_view()),

]
