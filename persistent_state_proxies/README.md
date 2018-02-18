Scripts for handling persistent state that ULSR has to manage. Mostly
the ULSR code tries to maintain state using just Slurm reservation names and attributes. 
However, until HIL is Infiniband friendly, it needs somewhere to record information 
on Infiniband interfaces that have been turned off. Scripts here provide examples
of how to do this.
