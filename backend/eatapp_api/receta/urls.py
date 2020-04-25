from django.conf.urls import include, url
from rest_framework import routers

from receta.viewsets.receta import RecetaViewSet
from receta.viewsets.ingrediente import IngredienteViewSet
from receta.viewsets.alergeno import AlergenoViewSet
from receta.viewsets.categoria import CategoriaViewSet
from receta.viewsets.instruccion import InstruccionViewSet

router = routers.DefaultRouter(trailing_slash=False)

router.register("recetas", RecetaViewSet)
router.register("ingredientes", IngredienteViewSet)
router.register("alergenos", AlergenoViewSet)
router.register("categorias", CategoriaViewSet)
router.register("instrucciones", InstruccionViewSet)


urlpatterns = [
    url(r'^api/v1/', include(router.urls)),
]