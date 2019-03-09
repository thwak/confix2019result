# ssFix

ssFix patches are obtained from https://github.com/qixin5/ssFix/blob/master/expt0/patch/ssFix/valid/ 
Here are two valid patches that we assessed as incorrect.  

## chart1

### Human

```
--- org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
+++ org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
@@ -1794,7 +1794,7 @@
         }    
         int index = this.plot.getIndexOf(this);
         CategoryDataset dataset = this.plot.getDataset(index);
-        if (dataset != null) {
+        if (dataset == null) {
             return result;
         }    
         int seriesCount = dataset.getRowCount();
```

### ssFix

```
*** /data/people/qx5/repair_expts_1/Chart_1/patches/f26/c4/p2/AbstractCategoryItemRenderer.java	Fri Apr 21 18:25:11 2017
--- /data/people/qx5/defects4j-bugs/charts/projs/Chart_1_buggy/source/org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java	Sun Dec  4 09:40:50 2016
***************
*** 1795,1800 ****
--- 1795,1801 ----
          int index = this.plot.getIndexOf(this);
          CategoryDataset dataset = this.plot.getDataset(index);
          if (dataset != null) {
+             return result;
          }
          int seriesCount = dataset.getRowCount();
          if (plot.getRowRenderingOrder().equals(SortOrder.ASCENDING)) {
```

Human patch immediately returns `result` if `dataset` is `null`.  
ssFix's patch removes return statement, hence it does not return if `dataset` is `null`, and executes the next line `dataset.getRowCount()` which will cause an NPE, hence it is incorrect.   

## math79

### Human

```
--- org/apache/commons/math/util/MathUtils.java
+++ org/apache/commons/math/util/MathUtils.java
@@ -1621,9 +1621,9 @@
      * @return the L<sub>2</sub> distance between the two points
      */
     public static double distance(int[] p1, int[] p2) {
-      int sum = 0;
+      double sum = 0;
       for (int i = 0; i < p1.length; i++) {
-          final int dp = p1[i] - p2[i];
+          final double dp = p1[i] - p2[i];
           sum += dp * dp;
       }
       return Math.sqrt(sum);
```

### ssFix

```
*** /data/people/qx5/repair_expts_1/Math_79/patches/f22/c3/p1/MathUtils.java	Sat Apr 22 10:15:18 2017
--- /data/people/qx5/defects4j-bugs/maths/projs/Math_79_buggy/src/main/java/org/apache/commons/math/util/MathUtils.java	Tue Sep 20 15:21:47 2016
***************
*** 1623,1630 ****
      public static double distance(int[] p1, int[] p2) {
        int sum = 0;
        for (int i = 0; i < p1.length; i++) {
!           final double dp = p1[i] - p2[i];
! 		sum += dp * dp;
        }
        return Math.sqrt(sum);
      }
--- 1623,1630 ----
      public static double distance(int[] p1, int[] p2) {
        int sum = 0;
        for (int i = 0; i < p1.length; i++) {
!           final int dp = p1[i] - p2[i];
!           sum += dp * dp;
        }
        return Math.sqrt(sum);
      }
```

Human patch updates the type of `sum` and `dp` to `double`.  
ssFix only updates the type of `dp`, hence it does not prevent overflow if another test input producing bigger `dp` is given, unlike Human patch.  


# CapGen

CapGen patch is obtained from https://github.com/justinwm/CapGen/tree/master/Patches   
Here is one correct patch that we assessed as incorrect.  

## math65

### Human

```
--- org/apache/commons/math/optimization/general/AbstractLeastSquaresOptimizer.java
+++ org/apache/commons/math/optimization/general/AbstractLeastSquaresOptimizer.java
@@ -237,12 +237,7 @@
      * @return RMS value
      */
     public double getRMS() {
-        double criterion = 0;
-        for (int i = 0; i < rows; ++i) {
-            final double residual = residuals[i];
-            criterion += residual * residual * residualsWeights[i];
-        }
-        return Math.sqrt(criterion / rows);
+        return Math.sqrt(getChiSquare() / rows);
     }
 
     /**
@@ -255,7 +250,7 @@
         double chiSquare = 0;
         for (int i = 0; i < rows; ++i) {
             final double residual = residuals[i];
-            chiSquare += residual * residual / residualsWeights[i];
+            chiSquare += residual * residual * residualsWeights[i];
         }
         return chiSquare;
     }
```

### CapGen

