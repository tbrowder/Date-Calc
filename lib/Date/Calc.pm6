unit module Date::Calc;

=begin comment

# From the original Perl 5 Date::Calc module on CPAN:

Important notes:

First index

  ALL ranges in this module start with "1", NOT "0"!

  I.e., the day of month, day of week, day of year, month of year,
  week of year, first valid year number and language ALL start
  counting at one, NOT zero!

  The only exception is the function "Week_Number()", which may in
  fact return "0" when the given date actually lies in the last week
  of the PREVIOUS year, and of course the numbers for hours (0..23),
  minutes (0..59) and seconds (0..59).

Function naming conventions

  Function names completely in lower case indicate a boolean return
  value.

Boolean values

  Boolean values returned from functions in this module are always a
  numeric zero ("0") for "false" and a numeric one ("1") for "true".

Exception handling

  The functions in this module will usually die with a corresponding
  error message if their input parameters, intermediate results or
  output values are out of range.

  The following functions handle errors differently:

    -  check_date()
    -  check_time()
    -  check_business_date()
    -  check_compressed()

    (which return a "false" return value when the given input does not
    represent a valid date or time),

    -  Nth_Weekday_of_Month_Year()

    (which returns an empty list if the requested 5th day of week does not exist),

    -  Decode_Month()
    -  Decode_Day_of_Week()
    -  Decode_Language()
    -  Fixed_Window()
    -  Moving_Window()
    -  Compress()

    (which return "0" upon failure or invalid input), and

    -  Decode_Date_EU()
    -  Decode_Date_US()
    -  Decode_Date_EU2()
    -  Decode_Date_US2()
    -  Parse_Date()
    -  Uncompress()

    (which return an empty list upon failure or invalid input).

  Note that you can always catch an exception thrown by any of the
  functions in this module and handle it yourself by enclosing the
  function call in an "eval" with curly brackets and checking the
  special variable "$@" (see "eval" in perlfunc(1) for details).


=end comment

my $debug = 0;
sub month-to-mm($mon is copy) is export(:WALL :month-to-mm) {
    if 0 && $debug {
        say "DEBUG: month in '$mon'";
    }
    # takes first three letters and make lower-case
    $mon = $mon.comb[0..2].join.lc;
    my $mm = '00';
    given $mon {
        when 'jan' { $mm = '01' }
        when 'feb' { $mm = '02' }
        when 'mar' { $mm = '03' }
        when 'apr' { $mm = '04' }
        when 'may' { $mm = '05' }
        when 'jun' { $mm = '06' }
        when 'jul' { $mm = '07' }
        when 'aug' { $mm = '08' }
        when 'sep' { $mm = '09' }
        when 'oct' { $mm = '10' }
        when 'nov' { $mm = '11' }
        when 'dec' { $mm = '12' }
    }
    if 0 && $debug {
        say "       month in '$mon', month out '$mm'";
    }
    return $mm;
}

#|(

This function serves to add a days, hours, minutes and seconds offset
to a given date and time in order to answer questions like "today and
now plus 7 days but minus 5 hours and then plus 30 minutes, what date
and time gives that?":

  ($y,$m,$d,$H,$M,$S) = Add_Delta_DHMS(Today_and_Now(), +7,-5,+30,0);

)
sub Add_Delta_DHMS($year, $month, $day,
                   $hour, $min, $sec,
                   $Dd, $Dh, $Dm, $Ds) is export(:WALL :Add_Delta_DHMS) {

    # implicit return
    $year, $month, $day, $hour, $min, $sec;
}


#|(

This function has two principal uses:

First, it can be used to calculate a new date, given an initial date
and an offset (which may be positive or negative) in days, in order to
answer questions like "today plus 90 days -- which date gives that?".

(In order to add a weeks offset, simply multiply the weeks offset with
"7" and use that as your days offset.)

Second, it can be used to convert the canonical representation of a
date, i.e., the number of that day (where counting starts at the 1st
of January in 1 A.D.), back into a date given as year, month and day.

Because counting starts at "1", you will actually have to subtract "1"
from the canonical date in order to get back the original date:

  $canonical = Date_to_Days($year,$month,$day);

  ($year,$month,$day) = Add_Delta_Days(1,1,1, $canonical - 1);

Moreover, this function is the inverse of the function "Delta_Days()":

  Add_Delta_Days(@date1, Delta_Days(@date1, @date2))

yields "@date2" again, whereas

  Add_Delta_Days(@date2, -Delta_Days(@date1, @date2))

yields "@date1", and

  Delta_Days(@date1, Add_Delta_Days(@date1, $delta))

yields "$delta" again.

)

sub Add_Delta_Days($year, $month, $day, $Dd) is export(:WALL :Add_Delta_Days) {

    # implicit return
    $year, $month, $day;
}


