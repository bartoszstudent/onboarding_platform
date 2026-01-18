from rest_framework import permissions
from .models import UserCompany, Workspace

class IsCompanyAdmin(permissions.BasePermission):
    """
    Pozwala na dostęp tylko użytkownikom, którzy mają rolę 'admin' lub 'owner' w danej firmie.
    Wymaga przekazania 'company_id' w URL lub w body (zależnie od kontekstu).
    """

    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False

        # Próbujemy pobrać company_id z argumentów URL (np. /api/companies/<id>/users/)
        company_id = view.kwargs.get('company_pk') or view.kwargs.get('pk')
        
        # Jeśli to request POST do tworzenia kursu, company_id może być w request.data
        if not company_id and request.method == 'POST':
            company_id = request.data.get('company_id')

        if not company_id:
            # W przypadku braku ID w prostym sprawdzeniu, puszczamy dalej do has_object_permission
            return True 

        return UserCompany.objects.filter(
            user=request.user, 
            company_id=company_id, 
            role__in=['admin', 'owner']
        ).exists()

    def has_object_permission(self, request, view, obj):
        # Sprawdzenie przy edycji konkretnego obiektu (np. Firmy)
        if hasattr(obj, 'company'): # Np. Workspace, Course
            company = obj.company
        elif isinstance(obj, UserCompany):
            company = obj.company
        else:
            company = obj # Zakładamy, że obj to Company

        return UserCompany.objects.filter(
            user=request.user, 
            company=company, 
            role__in=['admin', 'owner']
        ).exists()