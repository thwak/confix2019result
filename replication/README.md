We provide a sample - Chart 10 Bug of Defects4j - for ConFix execution to replicate our experiments.  

## Requirements
Java 1.7
[Defects4j](http://defects4j.org) installed.

## How to Run ConFix on The Sample.

We assume that Defects4j has been installed on `/data/defects4j`, and this repository is cloned as `/data/confix2019result`.

1. Run `tar xzf chart10b.tar.gz` to unarchive the sample. 

2. If the repository is cloned in different path, or Defects4j is on different path, open `confix.properties` in `chart10b` and replace paths accordingly.

3. In `pool` directory, unarchive `pool.tar.gz.*` for change pools. There should be `ptlrh` and `plrt` directories under `pool` after this step.   

4. Add `seed` to configuration if necessary.  

5. Execute `confix.sh` in `chart10b`.   

If you want to try different patch generation strategies or configuration, modify `confix.properties`.  
Here are some possible options for configurations.

Seed
`seed` controls random feature of ConFix.  
If you're running ConFix on Amazon EC2, you can use seed values in our results to replicate the same execution.  
Remind that the same seed value leads an execution differently on the different machine (e.g. onOS X or Windows).  

Fix Location Identification. 
`patch.strategy`
`noctx` - Using only SBFL technique for fix locations.
`flfreq` - FLFreq strategy using SBFL + Context Frequency.

Change Concretization.  
`concretize.strategy`
`tc` - Using Type-Compatibile method. 
`neighbor` - Using TC method with three ranges of identifiers:neighbor, local, global. 
`hash-match` - Using Hash Match method + `neighbor`.  

SBFL technique.  
`fl.metric`
`jaccard` - Compute suspiciousness with Jaccard.  
`tarantula` - Compute suspiciousness with Tarantula.  
`ochiai` - Compute suspiciousness with Ochiai. 

## Run ConFix on other Defects4j Bugs.

To run ConFix on other Defects4j bugs, you first need to check out a bug. 

Here is an example of Lang 1 Bug.  

Run `defects4j checkout -p Lang -v 1b -w lang1b` to check out.

Then compile classes and tests.
`cd lang1b`
`defects4j compile`

After that you need to create `confix.properties` and `tests.*` for configuration.  
Run `../config.sh .` or `confix.sh lang1b` in `replication` directory.  

Lastly, copy `coverage-info.obj` and `confix.sh` to the bug directory `lang1b`. 
You can get `coverage-info.obj` by unarchive `coverage.tar.gz` in the repository, and find corresponding directory for a bug.  `confix.sh` can be copied from the sample `chart10b`.  

Now you can run ConFix in `lang1b`.  

