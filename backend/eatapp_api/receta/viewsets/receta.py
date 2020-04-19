from rest_framework import viewsets
from receta.serializers.receta import RecetaSerializer
from receta.models import Receta

class RecetaViewSet(viewsets.ModelViewSet):
    serializer_class = RecetaSerializer
    queryset = Receta.objects.all()