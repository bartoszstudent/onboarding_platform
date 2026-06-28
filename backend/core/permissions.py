from rest_framework import permissions
from .models import UserCompany, Workspace

class IsCompanyAdmin(permissions.BasePermission):
    """
    Pozwala na dostęp TYLKO administratorom i właścicielom.
    (Do użycia przy wrażliwych operacjach jak edycja samej firmy)
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False

        company_id = view.kwargs.get('company_pk') or view.kwargs.get('pk')
        if not company_id and request.method == 'POST':
            company_id = request.data.get('company_id')

        if not company_id:
            return True 

        return UserCompany.objects.filter(
            user=request.user, 
            company_id=company_id, 
            role__in=['admin', 'owner', 'super_admin']
        ).exists()

    def has_object_permission(self, request, view, obj):
        if hasattr(obj, 'company'): 
            company = obj.company
        elif isinstance(obj, UserCompany):
            company = obj.company
        else:
            company = obj 

        return UserCompany.objects.filter(
            user=request.user, 
            company=company, 
            role__in=['admin', 'owner', 'super_admin']
        ).exists()


class IsCompanyAdminOrHR(permissions.BasePermission):
    """
    Pozwala na dostęp Administratorom, Właścicielom ORAZ pracownikom HR.
    (Idealne dla widoków zarządzania kursami, onboardingiem i pracownikami)
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False

        company_id = view.kwargs.get('company_pk') or view.kwargs.get('pk')
        if not company_id and request.method == 'POST':
            company_id = request.data.get('company_id')

        if not company_id:
            return True 

        return UserCompany.objects.filter(
            user=request.user, 
            company_id=company_id, 
            role__in=['admin', 'owner', 'super_admin', 'hr']
        ).exists()

    def has_object_permission(self, request, view, obj):
        if hasattr(obj, 'company'): 
            company = obj.company
        elif isinstance(obj, UserCompany):
            company = obj.company
        else:
            company = obj 

        return UserCompany.objects.filter(
            user=request.user, 
            company=company, 
            role__in=['admin', 'owner', 'super_admin', 'hr']
        ).exists()