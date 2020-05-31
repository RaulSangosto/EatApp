import secrets
import string
from django.contrib.auth import login as auth_login
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import \
    validate_password as validate_password_orig
from rest_framework import serializers
from rest_framework.authtoken.models import Token
from drf_extra_fields.fields import Base64ImageField
from perfil.models import Perfil

alphabet = string.ascii_letters + string.digits
numbers = string.digits

class PerfilSerializer(serializers.ModelSerializer):
    email = serializers.ReadOnlyField(source="user.email")
    #avatar = serializers.ReadOnlyField()
    token = serializers.SerializerMethodField()

    class Meta:
        model = Perfil
        #exclude = ["foto"]
        fields = '__all__'

    def get_token(self, obj):
        token, _ = Token.objects.get_or_create(user=obj.user)
        return token.key


class PerfilSaveSerializer(serializers.ModelSerializer):
    email = serializers.ReadOnlyField(source="user.email")
    foto = Base64ImageField(required=False)
    #avatar = serializers.ReadOnlyField()
    password_actual = serializers.CharField(required=False, allow_blank=True)
    password = serializers.CharField(required=False, allow_blank=True)
    password2 = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = Perfil
        fields = '__all__'

    def validate_password_actual(self, value):
        request = self.context.get("request")
        if value and not request.user.check_password(value):
            raise serializers.ValidationError("La contraseña no es correcta")
        return value

    def validate_password(self, value):
        print("validate password")
        validate_password_orig(value)
        return value

    def validate_password2(self, value):
        if value != self.initial_data.get("password"):
            raise serializers.ValidationError("Las contraseñas no coinciden")
        return value

    def validate(self, data):
        if data.get("password2") != data.get("password"):
            raise serializers.ValidationError({"password2": "Las contraseñas no coinciden"})

        if data.get("password_actual") and not data.get("password"):
            raise serializers.ValidationError({"password": ('This field may not be blank.'),
                                               "password2": ('This field may not be blank.')})
        return data

    def update(self, instance, validated_data):
        request = self.context.get("request")
        instance = super().update(instance, validated_data)
        password_actual = validated_data.get("password_actual")
        password = validated_data.get("password")
        if password and password_actual:
            request.user.set_password(password)
            request.user.save()
            update_session_auth_hash(request, request.user)
        return instance


class RegistroSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    password = serializers.CharField()
    password2 = serializers.CharField()
    sexo = serializers.CharField()
    fecha_nacimiento = serializers.DateField()
    activo = serializers.BooleanField(default=False)

    class Meta:
        model = Perfil
        exclude = ["user", "foto"]

    def validate_password(self, value):
        validate_password_orig(value)
        return value

    def validate_password2(self, value):
        if value != self.initial_data.get("password"):
            raise serializers.ValidationError("Las contraseñas no coinciden")
        return value

    def validate_email(self, value):
        email = value.lower()
        if User.objects.filter(username=email).exists():
            raise serializers.ValidationError("El email ya está registrado")
        return email

    # def validate_fecha_nacimiento(self, value):
    #     hoy = date.today()
    #     fecha_mayoria_edad = hoy - (timedelta(days=6574))

    #     if value > fecha_mayoria_edad:
    #         raise serializers.ValidationError("Debes de ser mayor de edad")
    #     return value

    def validate(self, data):
        request = self.context.get("request")
        email = data.pop("email")
        email.lower()
        password = data.pop("password")
        data.pop("password2")
        #potitica_privacidad = data.pop("politica-privacidad")

        user = User.objects.create(username=email,
                                   email=email,
                                   is_active=True)
        user.set_password(password)
        user.save()

        data["user"] = user
        data["invitacion"] = ''.join(secrets.choice(numbers) for i in range(4))
        auth_login(request, user, backend='django.contrib.auth.backends.ModelBackend')
        return data