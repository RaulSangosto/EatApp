from django.db import models

# Create your models here.
class Receta(models.Model):
    titulo = models.CharField(blank=True, null=True, max_length=100)
    imagen = models.ImageField(blank=True, null=True, upload_to="imagenes/recetas")
    minutos_preparacion = models.SmallIntegerField(blank=True, null=True)
    kcal = models.SmallIntegerField(blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    ingredientes = models.ManyToManyField("Ingrediente")
    categorias = models.ManyToManyField("Categoria")

    def __str__(self):
        return self.titulo


class Ingrediente(models.Model):
    nombre = models.CharField(blank=True, null=True, max_length=100)
    alergeno = models.ForeignKey("Alergeno", on_delete=models.CASCADE)

    def __str__(self):
        return self.nombre


class Alergeno(models.Model):
    nombre = models.CharField(blank=True, null=True, max_length=100)
    icono = models.ImageField(blank=True, null=True, upload_to="imagenes/alergenos")

    def __str__(self):
        return self.nombre


class Categoria(models.Model):
    titulo = models.CharField(blank=True, null=True, max_length=100)
    imagen = models.ImageField(blank=True, null=True, upload_to="imagenes/categorias")
    descripcion = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.titulo

