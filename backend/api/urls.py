from django.contrib import admin
from django.urls import path
from core.views import login_view, create_company, list_companies, get_company

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/login/', login_view, name='api-login'),
    path('api/companies/', create_company, name='api-create-company'),
    path('api/companies/list/', list_companies, name='api-list-companies'),
    path('api/companies/<int:pk>/', get_company, name='api-get-company'),
]
