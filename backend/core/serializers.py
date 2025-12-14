from rest_framework import serializers
from .models.workspaces import Company


class CompanySerializer(serializers.ModelSerializer):
    """Serializer do tworzenia i pobierania firm"""

    class Meta:
        model = Company
        fields = ["id", "name", "domain", "created_at"]
        read_only_fields = ["id", "created_at"]
