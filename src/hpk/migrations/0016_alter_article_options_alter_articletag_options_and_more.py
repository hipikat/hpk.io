# Generated by Django 5.1.4 on 2025-01-09 00:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hpk', '0015_alter_article_options_article_tagline_and_more'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='article',
            options={},
        ),
        migrations.AlterModelOptions(
            name='articletag',
            options={},
        ),
        migrations.AlterModelOptions(
            name='basicpage',
            options={},
        ),
        migrations.AlterModelOptions(
            name='postgrouppage',
            options={'verbose_name': 'post listing', 'verbose_name_plural': 'post listings'},
        ),
        migrations.AlterModelOptions(
            name='splitviewpage',
            options={'verbose_name': 'split-view page', 'verbose_name_plural': 'split-view pages'},
        ),
    ]