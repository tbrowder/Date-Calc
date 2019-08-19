# Date::Calc

## A Raku (aka Perl 6) port of Perl's module `Date::Calc`

This is currently a partial implementation of `Date::Calc`. Currently usable
functions are listed below.  Submit an issue if there is a `Date::Calc`
function you want added to the list.

Implemented functions are available with two naming systems: (1) named
as in the original module and (2) named in Raku's kebab case (with all
letters after the first in lower case and underscores changed to
hyphens). For example, `Days_in_Year` will also be available as
`Days-in-year`.  (The case of the first letter is preserved to satisfy
the convention in the original Date::Calc that functions with
lower-case first letters in their names return Boolean values.)

For complete details of the module's contents, see the documentation
on the CPAN site for
[Date::Calc](https://metacpan.org/pod/distribution/Date-Calc/lib/Date/Calc.pod).

## Available `Date::Calc` functions

| Usual name | Kebab name | Notes |
| :---        | :--- | :--- |
| Add_Delta_DHMS | Add-delta-dhms | |
| Day_of_Year | Day-of-year | |
| Decode_Month | Decode-month | English only |

## Other functions available

+ month-to-mm - same as `Decode_month` except numbers are formatted to two-digit strings, e.g., `01`..`12`

# LICENSE

Artistic-2.0

# COPYRIGHT
