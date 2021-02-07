# ShinyCMS developer notes

## Parallel tests

### Standard rspec run (control group!)

```bash
denny@rocinante:~/ShinyCMS$ time rspec spec/ plugins/

Randomized with seed 52385
..........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................

Finished in 2 minutes 33.8 seconds (files took 4.84 seconds to load)
538 examples, 0 failures

Randomized with seed 52385

Coverage report generated for RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4691 / 4691 LOC (100.0%) covered.

real	2m40.440s
user	2m28.679s
sys	  0m10.657s
```


### First parallel run (no timing file, so split by file size)

```
denny@rocinante:~/ShinyCMS$ time parallel_rspec spec/ plugins/
12 processes for 96 specs, ~ 8 specs per process

Randomized with seed 13262
....
Randomized with seed 17165
..
Randomized with seed 60751
....
Randomized with seed 9517

Randomized with seed 63501
.
Randomized with seed 54086
...
Randomized with seed 48152
.
Randomized with seed 32527

Randomized with seed 61827

Randomized with seed 62286

Randomized with seed 23926

Randomized with seed 63103
.......................................................................................................

Finished in 31.49 seconds (files took 15.2 seconds to load)
38 examples, 0 failures

Randomized with seed 13262

...................Coverage report generated for (1/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3292 / 4691 LOC (70.18%) covered.
.......................................................................................................................................................................................................................................

Finished in 34.29 seconds (files took 34.03 seconds to load)
40 examples, 0 failures

Randomized with seed 62286

......................................

Finished in 38.08 seconds (files took 33.51 seconds to load)
54 examples, 0 failures

Randomized with seed 61827

............Coverage report generated for (1/12), (11/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3465 / 4691 LOC (73.86%) covered.
.....

Finished in 40.16 seconds (files took 34.06 seconds to load)
40 examples, 0 failures

Randomized with seed 32527

....................Coverage report generated for (1/12), (11/12), (4/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3637 / 4691 LOC (77.53%) covered.
...............

Finished in 48.54 seconds (files took 28.75 seconds to load)
54 examples, 0 failures

Randomized with seed 17165

...

Finished in 46.07 seconds (files took 31.02 seconds to load)
53 examples, 0 failures

Randomized with seed 54086

......Coverage report generated for (1/12), (11/12), (4/12), (6/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3739 / 4691 LOC (79.71%) covered.
.....Coverage report generated for (1/12), (11/12), (3/12), (4/12), (6/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3887 / 4691 LOC (82.86%) covered.
..

Finished in 48.21 seconds (files took 31.15 seconds to load)
41 examples, 0 failures

Randomized with seed 63501

............Coverage report generated for (1/12), (10/12), (11/12), (3/12), (4/12), (6/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3978 / 4691 LOC (84.8%) covered.
.......

Finished in 47.82 seconds (files took 34.11 seconds to load)
50 examples, 0 failures

Randomized with seed 63103

.........................

Finished in 51.95 seconds (files took 30.96 seconds to load)
39 examples, 0 failures

Randomized with seed 9517

Coverage report generated for (1/12), (10/12), (11/12), (3/12), (4/12), (6/12), (7/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4064 / 4691 LOC (86.63%) covered.
.

Finished in 50.24 seconds (files took 32.73 seconds to load)
44 examples, 0 failures

Randomized with seed 48152

..Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (6/12), (7/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4162 / 4691 LOC (88.72%) covered.
Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4279 / 4691 LOC (91.22%) covered.
...........

Finished in 55.62 seconds (files took 33.74 seconds to load)
42 examples, 0 failures

Randomized with seed 23926

Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (9/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4451 / 4691 LOC (94.88%) covered.
......

Finished in 1 minute 3.23 seconds (files took 29.52 seconds to load)
43 examples, 0 failures

Randomized with seed 60751

Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4609 / 4691 LOC (98.25%) covered.
Coverage report generated for (1/12), (10/12), (11/12), (12/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12), RSpec to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4691 / 4691 LOC (100.0%) covered.

538 examples, 0 failures

Took 97 seconds (1:37)

real	1m37.330s
user	11m49.171s
sys	  0m49.106s
```


