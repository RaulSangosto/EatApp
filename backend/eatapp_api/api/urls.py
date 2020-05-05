from django.conf.urls import include, url
from rest_framework import routers

from perfil.viewsets.perfil import PerfilViewSet
from receta.viewsets.receta import RecetaViewSet
from receta.viewsets.ingrediente import IngredienteViewSet
from receta.viewsets.alergeno import AlergenoViewSet
from receta.viewsets.categoria import CategoriaViewSet
from receta.viewsets.instruccion import InstruccionViewSet

router = routers.DefaultRouter(trailing_slash=False)

router.register("recetas", RecetaViewSet, basename='recetas')
router.register("ingredientes", IngredienteViewSet, basename='ingredientes')
router.register("alergenos", AlergenoViewSet, basename='alergenos')
router.register("categorias", CategoriaViewSet, basename='categorias')
router.register("instrucciones", InstruccionViewSet, basename='instrucciones')
router.register("perfil", PerfilViewSet, basename='perfil')


urlpatterns = [
    url(r'^api/v1/', include(router.urls)),
]