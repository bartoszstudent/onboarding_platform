from rest_framework import permissions
from .models import UserCompany, Workspace, UserRole

class IsCompanyAdmin(permissions.BasePermission):
    """
    Pozwala na dostęp tylko użytkownikom z rolą admin/owner w danej firmie.
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
            role__in=[UserRole.ADMIN, UserRole.OWNER]
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
            role__in=[UserRole.ADMIN, UserRole.OWNER]
        ).exists()


class IsCompanyHR(permissions.BasePermission):
    """
    Pozwala dostęp użytkownikom z rolą HR, Admin lub Owner.
    Używane dla operacji związanych z onboardingiem.
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
            role__in=[UserRole.HR, UserRole.ADMIN, UserRole.OWNER]
        ).exists()


class IsCompanyMember(permissions.BasePermission):
    """
    Pozwala dostęp każdemu uwierzytelnionemu użytkownikowi należącemu do firmy.
    """
    
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        try:
            UserCompany.objects.get(user=request.user)
            return True
        except UserCompany.DoesNotExist:
            return False


class CanManageUserRoles(permissions.BasePermission):
    """
    Pozwala zmianę ról tylko właścicielowi lub adminowi.
    Zapobiega eskalacji uprawnień (zwykły admin nie może podwyższać uprawnień).
    """
    
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        company_id = view.kwargs.get('company_pk')
        
        try:
            user_company = UserCompany.objects.get(
                user=request.user, 
                company_id=company_id
            )
            # Tylko Owner i Admin mogą zarządzać rolami
            return user_company.role in [UserRole.OWNER, UserRole.ADMIN]
        except UserCompany.DoesNotExist:
            return False