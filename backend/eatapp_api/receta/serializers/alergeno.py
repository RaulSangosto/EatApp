from rest_framework import serializers
from receta.models import Alergeno

class AlergenoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Alergeno
        fields = '__all__'