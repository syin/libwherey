# Generated by Django 3.1 on 2021-04-04 01:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0004_auto_20210403_2350'),
    ]

    operations = [
        migrations.AlterField(
            model_name='library',
            name='address',
            field=models.CharField(blank=True, help_text='Text description of location', max_length=255, null=True),
        ),
    ]
