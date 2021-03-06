# Generated by Django 3.1 on 2021-04-04 18:57

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0005_auto_20210404_0117'),
    ]

    operations = [
        migrations.AddField(
            model_name='library',
            name='created',
            field=models.DateTimeField(auto_now_add=True, default=django.utils.timezone.now, verbose_name='date created'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='library',
            name='last_updated',
            field=models.DateTimeField(auto_now=True, verbose_name='date modified'),
        ),
    ]
