from functools import partial
import re
from gutendex.models import Book, BookKeyword, JaccardIndex, Keyword
from django.db.models import Q
import nltk
from django.core.paginator import Paginator


nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')
page_size = 32
stop_words = set(nltk.corpus.stopwords.words('english'))
stemmer = nltk.stem.SnowballStemmer('english')
invalid_chars = ['-', '"', '\'', '’', '“', '”', '‘', '—', '–', '…']


def get_pagefrom_request(request):
    if 'page' in request.GET and request.GET['page'].isdigit():
        page = int(request.GET['page'])
        if page < 1:
            page = 1
        return page
    return 1


def get_requested_page(request, queryset):
    page = get_pagefrom_request(request)
    return get_page(page, queryset)


def get_page(page, queryset):
    paginator = Paginator(queryset, page_size)
    if paginator.num_pages < page:
        return []
    return paginator.get_page(page)


def can_tokenize(s):
    # Regular expression to match letters, numbers, and space
    pattern = r'^[a-zA-Z0-9\s]*$'
    # Match the pattern against the string
    return re.match(pattern, s) is not None


def raw_tokenize(sentence):
    tokens = nltk.word_tokenize(sentence)
    tokens = [stemmer.stem(word.lower()) for word in tokens if word.isalpha()
              and word.lower() not in stop_words]
    """ Remove duplicates """
    return list(set(tokens))


def get_token(sentence):
    sentence = ''.join([c for c in sentence if c not in invalid_chars])
    if can_tokenize(sentence):
        tokens = raw_tokenize(sentence)
        if len(tokens) > 0:
            return tokens
    return None


def search_tokens_perfect_match(tokens):
    queryset = Book.objects.all()
    titlebooks = Book.objects.all()
    for token in tokens:
        queryset = queryset.filter(keywords__word=token)
        titlebooks = titlebooks.filter(title__icontains=token)

    partial_apply = partial(calculate_score, tokens)
    titlebooks = titlebooks.exclude(pk__in=[b.pk for b in queryset])
    queryset = sorted(titlebooks, key=partial_apply, reverse=True) + \
        sorted(queryset, key=partial_apply, reverse=True)
    return queryset


def search_token_quick_match(tokens):
    result = Book.objects.filter(keywords__word__in=tokens)
    query = Q()
    for token in tokens:
        query |= Q(title__icontains=token)
    title_match = Book.objects.filter(query)

    print(f'Queryset count: {len(result)}')
    print(f'Title match count: {title_match.query}')
    partial_apply = partial(calculate_score, tokens)
    sorted_books = sorted(result, key=partial_apply, reverse=True)
    sorted_title_books = sorted(title_match, key=partial_apply, reverse=True)
    result = sorted_title_books + sorted_books
    return result


def search_token(tokens):
    if len(tokens) == 0:
        return list(Book.objects.all())
    print(f'Querying for {tokens}')
    result = search_tokens_perfect_match(tokens)
    if len(result) == 0:
        print('No perfect match')
        print('Querying for quick match')
        return search_token_quick_match(tokens)
    return result


def search_regex(regex, page):
    """ Check regex validity"""
    try:
        re.compile(regex)
    except re.error:
        return None
    print(f'Querying regex : {regex}')
    result = Book.objects.filter(title__iregex=regex)
    title_not_matching_books = Book.objects.all().difference(result).iterator()
    regex = regex.lower()
    result = list(result)
    if Keyword.objects.filter(word__iregex=regex).exists():
        while len(result) < page * page_size:
            try:
                b = next(title_not_matching_books)
                if b.keywords.filter(word__iregex=regex).exists():
                    result.append(b)

            except StopIteration:
                break
            except Keyword.DoesNotExist:
                pass
    result = sorted(result, key=lambda x: x.betweenness_centrality, reverse=True)
    return result


def calculate_score(tokens, book):
    average_tf = 0
    average_idf = 0
    for token in tokens:
        try:
            word = Keyword.objects.get(word=token)
            idf = word.idf
            tf = BookKeyword.objects.filter(book=book).get(keyword=word).repetition_percentage
            average_tf += tf
            average_idf += idf
        except (BookKeyword.DoesNotExist, Keyword.DoesNotExist):
            pass

    tokenlen = len(tokens)
    average_idf = average_idf / tokenlen
    average_tf = average_tf / tokenlen
    average_tf = 0.7 * average_tf * average_idf
    closeness_score = 0.15 * book.closeness_centrality
    betweenness_score = 0.15 * book.betweenness_centrality
    return average_tf + closeness_score + betweenness_score


def get_threasold_for_ls(query_set, percentage=0.3):

    def get_index(jaccard):
        if isinstance(jaccard, float):
            return jaccard
        return jaccard.index

    average = sum([get_index(jaccard) for jaccard in query_set]) / len(query_set)
    output = average + (average * percentage)
    if output > 1:
        return 1
    return output


def get_threasold_for_graph(percentage=0.3):
    return get_threasold_for_ls(JaccardIndex.objects.all(), percentage)
