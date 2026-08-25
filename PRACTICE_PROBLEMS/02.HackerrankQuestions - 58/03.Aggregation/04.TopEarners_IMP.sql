Find the maximum total earnings of any employee, where:
total earnings = months * salary.

Also find how many employees have that maximum total earnings.
Output should be two integers separated by spaces

Original Employee Table:
    +--------+--------+--------+
    | name   | months | salary |
    +--------+--------+--------+
    | Alice  | 10     | 5000   |
    | Bob    | 12     | 6000   |
    | Carol  | 12     | 6000   |
    +--------+--------+--------+

Derived Employee Earnings Table:
    +--------+--------+--------+----------------+
    | name   | months | salary | total_earnings |
    +--------+--------+--------+----------------+
    | Alice  | 10     | 5000   | 50000          |
    | Bob    | 12     | 6000   | 72000          |
    | Carol  | 12     | 6000   | 72000          |
    +--------+--------+--------+----------------+

Maximum earnings = 72000
Employees with maximum earnings = 2

Output:
    72000 2

QUERY:

    SELECT MAX(salary * months), COUNT(*)
    FROM Employee
    WHERE salary * months = (
        SELECT MAX(salary * months) FROM Employee
    );