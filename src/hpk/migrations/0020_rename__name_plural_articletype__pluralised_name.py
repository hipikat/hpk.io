# Generated by Django 5.1.5 on 2025-01-18 01:34

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hpk', '0019_rename_name_plural_articletype__name_plural'),
    ]

    operations = [
        migrations.RenameField(
            model_name='articletype',
            old_name='_name_plural',
            new_name='_Pluralised_name',
        ),
    ]
