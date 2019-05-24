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

## How to Access Coverage Information and Collected Changes outside ConFix.

All coverage information, contexts and changes are stored in `.obj` files, which you may find after unarchiving `coverage.tar.gz` or `pool.tar.gz.*`.   
They are object instances stored by `ObjectOutputStream`.
For example, `coverage-info.obj` can be read as a `com.github.thwak.confix.coverage.CoverageManager` class instance.

Normally, these files are automatically read and used by ConFix.
However, these information can be also accessed outside ConFix by following methods.

### Using Coverage Information.  

As mentioned above, you can simply use `ObjectInputStream` to read `coverage-info.obj` files as `CoverageManager` class instance.  
In your Java code, import `com.github.thwak.confix.coverage.CoverageManager` class which can be obtained from [ConFix](https://github.com/thwak/ConFix) implmentation.  
For supported functionalities, please refer to the actual implementation.  

### Using Collected Human-written Changes from Change Pools.

Change pools have more complex structures.  
We recommend to instantiate `com.github.thwak.confix.pool.ChangePool` with a specific `poolDir` like the following.  

`ChangePool pool = new ChangePool(new File("pool/ptlrh"));`

Above code create a change pool attached to a pool directory `pool/ptlrh`.  
Note that you can obtain PTLRH and PLRT changes pools from `pool.tar.gz.*` files.  

To read stored information - contexts, changes, etc. - from a pool directory, you can simply call `pool.load()`.  
Then you can access to collected contexts and changes by using `getContexts()` or `getChange()` methods.  
For details, please check [ConFix](https://github.com/thwak/ConFix) implementation.  
There are other methods which `ChangePool` supports to utilize collected changes, such as getting change frequencies or retrieving changes with a certain context.  

## Human-written and ConFix Patches.

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

