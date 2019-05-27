## Human-written Patches and Change Pools 

`patch-list` contains `[project].patches` files, which is a list of bug IDs and revisions of collected human-written patches for change pools.  
Format is `BugID,Buggy Rev,Patch Rev`.  

`pool.tar.gz.*` files are for PTLRH and PLRT change pools built from the human-written patches.  
Once unarchive the files with `cat pool.tar.gz.* | tar xz`, you can see two directories `ptlrh` and `plrt`, which indicate PTLRH and PLRT change pools repectively.  

To access change pools without ConFix, please refer to [here](https://github.com/thwak/confix2019result#using-collected-human-written-changes-from-change-pools).   
Note that we only collected changes in actual programs, not in test classes or resources and samples for the changes pools.  
