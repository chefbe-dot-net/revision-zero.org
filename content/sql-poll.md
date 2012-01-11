--- 
title: A quick SQL poll
short: Quick SQL poll
date: 2011-02-25 19:59:00 +01:00
category: Databases
---
Today's writing is really short and is a poll. So please use the comment feature to answer it. Let consider the tables below for a relational schema about people owning pictures (I suppose that a BLOB column could hold the picture, but this is not important here):

![](images/sql-poll/model.gif)

Now, consider the following SQL query that returns the whole <code>people</code> info as well as the number of <code>pictures</code> each of them has in the database:

#<{sql}{
SELECT id, 
       email,
       name,
       (SELECT count(*) 
          FROM pictures
          WHERE pictures.owner = people.id) as nb_picts
  FROM people
}

Here is the poll. How do you feel?

1. Exactly what you'd have written
1. You prefer to use a GROUP BY
1. It's probably correct, but you're not sure 
1. You would never write such a query, it's certainly inefficient
1. The query is incorrect, not allowed in SQL
1. Other (please explain)

Post your response as a 1-6 number using the comment feature below (there is no particular trap). 

Thanks!