```
--- original/org/apache/commons/math/optimization/general/AbstractLeastSquaresOptimizer.java
+++ fixed/org/apache/commons/math/optimization/general/AbstractLeastSquaresOptimizer.java
@@ -255,7 +255,7 @@ 
public abstract class AbstractLeastSquaresOptimizer implements DifferentiableMul         
         double chiSquare = 0;
         for (int i = 0; i < rows; ++i) {
             final double residual = residuals[i];
-            chiSquare += residual * residual / residualsWeights[i];
+            chiSquare += ((residualsWeights[i]) * residual) * residual;
         }
         return chiSquare;
     } 
```

Human patch fixes two locations.  
CapGen patch is equivalent to the second hunk of Human patch, but the first hunk is missing.  
Hence CapGen patch is partial, and incorrect.  


# SimFix

SimFix patches are obtained from https://github.com/xgdsmileboy/SimFix/tree/master/final/result/patch  
There are 8 correct patches which we assessed as incorrect, and one correct patch which was not generated first.  

## chart3

### Human

```
--- org/jfree/data/time/TimeSeries.java
+++ org/jfree/data/time/TimeSeries.java
@@ -1054,6 +1054,8 @@
             throw new IllegalArgumentException("Requires start <= end.");
         }    
         TimeSeries copy = (TimeSeries) super.clone();
+        copy.minY = Double.NaN;
+        copy.maxY = Double.NaN;
         copy.data = new java.util.ArrayList();
         if (this.data.size() > 0) { 
             for (int index = start; index <= end; index++) {
```

### SimFix

```
// start of generated patch
findBoundsByIteration();
if(added){
updateBoundsForAddedItem(item);
if(getItemCount()>this.maximumItemCount){
TimeSeriesDataItem d=(TimeSeriesDataItem)this.data.remove(0);
updateBoundsForRemovedItem(d);
}
removeAgedItems(false);
if(notify){
fireSeriesChanged();
}
}
// end of generated patch
/* start of original code
        if (added) {
            updateBoundsForAddedItem(item);
            // check if this addition will exceed the maximum item count...
            if (getItemCount() > this.maximumItemCount) {
                TimeSeriesDataItem d = (TimeSeriesDataItem) this.data.remove(0);
                updateBoundsForRemovedItem(d);
            }
            removeAgedItems(false);  // remove old items if necessary, but
                                     // don't notify anyone, because that
                                     // happens next anyway...
            if (notify) {
                fireSeriesChanged();
            }
        }
 end of original code*/
```

SimFix patch inserts `findBoundsByIteration()` before an if statement, which is defined as follows.  

```
    private void findBoundsByIteration() {
        this.minY = Double.NaN;
        this.maxY = Double.NaN;
        Iterator iterator = this.data.iterator();
        while (iterator.hasNext()) {
            TimeSeriesDataItem item = (TimeSeriesDataItem) iterator.next();
            updateBoundsForAddedItem(item);
        }    
    }
```

Human patch added two lines, which set `copy.minX` and `copy.minY` to `Double.NaN`. 
SimFix patch achieves this by updating `minX` and `minY` of `this` by calling `findBoundsByIteration()`.  
This method also calls `updateBoundsForAddedItem()` for all item in `this.data`.  
Hence SimFix patch introduces significant side effect.  
If there was a test case which verifies whether `this.minY` or `this.maxY` is not changed, Human patch would pass it while SimFix patch wouldn't pass it. 


## lang27

### Human

```
---	org/apache/commons/lang3/math/NumberUtils.java
+++	org/apache/commons/lang3/math/NumberUtils.java
@@ -476,7 +476,7 @@
         if (decPos > -1) {
 
             if (expPos > -1) {
-                if (expPos < decPos) {
+                if (expPos < decPos || expPos > str.length()) {
                     throw new NumberFormatException(str + " is not a valid number.");
                 }
                 dec = str.substring(decPos + 1, expPos);
@@ -486,6 +486,9 @@
             mant = str.substring(0, decPos);
         } else {
             if (expPos > -1) {
+                if (expPos > str.length()) {
+                    throw new NumberFormatException(str + " is not a valid number.");
+                }
                 mant = str.substring(0, expPos);
             } else {
                 mant = str;
```

### SimFix

```
// start of generated patch
if(expPos>-1&&expPos<str.length()-1){
mant=str.substring(0,expPos);
}else {
mant=str;
}
// end of generated patch
/* start of original code
            if (expPos > -1) {
                mant = str.substring(0, expPos);
            } else {
                mant = str;
            }
 end of original code*/
```

