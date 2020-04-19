from rest_framework import viewsets
from receta.serializers.alergeno import AlergenoSerializer
from receta.models import Alergeno

class AlergenoViewSet(viewsets.ModelViewSet):
    serializer_class = AlergenoSerializer
    queryset = Alergeno.objects.all()