#|(

This function returns the (absolute) number of the day of the given
date, where counting starts at the 1st of January of the year 1 A.D.

I.e., "Date_to_Days(1,1,1)" returns "1", "Date_to_Days(1,12,31)"
returns "365", "Date_to_Days(2,1,1)" returns "366",
"Date_to_Days(1998,5,1)" returns "729510", and so on.

This is sometimes also referred to (not quite correctly) as the Julian
date (or day). This may cause confusion, because also the number of
the day in a year (from 1 to 365 or 366) is frequently called the
"Julian day".

More confusing still, this has nothing to do with the Julian calendar,
which was used BEFORE the Gregorian calendar.

The Julian calendar was named after famous Julius Caesar, who had
instituted it in Roman times. The Julian calendar is less precise than
the Gregorian calendar because it has too many leap years compared to
the true mean length of a year (but the Gregorian calendar also still
has one day too much every 5000 years). Anyway, the Julian calendar
was better than what existed before, because rulers had often changed
the calendar used until then in arbitrary ways, in order to lengthen
their own reign, for instance.

In order to convert the number returned by this function back into a
date, use the function "Add_Delta_Days()" (described further below),
as follows:

  $days = Date_to_Days($year,$month,$day);
  ($year,$month,$day) = Add_Delta_Days(1,1,1, $days - 1);

)
sub Date_to_Days($year, $month, $day) is export(:WALL :Date_to_Days) {

    # implicit return
    my $days; # days counting from 1 AD to input day
}

#|(

This function returns the number of the day of week of the given date.

The function returns "1" for Monday, "2" for Tuesday and so on until
"7" for Sunday.

Note that in the Hebrew calendar (on which the Christian calendar is
based), the week starts with Sunday and ends with the Sabbath or
Saturday (where according to the Genesis (as described in the Bible)
the Lord rested from creating the world).

In medieval times, Catholic Popes have decreed the Sunday to be the
official day of rest, in order to dissociate the Christian from the
Hebrew belief.

It appears that this actually happened with the Emperor Constantin,
who converted to Christianity but still worshipped the Sun god and
therefore moved the Christian sabbath to the day of the Sun.

Nowadays, the Sunday AND the Saturday are commonly considered (and
used as) days of rest, usually referred to as the "week-end".

Consistent with this practice, current norms and standards (such as
ISO/R 2015-1971, DIN 1355 and ISO 8601) define the Monday as the first
day of the week.

)
sub Day_of_Week($year, $month, $day) is export(:WALL :Day_of_Week) {

    # implicit return
    my $dow; # day of week counting from Sunday = 1
}

#|(

This function returns the (relative) number of the day of the given
date in the given year.

E.g., "Day_of_Year($year,1,1)" returns "1", "Day_of_Year($year,2,1)"
returns "32", and "Day_of_Year($year,12,31)" returns either "365" or
"366".

The day of year is sometimes also referred to as the Julian day (or
date), although it has nothing to do with the Julian calendar, the
calendar which was used before the Gregorian calendar.

In order to convert the number returned by this function back into a
date, use the function "Add_Delta_Days()" (described further below),
as follows:

  $doy = Day_of_Year($year,$month,$day);
  ($year,$month,$day) = Add_Delta_Days($year,1,1, $doy - 1);

)
sub Day_of_Year($year, $month, $day) is export(:WALL :Day_of_Year) {

    # implicit return
    my $doy; # day of year counting from 1 January = 1
}


#|(

This function returns the sum of the number of days in the months
starting with January up to and including "$month" in the given year
"$year".

I.e., "Days_in_Year(1998,1)" returns "31", "Days_in_Year(1998,2)"
returns "59", "Days_in_Year(1998,3)" returns "90", and so on.

Note that "Days_in_Year($year,12)" returns the number of days in the
given year "$year", i.e., either "365" or "366".

)
sub Days_in_Year($year, $month) is export(:WALL :Days_in_Year) {

    # implicit return
    my $days; # days in year from 1 January through end of $month
}


#|(

)
sub This_Year($Gmt?) is export(:WALL :This_Year) {

    # implicit return
    # current year in the local timezone
    my $year;
}

#|(

)
sub Timezone($Time?) is export(:WALL :Timezone) {

    # implicit return
    # local time zone
    my $tz;
}

#|(

This function takes a string as its argument, which should contain the
name of a month in the given or currently selected language (see
further below for details about the multi-language support of this
package), or any uniquely identifying abbreviation of a month's name
(i.e., the first few letters), and returns the corresponding number
(1..12) upon a successful match, or "C<0>" otherwise (therefore, the
return value can also be used as the conditional expression in an "if"
statement).