In SimFix patch, the first hunk of Human patch is missing.  
For the second hunk of Human patch, if `expPos > str.length()` is satisfied, then-block is executed and `NumberFormatException()` is thrown.  
However, in SimFix, if `expPos > str.length()` is satisfied, else-block is executed.  
Since SimFix patch merely avoids executing `mant=str.substring(0, expPos)` only if `expPos > str.length()` is satisfied, it is incorrect.  

## lang41

### Human

```
--- org/apache/commons/lang/ClassUtils.java
+++ org/apache/commons/lang/ClassUtils.java
@@ -188,10 +188,23 @@
             return StringUtils.EMPTY;
         }
 
+        StringBuffer arrayPrefix = new StringBuffer();
 
         // Handle array encoding
+        if (className.startsWith("[")) {
+            while (className.charAt(0) == '[') {
+                className = className.substring(1);
+                arrayPrefix.append("[]");
+            }
             // Strip Object type encoding
+            if (className.charAt(0) == 'L' && className.charAt(className.length() - 1) == ';') {
+                className = className.substring(1, className.length() - 1);
+            }
+        }
 
+        if (reverseAbbreviationMap.containsKey(className)) {
+            className = reverseAbbreviationMap.get(className);
+        }
 
         int lastDotIdx = className.lastIndexOf(PACKAGE_SEPARATOR_CHAR);
         int innerIdx = className.indexOf(
@@ -200,7 +213,7 @@
         if (innerIdx != -1) {
             out = out.replace(INNER_CLASS_SEPARATOR_CHAR, PACKAGE_SEPARATOR_CHAR);
         }
-        return out;
+        return out + arrayPrefix;
     }
 
     // Package name
@@ -242,12 +255,18 @@
      * @return the package name or an empty string
      */
     public static String getPackageName(String className) {
-        if (className == null) {
+        if (className == null || className.length() == 0) {
             return StringUtils.EMPTY;
         }
 
         // Strip array encoding
+        while (className.charAt(0) == '[') {
+            className = className.substring(1);
+        }
         // Strip Object type encoding
+        if (className.charAt(0) == 'L' && className.charAt(className.length() - 1) == ';') {
+            className = className.substring(1);
+        }
 
         int i = className.lastIndexOf(PACKAGE_SEPARATOR_CHAR);
         if (i == -1) {
```

### SimFix

```
// start of generated patch
if(cls==null){
return StringUtils.EMPTY;
}
return getShortCanonicalName(cls.getName());
// end of generated patch
/* start of original code
        if (cls == null) {
            return StringUtils.EMPTY;
        }
        return getShortClassName(cls.getName());
 end of original code*/
```

SimFix patch only updates method `getShortClassName()` to `getShortCanonicalName()`, which accidently produces output to pass given test cases, but most of the features of Human patch is not delivered by SimFix patch. 

## lang50

### Human 

```
--- org/apache/commons/lang/time/FastDateFormat.java
+++ org/apache/commons/lang/time/FastDateFormat.java
@@ -282,16 +282,14 @@
             key = new Pair(key, timeZone);
         }
 
-        if (locale != null) {
-            key = new Pair(key, locale);
+        if (locale == null) {
+            locale = Locale.getDefault();
         }
 
+        key = new Pair(key, locale);
 
         FastDateFormat format = (FastDateFormat) cDateInstanceCache.get(key);
         if (format == null) {
-            if (locale == null) {
-                locale = Locale.getDefault();
-            }
             try {
                 SimpleDateFormat formatter = (SimpleDateFormat) DateFormat.getDateInstance(style, locale);
                 String pattern = formatter.toPattern();
@@ -462,15 +460,13 @@
         if (timeZone != null) {
             key = new Pair(key, timeZone);
         }
-        if (locale != null) {
-            key = new Pair(key, locale);
+        if (locale == null) {
+            locale = Locale.getDefault();
         }
+        key = new Pair(key, locale);
 
         FastDateFormat format = (FastDateFormat) cDateTimeInstanceCache.get(key);
         if (format == null) {
-            if (locale == null) {
-                locale = Locale.getDefault();
-            }
             try {
                 SimpleDateFormat formatter = (SimpleDateFormat) DateFormat.getDateTimeInstance(dateStyle, timeStyle,
                         locale);
```

### SimFix

