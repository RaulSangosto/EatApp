from django.contrib import admin
from .models import Receta, Ingrediente, Alergeno, Instruccion, Categoria

admin.site.register(Receta)
admin.site.register(Ingrediente)
admin.site.register(Instruccion)
admin.site.register(Alergeno)
admin.site.register(Categoria)