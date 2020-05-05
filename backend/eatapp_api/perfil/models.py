from django.db import models
from django.contrib.auth.models import User
from easy_thumbnails.files import get_thumbnailer


SEXO = (('m', 'Mujer'), ('h', 'Hombre'), ('x', 'Otros'))


# Create your models here.
class Perfil(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    activo = models.BooleanField(default=True)
    nombre = models.CharField(max_length=100)
    foto = models.ImageField(upload_to='perfil', null=True, blank=True)

    fecha_nacimiento = models.DateField(null=True, blank=True)
    sexo = models.CharField(max_length=1, choices=SEXO, null=True, blank=True)
    favoritos = models.ManyToManyField("receta.Receta", blank=True,
                                       related_name="favoritos_usuarios")

    #invitacion = models.CharField(max_length=15, null=True, blank=True)

    def avatar(self, alias="avatar"):
        if self.foto:
            thumbnailer = get_thumbnailer(self.foto)
            return thumbnailer[alias].url