`stats.csv` contains aggregated information for generated patches including patch generation time,  
generated candidates, checked fix locations and changes.  

In `fix-locs`, you can find following files in each directory of a bug.  

`locinfo.csv` - Numbers of checked fix locations and changes until a patch was generated.  
`coveredlines.txt` - A list of suspicious lines identified and sorted by TestedFirst strategy (using SBFL + contexts).  
`lines-{pool}.txt` - A list of fix locations identified and checked with a change pool.  