### Second parallel run - now with timing file (generated by first run)

```bash
denny@rocinante:~/ShinyCMS$ time parallel_rspec spec/ plugins/
Using recorded test runtime
12 processes for 96 specs, ~ 8 specs per process

Randomized with seed 20423

Randomized with seed 9750

Randomized with seed 54697

Randomized with seed 3923

Randomized with seed 18855

Randomized with seed 51696

Randomized with seed 63448

Randomized with seed 49136

Randomized with seed 43215

Randomized with seed 7378

Randomized with seed 3459

Randomized with seed 32959
....................................................................................................................................................................................................................................................................................................................................................................................................................................................................

Finished in 50.6 seconds (files took 16.63 seconds to load)
46 examples, 0 failures

Randomized with seed 9750

.......................

Finished in 51.3 seconds (files took 17.13 seconds to load)
48 examples, 0 failures

Randomized with seed 7378

...Coverage report generated for (4/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3072 / 4691 LOC (65.49%) covered.
...

Finished in 52.1 seconds (files took 16.72 seconds to load)
30 examples, 0 failures

Randomized with seed 3923

.....

Finished in 52.62 seconds (files took 16.88 seconds to load)
48 examples, 0 failures

Randomized with seed 18855

..

Finished in 51.97 seconds (files took 17.13 seconds to load)
55 examples, 0 failures

Randomized with seed 32959

...Coverage report generated for (4/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3253 / 4691 LOC (69.35%) covered.
........Coverage report generated for (1/12), (4/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3384 / 4691 LOC (72.14%) covered.
....Coverage report generated for (1/12), (4/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3575 / 4691 LOC (76.21%) covered.
..Coverage report generated for (1/12), (10/12), (4/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3695 / 4691 LOC (78.77%) covered.
........

Finished in 55.77 seconds (files took 16.43 seconds to load)
40 examples, 0 failures

Randomized with seed 20423

..

Finished in 55.25 seconds (files took 17.15 seconds to load)
32 examples, 0 failures

Randomized with seed 43215

..

Finished in 55.97 seconds (files took 16.71 seconds to load)
55 examples, 0 failures

Randomized with seed 63448

.........Coverage report generated for (1/12), (10/12), (2/12), (4/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3853 / 4691 LOC (82.14%) covered.
...

Finished in 57.07 seconds (files took 16.49 seconds to load)
72 examples, 0 failures

Randomized with seed 54697

Coverage report generated for (1/12), (10/12), (2/12), (4/12), (5/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3960 / 4691 LOC (84.42%) covered.
..

Finished in 57.5 seconds (files took 16.82 seconds to load)
52 examples, 0 failures

Randomized with seed 49136

.Coverage report generated for (1/12), (10/12), (11/12), (2/12), (4/12), (5/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4256 / 4691 LOC (90.73%) covered.
..Coverage report generated for (1/12), (10/12), (11/12), (2/12), (4/12), (5/12), (6/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4368 / 4691 LOC (93.11%) covered.
...

Finished in 59.11 seconds (files took 17.16 seconds to load)
35 examples, 0 failures

Randomized with seed 3459

Coverage report generated for (1/12), (10/12), (11/12), (2/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4536 / 4691 LOC (96.7%) covered.
.

Finished in 1 minute 3.35 seconds (files took 16.69 seconds to load)
25 examples, 0 failures

Randomized with seed 51696

Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4598 / 4691 LOC (98.02%) covered.
Coverage report generated for (1/12), (10/12), (11/12), (12/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4691 / 4691 LOC (100.0%) covered.

538 examples, 0 failures

Took 85 seconds (1:25)

real	1m25.847s    # <== this is the actual time taken
user	10m47.594s   # <== this is the time-per-core added up, I guess?
sys	  0m42.546s
```

