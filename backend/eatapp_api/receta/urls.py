from django.conf.urls import include, url
from rest_framework import routers

from receta.viewsets.receta import RecetaViewSet
from receta.viewsets.ingrediente import IngredienteViewSet
from receta.viewsets.alergeno import AlergenoViewSet
from receta.viewsets.categoria import CategoriaViewSet

router = routers.DefaultRouter(trailing_slash=False)

router.register("recetas", RecetaViewSet)
router.register("ingredientes", IngredienteViewSet)
router.register("alergenos", AlergenoViewSet)
router.register("categorias", CategoriaViewSet)


urlpatterns = [
    url(r'^api/v1/', include(router.urls)),
]