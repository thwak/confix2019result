## ConFix 2019 Experiment Results
`patches` directory contains Human and ConFix patches.  
`analysis` contains information related to ConFix's strategy analysis.  
`coverage.tar.gz` contains `coverage-info.obj` files for Defects4j bugs used for experiments.  
`analysis` contains information related to ConFix's strategy analysis.  

For ConFix source code, please check [here](https://github.com/thwak/ConFix).  
Note that code can be updated from the version we used for experiments.  
For replication, we provide a binary and a sample in `replication` directory.  

`pool` contains PTLRH and PLRT change pools used for experiments.  
Files are splitted due to GitHub's file size limitation.  
You can use following command to unarchive files.  
`cat pool.tar.gz.* | tar xz` 

`patches` directory contains Human and ConFix patches.
Directories and files in `patches` have the following structure.
> - project
>   - bugname
>     - buggy (Buggy code)
>     - confix (ConFix patch)
>        - edit (The applied change to generate ConFix patch)
>     - human (Human-written patch)
>     - confix.diff (Differences between buggy code & ConFix patch.) 
>     - human.diff (Differences between buggy code & human-written patch.)
>     - patch_info (Simple info. on ConFix patch)

Each `edit` file contains detailed information of the applied change like the following.

```
Class:org.jfree.chart.block.BorderArrangement //modified class
update
w
to
h
at line 450 //string representation of the change.
Applied Change
update
var0
at ArrayAccess::null[array]
to
var0 //applied abstract change in change pool
from
hadoop-0815a6f:hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/server/namenode/web/resources/NamenodeWebHdfsMethods.java: //where the change was collected
19 //frequency in change pool
P:ArrayAccess{array},L:,R:{34} //change's context
```
