from rest_framework import serializers
from receta.models import Receta, Categoria
from drf_extra_fields.fields import Base64ImageField

class RecetaSerializer(serializers.ModelSerializer):
    imagen=Base64ImageField(required=False)

    class Meta:
        model = Receta
        fields = '__all__'