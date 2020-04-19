from rest_framework import viewsets
from receta.serializers.categoria import CategoriaSerializer
from receta.models import Categoria

class CategoriaViewSet(viewsets.ModelViewSet):
    serializer_class = CategoriaSerializer
    queryset = Categoria.objects.all()