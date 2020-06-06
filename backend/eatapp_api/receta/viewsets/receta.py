from rest_framework import viewsets, filters
from rest_framework.response import Response
from receta.serializers.receta import RecetaSerializer
from receta.models import Receta
from rest_framework.decorators import action

class RecetaViewSet(viewsets.ModelViewSet):
    search_fields = ['titulo']
    filter_backends = (filters.SearchFilter,)
    serializer_class = RecetaSerializer
    queryset = Receta.objects.all()

    def get_queryset(self):
        #import ipdb; ipdb.set_trace()
        qs = self.request.query_params
        if qs.__contains__('categorias'):
            categorias = qs.get('categorias')
            return Receta.objects.filter(categoria__in=categorias)
        return Receta.objects.all()
    
    @action(detail=False, methods=["GET"])
    def ultimas(self, request):
        #import ipdb; ipdb.set_trace()
        qs = self.get_queryset()
        #import ipdb; ipdb.set_trace()
        recetas = qs.order_by('-created')[:5]
        return Response(RecetaSerializer(recetas, many=True).data)
