"Find combinations of things belonging to the same entity."

Examples:

Products bought by the same customer → self join
Friends of the same person → self join
Students taking the same courses → self join
Employees working on the same projects → self join

The general template is:

FROM table a
JOIN table b
    ON a.entity_id = b.entity_id
   AND a.item_id < b.item_id

The < is especially important.

Without it:

101, 102
102, 101

are treated as two different rows.