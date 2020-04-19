from rest_framework import viewsets
from receta.serializers.ingrediente import IngredienteSerializer
from receta.models import Ingrediente

class IngredienteViewSet(viewsets.ModelViewSet):
    serializer_class = IngredienteSerializer
    queryset = Ingrediente.objects.all()