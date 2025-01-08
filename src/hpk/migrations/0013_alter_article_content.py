# Generated by Django 5.1.4 on 2025-01-08 07:12

import wagtail.fields
from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("hpk", "0012_alter_splitviewpage_content"),
    ]

    operations = [
        migrations.AlterField(
            model_name="article",
            name="content",
            field=wagtail.fields.StreamField(
                [("section", 0), ("code", 3), ("image", 4)],
                blank=True,
                block_lookup={
                    0: ("wagtail.blocks.RichTextBlock", (), {}),
                    1: ("wagtail.blocks.TextBlock", (), {"help_text": None, "required": True}),
                    2: (
                        "wagtail.blocks.ChoiceBlock",
                        [],
                        {
                            "choices": [
                                ("python", "Python"),
                                ("javascript", "JavaScript"),
                                ("html", "HTML"),
                                ("css", "CSS"),
                                ("bash", "Bash"),
                                ("plaintext", "Plain Text"),
                            ],
                            "required": False,
                        },
                    ),
                    3: ("wagtail.blocks.StructBlock", [[("code", 1), ("language", 2)]], {}),
                    4: ("wagtail.images.blocks.ImageChooserBlock", (), {}),
                },
                help_text="Main content for the article.",
            ),
        ),
    ]