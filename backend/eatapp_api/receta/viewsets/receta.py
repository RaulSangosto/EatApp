from rest_framework import viewsets
from receta.serializers.receta import RecetaSerializer
from receta.models import Receta

class RecetaViewSet(viewsets.ModelViewSet):
    serializer_class = RecetaSerializer
    queryset = Receta.objects.all()

    def get_queryset(self):
        categorias = self.request.query_params.get('categorias')
        if categorias and categorias!= 'null':
            return Receta.objects.filter(categorias__in=categorias)
        return Receta.objects.all()
