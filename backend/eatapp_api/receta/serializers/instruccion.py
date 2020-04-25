from rest_framework import serializers
from receta.models import Instruccion

class InstruccionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Instruccion
        fields = '__all__'