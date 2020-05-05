from django import forms
from django.contrib.auth import login, logout
from django.contrib.auth.forms import AuthenticationForm, SetPasswordForm
from django.contrib.auth.models import User
from django.utils.http import (is_safe_url, urlsafe_base64_decode,
                               urlsafe_base64_encode)
from rest_framework import serializers, status, viewsets
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from django.contrib.auth.tokens import default_token_generator
from api.utils import es_usuario
from perfil.models import Perfil
from perfil.serializers.perfil import (PerfilSaveSerializer, PerfilSerializer, RegistroSerializer)


# def enviar_cambio_contrasena(user):
#     token_generator = default_token_generator
#     token = token_generator.make_token(user)
#     uuid = urlsafe_base64_encode(force_bytes(user.pk))
#     enlace = "https://m.voltio.app/user/reset-password/" + token + "/" + uuid

#     enviar_mail(to_email=user.email,
#                 subject="Cambio de Contraseña",
#                 body=MENSAJE_CONTRASEÑA.format(nombre_usuario=user.perfil.nombre,
#                                                url=enlace))


def get_user(uuid):
    try:
        # urlsafe_base64_decode() decodes to bytestring
        uid = urlsafe_base64_decode(uuid).decode()
        user = User._default_manager.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist, ValidationError):
        user = None
    return user


class PerfilViewSet(viewsets.ViewSet):

    @action(detail=False, methods=["POST"])
    def register(self, request):
        # aceptar_politica = request.data.get("politica-privacidad")

        # if not (aceptar_politica):
        #     raise ValidationError({"politica-privacidad": ["Debes aceptar la política de Privacidad"]})

        serializer = RegistroSerializer(data=request.data, context={"request": request})
        serializer.is_valid(raise_exception=True)
        perfil = serializer.save()

        return Response(PerfilSerializer(perfil).data)

    @action(detail=False, methods=["GET", "POST", "DELETE", "PATCH"])
    def me(self, request):
        import ipdb; ipdb.set_trace()
        if not request.user.is_authenticated:
            return Response({})

        perfil = request.user.perfil

        if request.method == "POST":
            klass = PerfilSaveSerializer

            serializer = klass(instance=perfil,
                               data=request.data,
                               context={"_loged": request})
            serializer.is_valid(raise_exception=True)
            serializer.save()

        if request.method == "PATCH":
            serializer = PerfilSaveSerializer(instance=perfil,
                                              data=request.data,
                                              context={"request": request},
                                              partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()

        if request.method == "DELETE":
            perfil.user.is_active = False
            perfil.user.save()

            return Response({}, status=status.HTTP_204_NO_CONTENT)

        return Response(PerfilSerializer(perfil).data)

    @action(detail=False, methods=["POST"])
    def login(self, request):
        import ipdb; ipdb.set_trace()
        logout(request)
        form = AuthenticationForm(request, data=request.data)

        if form.is_valid():
            user = form.get_user()
            if not es_usuario(user):
                raise ValidationError({"__all__": ["Las credenciales no son válidas"]})

            return Response(PerfilSerializer(user.perfil).data)

        return Response(form.errors, status=400)

    @action(detail=False)
    def logout(self, request):
        logout(request)
        return Response({})

    @action(detail=False, methods=["GET", "POST"])
    def password_reset(self, request):
        username = request.data.get("username")
        user = User.objects.filter(username=username).first()
        if user:
            #enviar_cambio_contrasena(user)
            return Response({}, status=status.HTTP_200_OK)
        return Response({"email": "El email no está registrado"}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=["POST"])
    def password_reset_confirm(self, request):
        uuid = request.data.get("uuid")
        token = request.data.get("token")

        user = get_user(uuid)
        if user and default_token_generator.check_token(user, token):
            form = SetPasswordForm(user, request.data)
            if not form.is_valid():
                return Response(form.errors, status=status.HTTP_400_BAD_REQUEST)
            else:
                form.save()

        serializer = PerfilSerializer(user.perfil)
        return Response(serializer.data, status=status.HTTP_200_OK)