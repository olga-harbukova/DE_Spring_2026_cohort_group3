# Задание 7.10: dbt проект для анализа смартфонов

## Описание
Разработан dbt-проект для анализа данных о смартфонах.

## Структура проекта
- `hw1/` — dbt-проект
  - `models/` — модели данных
  - `seeds/` — исходные CSV-данные

## Модели данных
1. `stg_smartphones` (view) — основные характеристики
2. `int_smartphones_brands` (table) — бренды
3. `int_smartphones_combination` (table) — комбинации
4. `mart_top_combinations` (table) — топ-10 комбинаций
5. `mart_top_processors` (table) — топ-10 процессоров

## Результаты
- Загружено 980 записей
- Создано 5 моделей в схеме `smartphones`