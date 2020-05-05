from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User

from .models import Perfil


class PerfilInline(admin.StackedInline):
    model = Perfil
    fk_name = 'user'
    can_delete = False
    verbose_name_plural = 'Perfil de usuario'
    raw_id_fields = ["favoritos"]


def get_sexo(user):
    if user.perfil:
        return user.perfil.sexo

def get_fecha_nacimiento(user):
    if user.perfil:
        return user.perfil.fecha_nacimiento
    

get_sexo.short_description = "Sexo"
get_fecha_nacimiento.short_description = "Fecha Nacimiento"


class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'first_name', 'last_name', get_sexo, get_fecha_nacimiento, 'date_joined', 'last_login')
    inlines = [PerfilInline]
    list_filter = ('is_superuser', 'is_active', 'groups')


# Re-register UserAdmin
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)

