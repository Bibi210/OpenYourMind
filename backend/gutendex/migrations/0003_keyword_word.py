# Generated by Django 5.0.2 on 2024-02-28 16:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gutendex', '0002_alter_book_id_keyword'),
    ]

    operations = [
        migrations.AddField(
            model_name='keyword',
            name='word',
            field=models.CharField(max_length=255, null='True'),
            preserve_default='True',
        ),
    ]