**Rather a lot** of extra CPU work, to save ~75 seconds of real time! :D

Although to be fair, that is very nearly half of the standard test run time. Hrm.

Oh, hang on...


### Third parallel run - did this learn from the second one??

```bash
denny@rocinante:~/ShinyCMS$ time parallel_rspec spec/ plugins/
Using recorded test runtime
12 processes for 96 specs, ~ 8 specs per process

Randomized with seed 30974

Randomized with seed 56213

Randomized with seed 31020

Randomized with seed 63976

Randomized with seed 52859

Randomized with seed 25910

Randomized with seed 14444

Randomized with seed 19357

Randomized with seed 786

Randomized with seed 42227

Randomized with seed 25606

Randomized with seed 12394
..........................................................................................................................................................................................................................................................................................................................................................................................................................................................................

Finished in 48.22 seconds (files took 15.14 seconds to load)
55 examples, 0 failures

Randomized with seed 30974

........................

Finished in 48.77 seconds (files took 16 seconds to load)
65 examples, 0 failures

Randomized with seed 25606

..........Coverage report generated for (10/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3129 / 4691 LOC (66.7%) covered.
.....

Finished in 50.37 seconds (files took 15.63 seconds to load)
39 examples, 0 failures

Randomized with seed 56213

..

Finished in 50.02 seconds (files took 15.67 seconds to load)
47 examples, 0 failures

Randomized with seed 25910

..

Finished in 50.39 seconds (files took 15.61 seconds to load)
45 examples, 0 failures

Randomized with seed 31020

.....

Finished in 50.75 seconds (files took 15.91 seconds to load)
57 examples, 0 failures

Randomized with seed 19357

..Coverage report generated for (10/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3404 / 4691 LOC (72.56%) covered.
.....

Finished in 51.73 seconds (files took 16.28 seconds to load)
44 examples, 0 failures

Randomized with seed 12394

..

Finished in 52.22 seconds (files took 15.79 seconds to load)
36 examples, 0 failures

Randomized with seed 52859

.

Finished in 51.95 seconds (files took 16.02 seconds to load)
38 examples, 0 failures

Randomized with seed 42227

Coverage report generated for (10/12), (7/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3627 / 4691 LOC (77.32%) covered.
.Coverage report generated for (10/12), (3/12), (7/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3732 / 4691 LOC (79.56%) covered.
.....

Finished in 52.42 seconds (files took 15.48 seconds to load)
33 examples, 0 failures

Randomized with seed 14444

Coverage report generated for (10/12), (3/12), (6/12), (7/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3823 / 4691 LOC (81.5%) covered.
.Coverage report generated for (10/12), (3/12), (5/12), (6/12), (7/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 3971 / 4691 LOC (84.65%) covered.
.

Finished in 52.74 seconds (files took 15.7 seconds to load)
53 examples, 0 failures

Randomized with seed 786

Coverage report generated for (10/12), (3/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4148 / 4691 LOC (88.42%) covered.
Coverage report generated for (10/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4315 / 4691 LOC (91.98%) covered.
Coverage report generated for (10/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4232 / 4691 LOC (90.22%) covered.
Coverage report generated for (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4510 / 4691 LOC (96.14%) covered.
..............

Finished in 57.11 seconds (files took 15.8 seconds to load)
26 examples, 0 failures

Randomized with seed 63976

Coverage report generated for (1/12), (10/12), (11/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4547 / 4691 LOC (96.93%) covered.
Coverage report generated for (1/12), (10/12), (11/12), (12/12), (2/12), (3/12), (4/12), (5/12), (6/12), (7/12), (8/12), (9/12) to /home/denny/code/denny/ShinyCMS-ruby/coverage. 4691 / 4691 LOC (100.0%) covered.

538 examples, 0 failures

Took 78 seconds (1:18)

real	1m18.217s
user	10m52.055s
sys	0m42.866s
```

**78 seconds**; just under half the time taken by the single-core run.

Woo, yay, houpla?
