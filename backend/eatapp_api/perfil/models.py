from django.db import models
from django.contrib.auth.models import User
from easy_thumbnails.files import get_thumbnailer


SEXO = (('m', 'Mujer'), ('h', 'Hombre'), ('x', 'Otros'))
DIETA = (('o', 'Omnivora'), ('v', 'Vegetariana'), ('n', "Vegana"))

# Create your models here.
class Perfil(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    activo = models.BooleanField(default=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.CharField(max_length=200, null=True, blank=True)
    ubicacion = models.CharField(max_length=30, null=True, blank=True)
    dieta = models.CharField(max_length=1, choices=DIETA)
    kcal_diarias = models.IntegerField(null=True, blank=True)
    foto = models.ImageField(upload_to='perfil', null=True, blank=True)
    fotoBg = models.ImageField(upload_to='perfil/Bg', null=True, blank=True)

    fecha_nacimiento = models.DateField(null=True, blank=True)
    sexo = models.CharField(max_length=1, choices=SEXO, null=True, blank=True)
    favoritos = models.ManyToManyField("receta.Receta",related_name="favoritos_usuarios")
    categoriasSemana = models.ManyToManyField("receta.Categoria", blank=True, related_name="dieta_semanal")

    #invitacion = models.CharField(max_length=15, null=True, blank=True)