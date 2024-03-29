# Generated by Django 5.0.2 on 2024-03-07 11:35

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gutendex', '0008_alter_keyword_word'),
    ]

    operations = [
        migrations.CreateModel(
            name='JaccardIndex',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('index', models.FloatField(default=0.0)),
                ('book1', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='book1', to='gutendex.book')),
                ('book2', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='book2', to='gutendex.book')),
            ],
        ),
    ]
