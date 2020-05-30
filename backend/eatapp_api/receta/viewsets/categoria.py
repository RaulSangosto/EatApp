from rest_framework import viewsets
from receta.serializers.categoria import CategoriaSerializer
from receta.models import Categoria
from rest_framework.decorators import action
from rest_framework.response import Response
import datetime

class CategoriaViewSet(viewsets.ModelViewSet):
    serializer_class = CategoriaSerializer
    queryset = Categoria.objects.all()

    @action(detail=False, methods=["GET"])
    def categoria_hoy(self, request):
        hoy = datetime.date.today().weekday()
        perfil = request.user.perfil
        categorias = perfil.categoriasSemana.all()
        if categorias:
            cat_hoy = hoy % len(categorias)
            categoria = categorias[cat_hoy]
            return Response(CategoriaSerializer(categoria).data)