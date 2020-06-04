from rest_framework import viewsets
from receta.serializers.instruccion import InstruccionSerializer
from receta.models import Instruccion

class InstruccionViewSet(viewsets.ModelViewSet):
    serializer_class = InstruccionSerializer
    queryset = Instruccion.objects.all()

    def get_queryset(self):
        #import ipdb; ipdb.set_trace()
        qs = self.request.query_params
        if qs.__contains__('receta'):
            receta = qs.get('receta')
            return Instruccion.objects.filter(receta=receta)
        return Instruccion.objects.all()