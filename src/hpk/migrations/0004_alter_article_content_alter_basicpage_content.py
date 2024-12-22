# Generated by Django 5.1.4 on 2024-12-19 22:23

import wagtail.fields
from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("hpk", "0003_alter_article_content_alter_basicpage_content"),
    ]

    operations = [
        migrations.AlterField(
            model_name="article",
            name="content",
            field=wagtail.fields.StreamField(
                [("section", 5), ("code", 8), ("image", 3)],
                blank=True,
                block_lookup={
                    0: (
                        "wagtail.blocks.CharBlock",
                        (),
                        {
                            "help_text": 'Heading for this section, included in "page contents".',
                            "required": True,
                        },
                    ),
                    1: (
                        "wagtail.blocks.IntegerBlock",
                        (),
                        {
                            "help_text": "Heading level",
                            "max_value": 6,
                            "min_value": 1,
                            "required": True,
                        },
                    ),
                    2: (
                        "wagtail.blocks.RichTextBlock",
                        (),
                        {"features": ["bold", "italic", "link", "ul", "ol", "document-link"]},
                    ),
                    3: ("wagtail.images.blocks.ImageChooserBlock", (), {}),
                    4: (
                        "wagtail.blocks.StreamBlock",
                        [[("rich_text", 2), ("image", 3)]],
                        {"help_text": None, "required": False},
                    ),
                    5: (
                        "wagtail.blocks.StructBlock",
                        [[("heading", 0), ("level", 1), ("content", 4)]],
                        {},
                    ),
                    6: ("wagtail.blocks.TextBlock", (), {"help_text": None, "required": True}),
                    7: (
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
                    8: ("wagtail.blocks.StructBlock", [[("code", 6), ("language", 7)]], {}),
                },
                help_text="Main content for the article.",
            ),
        ),
        migrations.AlterField(
            model_name="basicpage",
            name="content",
            field=wagtail.fields.StreamField(
                [("rich_text", 0), ("code", 3), ("image", 4)],
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
                help_text="Main content for the page.",
            ),
        ),
    ]