Note that the input string may not contain any other characters which
do not pertain to the month's name, especially no leading or trailing
whitespace.

Note also that matching is performed in a case-insensitive manner
(this may depend on the "locale" setting on your current system,
though!)

With "1" ("English") as the given language, the following examples
will all return the value "C<9>":

  $month = Decode_Month("s",1);
  $month = Decode_Month("Sep",1);
  $month = Decode_Month("septemb",1);
  $month = Decode_Month("September",1);

)

sub Decode_Month($string) is export(:WALL :Decode_Month) {

    # implicit return
    my $dow;
}

=finish

# all below here not needed for my current calendar

#|(

This function returns the number of days in the given month "$month"
of the given year "$year".

The year must always be supplied, even though it is only needed when
the month is February, in order to determine whether it is a leap year
or not.

I.e., "Days_in_Month(1998,1)" returns "31", "Days_in_Month(1998,2)"
returns "28", "Days_in_Month(2000,2)" returns "29",
"Days_in_Month(1998,3)" returns "31", and so on.

)
sub Days_in_Month($year, $month) {


    # implicit return
    $days;
}

#|(

This function returns the number of weeks in the given year "$year",
i.e., either "52" or "53".

)
sub Weeks_in_Year($year) {


    # implicit return
    $weeks;
}

#|(

This function returns the number of the week the given date lies in.

If the given date lies in the LAST week of the PREVIOUS year, "0" is
returned.

If the given date lies in the FIRST week of the NEXT year,
"Weeks_in_Year($year) + 1" is returned.

)
sub Week_Number($year,$month,$day) {

    # implicit return
    $week;
}

#|(

This function returns the number of the week the given date lies in,
as well as the year that week belongs to.

I.e., if the given date lies in the LAST week of the PREVIOUS year,
"(Weeks_in_Year($year-1), $year-1)" is returned.

If the given date lies in the FIRST week of the NEXT year, "(1,
$year+1)" is returned.

Otherwise, "(Week_Number($year,$month,$day), $year)" is returned.

NOTE: THE ORIGINAL HAS ANOTHER FUNCTION WITH SAME SIGNATURE BUT
      ONLY RETURNS THE WEEK--DANGEROUS, DO NOT DUPLICATE???
)
Week_of_Year($year, $month, $day) {

    # implicit return
    $week, $year;
}

#|(

This function returns the date of the first day of the given week,
i.e., the Monday.

"$year" must be greater than or equal to "1", and "$week" must lie in
the range "1" to "Weeks_in_Year($year)".

Note that you can write "($year,$month,$day) =
Monday_of_Week(Week_of_Year($year,$month,$day));" in order to
calculate the date of the Monday of the same week as the given date.

If you want to calculate any other day of week in the same week as a
given date, use

  @date = Add_Delta_Days(Monday_of_Week(Week_of_Year(@date)),$offset);

where $offset = 1 for Tuesday, 2 for Wednesday etc.

)
sub Monday_of_Week($week, $year) {

    # implicit return
    $year, $month, $day;
}

#|(

This function calculates the date of the "$n"th day of week "$dow" in
the given month "$month" and year "$year"; such as, for example, the
3rd Thursday of a given month and year.

This can be used to send a notification mail to the members of a group
which meets regularly on every 3rd Thursday of a month, for instance.

(See the section "RECIPES" near the end of this document for a code
snippet to actually do so.)

"$year" must be greater than or equal to "1", "$month" must lie in the
range "1" to "12", "$dow" must lie in the range "1" to "7" and "$n"
must lie in the range "1" to "5", or a fatal error (with appropriate
error message) occurs.

The function returns an empty list when the 5th of a given day of week
does not exist in the given month and year.

)
sub Nth_Weekday_of_Month_Year($year, $month, $dow, $n) {

    # implicit return
    $year, $month, $day;
}

=finish

Add these functions later

if (leap_year($year))

This function returns "true" ("1") if the given year "$year" is a leap
year and "false" ("0") otherwise.

if (check_date($year,$month,$day))

This function returns "true" ("1") if the given three numerical values
"$year", "$month" and "$day" constitute a valid date, and "false"
("0") otherwise.

if (check_time($hour,$min,$sec))

This function returns "true" ("1") if the given three numerical values "$hour", "$min" and "$sec" constitute a valid time (0 <= $hour < 24, 0 <= $min < 60 and 0 <= $sec < 60), and "false" ("0") otherwise.

if (check_business_date($year,$week,$dow))

This function returns "true" ("1") if the given three numerical values "$year", "$week" and "$dow" constitute a valid date in business format, and "false" ("0") otherwise.

Beware that this function does NOT compute whether a given date is a business day (i.e., Monday to Friday)!

To do so, use "(Day_of_Week($year,$month,$day) < 6)" instead.
