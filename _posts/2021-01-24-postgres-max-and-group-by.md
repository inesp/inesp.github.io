---
title: "Postgres: How to select additional columns when using <code>GROUP BY</code> together with <code>MAX</code>/<code>MIN</code>"
biblio:
---


Very recently I stumbled on an sleek and simple solution to a very minor, but very annoying problem that I occasionally bump into with PostgreSQL. Admittedly, a perfectly adequate solution already exists for this problem and Postgres's limitations of the `GROUP BY`-logic, which are causing this problem make perfect sense to me and I support them fully. *But* (and doesn't every rule always trigger a *but can you make an exception this time*), I never liked that solution. I think we can do better. I think we should do better. So, let me show you the problem.

## How to select additional columns when using GROUP BY together with MAX/MIN

(For the purposes of this story, ) I am a wildlife researcher and I count how many animals live where. I also have a small Postgres table, where I record the number of animals I've counted. Here it is:

| animal_id | num_of_animals | area |
|-----------|----------------|------|
| 1         | 120            | A    |
| 1         | 80             | B    |
| 1         | 10             | C    |
| 2         | 50             | A    |
| ...       | ...            | ...  |
{:.table .table-sm}

And now somebody asks me: **"For every animal, can you tell me which area they prefer?"**.

Ok, I can do it. I need to `GROUP BY animal_id` and call `MAX(num_of_animals)`:

```PostgreSQL
select
	animal_id,
	MAX(num_of_animals) as max_num
from
	animals
group by
	animal_id
```

But how do I get the area? How do I get the value of the area column, in the same row as the `MAX(...)` is found?

I can't just add `, area_code` to the list of `SELECT` columns, because I will get the error: `column "animals.area_code" must appear in the GROUP BY clause or be used in an aggregate function`. And this makes sense, but I also cannot use any of the aggregate functions, I don't want to know the `MAX(area_code)`, nor the `COUNT(area_code)`, but there is no aggregate function doing `SAME_ROW_VALUE(area_code, column=max_num)`.


### One of the standard solutions

One of the standard solutions is to use a subquery: we `INNER JOIN` the 1st query with the `animals` table to identify the rows where the `animal_id` and `max_num` match:

```PostgreSQL
select
	animals.animal_id,
	max_num,
	area_code
from
	animals
inner join (
	select
		animal_id,
		MAX(num_of_animals) as max_num
	from
		animals
	group by
		animal_id) as max_num_of_animals
  on
	  animals.animal_id = max_num_of_animals.animal_id
	  and animals.num_of_animals = max_num_of_animals.max_num
```

But to me this is wasteful. We already know which row produced the `max_num` value, but we cannot use this information to fetch the `area_code` as well. And reading this query is arduous. Even if I am its author, I can't simply glance at it and know what it wants to achieve. Long SQL statements are much easier to write than to read.

On top of it all, I am 100% sure this pattern is fairly common. Every once a year or two, I have to deal with it. I am also 100% sure I will come across this same problem again in a year or two. This just seems to be an undying pattern.


### My favorite solution

Here is the solution I like better. I'd like to emphasize I am not the author of the idea, I am just spreading the word. I found this solution in a StackOverflow post, but I don't know which one and I've just spent half an hour searching StackOverflow for it.

So, here is my favorite solution.

```PostgreSQL
select
	animal_id,
	MAX(num_of_animals),
	SUBSTRING(MAX(CONCAT(to_char(num_of_animals, '0000000000'), area_code)), 12) AS "area_code"
from
	animals
group by
	animal_id
```

I know, that additional `SUBSTRING(MAX.....` demands some explanation. 😁

1. `to_char(num_of_animals, '0000000000')`: we turn `num_of_animals` into a string with zeros at the begining like so: `0000000120`, `0000000080`, ..
   The string `0000000000` must have as many zeros as the biggest `num_of_animals` can have digits.
2. `CONCAT(..., area_code)`: we append the area_code to the back like so: `0000000120A`, `0000000080B`, ...
3. `MAX(..)`: we find the maximum values of these strings. Because the strings start with `num_of_animals`, their MAX will be the same as the MAX of `num_of_animals`.
4. `SUBSTRING(..)`: we strip away zeros and the `num_of_values` to get only the `area_code`: `SUBSTRING(0000000120A, 12) => A`. ATTENTION: `to_char` creates white space at the beginning of the string, so we have to substract 12 chars, not just 10.

I personally, like this approach, but be careful when using it on your database. It might not work for you as well as it did for me. It all depends on the size of your table and on the data types of your columns.
