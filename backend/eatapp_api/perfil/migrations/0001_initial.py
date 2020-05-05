# Generated by Django 3.0.4 on 2020-04-28 08:18

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('receta', '0003_auto_20200424_0802'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Perfil',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('activo', models.BooleanField(default=True)),
                ('nombre', models.CharField(max_length=100)),
                ('foto', models.ImageField(blank=True, null=True, upload_to='perfil')),
                ('fecha_nacimiento', models.DateField(blank=True, null=True)),
                ('sexo', models.CharField(blank=True, choices=[('m', 'Mujer'), ('h', 'Hombre'), ('x', 'Otros')], max_length=1, null=True)),
                ('invitacion', models.CharField(blank=True, max_length=15, null=True)),
                ('permiso_staff', models.BooleanField(default=False)),
                ('permiso_tickets', models.BooleanField(default=False)),
                ('permiso_escanear', models.BooleanField(default=False)),
                ('favoritos', models.ManyToManyField(blank=True, related_name='favoritos_usuarios', to='receta.Receta')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]