```
// start of generated patch
if(locale!=null){
key=new Pair(key,locale);
}
SimpleDateFormat formatter=(SimpleDateFormat)DateFormat.getDateTimeInstance(dateStyle,timeStyle,locale);
String pattern=formatter.toPattern();
format=getInstance(pattern,timeZone,locale);
// end of generated patch
/* start of original code
                SimpleDateFormat formatter = (SimpleDateFormat) DateFormat.getDateTimeInstance(dateStyle, timeStyle,
                        locale);
                String pattern = formatter.toPattern();
                format = getInstance(pattern, timeZone, locale);
 end of original code*/
```

SimFix patch only inserts an if statement, which accidently passes given test cases, but completely different from Human patch.  

## lang60
### Human 

```
--- lang/lang60/buggy/org/apache/commons/lang/text/StrBuilder.java
+++ lang/lang60/human/org/apache/commons/lang/text/StrBuilder.java
@@ -1670,7 +1670,7 @@
      */   
     public boolean contains(char ch) {
         char[] thisBuf = buffer;
-        for (int i = 0; i < thisBuf.length; i++) {
+        for (int i = 0; i < this.size; i++) {
             if (thisBuf[i] == ch) {
                 return true;
             }    
@@ -1727,7 +1727,7 @@
             return -1;
         }    
         char[] thisBuf = buffer;
-        for (int i = startIndex; i < thisBuf.length; i++) {
+        for (int i = startIndex; i < size; i++) {
             if (thisBuf[i] == ch) {
                 return i;
             }    
```

### SimFix

```
// start of generated patch
for(int i=0;i<size;i++){
if(thisBuf[i]==ch){
return true;
}
}
// end of generated patch
/* start of original code
        for (int i = 0; i < thisBuf.length; i++) {
            if (thisBuf[i] == ch) {
                return true;
            }
        }
 end of original code*/
```

SimFix patch replaces `size` with `thisBuf.length` in the for statement, which is equivalent to the first hunk of Human patch, but the second hunk is missing. 
Hence SimFix patch is only partial, and it is incorrect.   

## math50

### Human

```
--- org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
+++ org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
@@ -184,10 +184,6 @@
                     break;
                 case REGULA_FALSI:
                     // Nothing.
-                    if (x == x1) {
-                        x0 = 0.5 * (x0 + x1 - FastMath.max(rtol * FastMath.abs(x1), atol));
-                        f0 = computeObjectiveValue(x0);
-                    }
                     break;
                 default:
                     // Should never happen.
```

### SimFix

```
// start of generated patch
if(x==x0){
x0=0.5*(x0+x1-FastMath.max(rtol*FastMath.abs(x1),atol));
f0=computeObjectiveValue(x0);
}
// end of generated patch
/* start of original code
                    if (x == x1) {
                        x0 = 0.5 * (x0 + x1 - FastMath.max(rtol * FastMath.abs(x1), atol));
                        f0 = computeObjectiveValue(x0);
                    }
 end of original code*/
```

Human patch removes the if statement.  
However, in SimFix patch, there is no guarantee that `x == x0` is always `false`, hence it is incorrect.   

## math71

### Human

```
--- org/apache/commons/math/ode/nonstiff/RungeKuttaIntegrator.java
+++ org/apache/commons/math/ode/nonstiff/RungeKuttaIntegrator.java
@@ -177,6 +177,9 @@
                 // it is so small (much probably exactly 0 due to limited accuracy)
                 // that the code above would fail handling it.
                 // So we set up an artificial 0 size step by copying states
+                interpolator.storeTime(stepStart);
+                System.arraycopy(y, 0, yTmp, 0, y0.length);
+                stepSize = 0;
                 loop     = false;
             } else {
                 // reject the step to match exactly the next switch time
```                 

### SimFix

```
// start of generated patch
if(Math.abs(dt)<=Math.ulp(stepStart)){
System.arraycopy(y,0,yTmp,0,y0.length);
stepSize=0;
loop=false;
}else {
stepSize=dt;
}
// end of generated patch
/* start of original code
            if (Math.abs(dt) <= Math.ulp(stepStart)) {
                // we cannot simply truncate the step, reject the current computation
                // and let the loop compute another state with the truncated step.
                // it is so small (much probably exactly 0 due to limited accuracy)
                // that the code above would fail handling it.
                // So we set up an artificial 0 size step by copying states
                loop     = false;
            } else {
                // reject the step to match exactly the next switch time
                stepSize = dt;
            }
 end of original code*/
```

