# About

These are the scripts I (Jerry) used to dig through data. Mainly `process.sh` and `tcp2.pl`.

I mainly focused around a scenario where busy resolvers kept TCP session opened for a very long while.

# Conclusion

> Are long-lived TCP sessions a problem for (DNS) statistics?

Nope!

> Why?

Because well-behaved clients wouldn't need to keep sessions open for long.

# Methods used

- used tcpdump on DITL data to get "tcp port 53" packets
- check if seq > 1000, not interested in sessions with few queries
- count by source+port
- output if more then 10 "queries" where seq > 1000

Scanned various DITL data from 2022 and 2023, only found ONE "client" that had sessions longer than a few mins.

By "client" I mean a number of same range IP addresses with similar query pattern. And based on query pattern it looks like a scanner.

# Other Finds

A lot of broken or malicious TCP, cache poisoning attempts and domain scanners... oh so many scanners!

