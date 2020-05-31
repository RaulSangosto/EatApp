from rest_framework import serializers
from receta.models import Categoria
from receta.serializers.receta import RecetaSerializer 

class CategoriaSerializer(serializers.ModelSerializer):

    class Meta:
        model = Categoria
        fields = '__all__'