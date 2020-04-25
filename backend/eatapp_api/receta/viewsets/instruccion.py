from rest_framework import viewsets
from receta.serializers.instruccion import InstruccionSerializer
from receta.models import Instruccion

class InstruccionViewSet(viewsets.ModelViewSet):
    serializer_class = InstruccionSerializer
    queryset = Instruccion.objects.all()