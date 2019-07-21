# Truss Normalizer

## Usage

In this repo, make `normalizer` an executable file with
`chmod +x normalizer`. Then you can run it by piping a file
into `STDIN`, like so:

```
./normalizer < sample.csv > output.csv
```

The requirements didn't specify error handling, but I put in some graceful
responses:
 
* If you don't pass it a file into STDIN, it writes a message to STDERR 
  and exits.
* If you pass in a file that isn't a CSV, either by causing a CSV parse
  error, or if the header doesn't match the expected header, it writes
  a message to STDERR and exits.
  
The `data/output.csv` shows the result of running the `data/sample.csv`.
There are also some tests that show that result. 

## Approach and Architecture

I'm going to be a little more verbose than I normally am, because of the
nature of what this sample is going to be used for. 

I started this off by implementing the specific normalization rules in 
the bullet list (except encoding, more on that in bit). I decided to 
make each normalization with logic in it its own small class, because I
think that's the easiest way to unit test it in Ruby. You might argue
that these classes don't need to exist because they don't really manage
changing state, so I could see inlining them back into the row normalizer
if my team didn't like the extra classes. I did use a TDD process for 
writing these rules, and I brought in ActiveSupport for the TimeZone 
class there to help with the time zone logic. There are some specific
comments in some of the normalizers about other assumptions.

Once I got the individual normalizations written, I wrote tests for the
entire row normalization, and then then entire CSV file, and then the
acceptance tests for the CLI access (please enjoy the sample gif for that
test, from something that happened to me at a conference a couple of years
ago). Then I went back and added in some error handling tests to the 
CSV and CLI files. The  normalizer essentially hardcodes the order of 
the columns and the relationship between the columns and their individual 
rules -- the requirements didn't say anything about allowing for those 
to change, so making those more flexible seemed best saved for when 
that might be needed.

## Encoding

I'm not sure I did the encoding as specified. I think I might have done
the letter of the requirement and not the spirit. The requirement to 
strip all non UTF-8 characters is done by the CSV normalizer when it
gets the string from the CLI and it uses Ruby's `encode` method. The
method does catch one or two characters in the broken utf-8 sample, but
not all of them. What this code does seems to be exactly what you get if
you view that sample file, not in the GitHub CSV table, but raw in 
browser, where a lot of the characters do resolve. So, I think this is
replacing invalid UTF-8 characters for Ruby's definition of invalid, but
I don't think it's quite catching the encoding problems in the sample
file. This would be a good time in a normal project to go back to the 
product owner and talk about what the actual business requirement is
and how to best achieve it.

