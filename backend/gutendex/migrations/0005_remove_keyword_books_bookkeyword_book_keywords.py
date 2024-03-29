# Generated by Django 4.2.10 on 2024-02-28 17:42

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('gutendex', '0004_alter_keyword_word'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='keyword',
            name='books',
        ),
        migrations.CreateModel(
            name='BookKeyword',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('occurrences', models.IntegerField(default=0)),
                ('repetition_percentage', models.FloatField(default=0.0)),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='gutendex.book')),
                ('keyword', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='gutendex.keyword')),
            ],
        ),
        migrations.AddField(
            model_name='book',
            name='keywords',
            field=models.ManyToManyField(related_name='books', through='gutendex.BookKeyword', to='gutendex.keyword'),
        ),
    ]