SimFix patch is partial, `interpolator.storeTime(stepStart)` in Human patch is missing.  
For this bug, SimFix actually generated an equivalent patch as its third plausible patch in postedresults.  
We considered this patch correct, but the original paper emphasizes that bugs were fixed by the first patch, like ConFix.  
Hence if we only consider the first patch, it is incorrect.   

## math98
### Human 

```
--- org/apache/commons/math/linear/BigMatrixImpl.java
+++ org/apache/commons/math/linear/BigMatrixImpl.java
@@ -988,7 +988,7 @@
         }
         final int nRows = this.getRowDimension();
         final int nCols = this.getColumnDimension();
-        final BigDecimal[] out = new BigDecimal[v.length];
+        final BigDecimal[] out = new BigDecimal[nRows];
         for (int row = 0; row < nRows; row++) {
             BigDecimal sum = ZERO;
             for (int i = 0; i < nCols; i++) {
--- org/apache/commons/math/linear/RealMatrixImpl.java
+++ org/apache/commons/math/linear/RealMatrixImpl.java
@@ -776,7 +776,7 @@
         if (v.length != nCols) {
             throw new IllegalArgumentException("vector has wrong length");
         }
-        final double[] out = new double[v.length];
+        final double[] out = new double[nRows];
         for (int row = 0; row < nRows; row++) {
             final double[] dataRow = data[row];
             double sum = 0;
```

### SimFix

```
1_BigMatrixImpl.java
// start of generated patch
 final int nRows=this.getRowDimension();
 final int nCols=this.getColumnDimension();
 final BigDecimal[] out=new BigDecimal[nRows];
// end of generated patch
/* start of original code
        final int nRows = this.getRowDimension();
        final int nCols = this.getColumnDimension();
        final BigDecimal[] out = new BigDecimal[v.length];
 end of original code*/
```

Human patch fixed two files `BigMatrixImpl.java` and `RealMatrixImpl.java`.  
SimFix generated two patches, each of them fixes one of the two files only.  
Hence SimFix patch is partial and incorret.  


## time7

### Human

```
---	time/time7/buggy/org/joda/time/format/DateTimeFormatter.java
+++	time/time7/human/org/joda/time/format/DateTimeFormatter.java
@@ -705,9 +705,9 @@
         
         long instantMillis = instant.getMillis();
         Chronology chrono = instant.getChronology();
+        int defaultYear = DateTimeUtils.getChronology(chrono).year().get(instantMillis);
         long instantLocal = instantMillis + chrono.getZone().getOffset(instantMillis);
         chrono = selectChronology(chrono);
-        int defaultYear = chrono.year().get(instantLocal);
         
         DateTimeParserBucket bucket = new DateTimeParserBucket(
             instantLocal, chrono, iLocale, iPivotYear, defaultYear);
```

### SimFix

```
        long instantMillis = instant.getMillis();
        Chronology chrono = instant.getChronology();
// start of generated patch
long instantLocal=instantMillis+chrono.getZone().getOffset(instantMillis);
chrono=selectChronology(chrono);
int defaultYear=chrono.year().get(instantMillis);
// end of generated patch
/* start of original code
        long instantLocal = instantMillis + chrono.getZone().getOffset(instantMillis);
        chrono = selectChronology(chrono);
        int defaultYear = chrono.year().get(instantLocal);
 end of original code*/
```

The key issue is that `defaultYear` value is decided by `instantLocal`, not `instantMillis`.  
Human patch replaces `chrono` with `DateTimeUtils.getChronology(chrono)`, and also updates `instantLocal` to `instantMillis`.  
The position of the modified statement is also changed.   

SimFix patch only updates `instantLocal` to `instantMillis`.  
Since `selectChronology(chrono)` is defined as follows, `chrono` is somewhat similar to `DateTimeUtils.getChronology(chrono)`, which replaces `chrono` in Human patch.    
```
    private Chronology selectChronology(Chronology chrono) {
        chrono = DateTimeUtils.getChronology(chrono);
        if (iChrono != null) {
            chrono = iChrono;
        }   
        if (iZone != null) {
            chrono = chrono.withZone(iZone);
        }   
        return chrono;
    }
```
However, in SimFix patch, `chrono` has the return value of `selectChronology(chrono)`, which will be one of `DateTimeUtils.getChronology(chrono)`, `iChrono`, or `chrono.withZone(iZone)`.  
Hence SimFix patch has the regression when `iChrono != null` or `iZone != null`, although it addresses the issue.  

