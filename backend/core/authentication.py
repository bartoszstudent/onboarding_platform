# backend/core/authentication.py

from rest_framework import authentication
from rest_framework import exceptions
from django.core import signing
from django.contrib.auth import get_user_model

User = get_user_model()

class CustomSignedTokenAuthentication(authentication.BaseAuthentication):
    def authenticate(self, request):
        # Pobierz nagłówek Authorization
        auth_header = request.headers.get('Authorization')
        
        if not auth_header:
            return None

        # Oczekujemy formatu: "Bearer <token>"
        try:
            prefix, token = auth_header.split()
            if prefix.lower() != 'bearer':
                return None
        except ValueError:
            return None

        # Próba odczytania tokena (odwrotność tego co masz w login_view)
        try:
            # max_age=60*60*24*7 musi być takie samo jak w login_view (7 dni)
            payload = signing.loads(token, salt="auth-token", max_age=60*60*24*7)
        except signing.SignatureExpired:
            raise exceptions.AuthenticationFailed('Token wygasł')
        except signing.BadSignature:
            raise exceptions.AuthenticationFailed('Nieprawidłowy token')

        user_id = payload.get('user_id')
        if not user_id:
            raise exceptions.AuthenticationFailed('Brak ID użytkownika w tokenie')

        try:
            user = User.objects.get(pk=user_id)
        except User.DoesNotExist:
            raise exceptions.AuthenticationFailed('Użytkownik nie istnieje')

        return (user, None)