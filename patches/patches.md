# Chart

## chart1

### Human

```
---	chart/chart1/buggy/org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
+++	chart/chart1/human/org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
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
### ConFix

Seed:62
PTLRH
PatchNum:512
Time:3 min. 20 sec.
CompileError:474
TestFailure:37
Concretize:hash-local
```
---	chart/chart1/buggy/org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
+++	chart/chart1/confix/org/jfree/chart/renderer/category/AbstractCategoryItemRenderer.java
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
## chart3

### Human

```
---	chart/chart3/buggy/org/jfree/data/time/TimeSeries.java
+++	chart/chart3/human/org/jfree/data/time/TimeSeries.java
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
### ConFix

Seed:16
PLRT
PatchNum:11075
Time:29 min. 2 sec.
CompileError:10112
TestFailure:961
Concretize:neighbors
```
---	chart/chart3/buggy/org/jfree/data/time/TimeSeries.java
+++	chart/chart3/confix/org/jfree/data/time/TimeSeries.java
@@ -1055,7 +1055,8 @@
         }
         TimeSeries copy = (TimeSeries) super.clone();
         copy.data = new java.util.ArrayList();
-        if (this.data.size() > 0) {
+        copy = new TimeSeries(start);
+		if (this.data.size() > 0) {
             for (int index = start; index <= end; index++) {
                 TimeSeriesDataItem item
                         = (TimeSeriesDataItem) this.data.get(index);
```
## chart5

### Human

```
---	chart/chart5/buggy/org/jfree/data/xy/XYSeries.java
+++	chart/chart5/human/org/jfree/data/xy/XYSeries.java
@@ -541,11 +541,15 @@
         if (x == null) {
             throw new IllegalArgumentException("Null 'x' argument.");
         }
+        if (this.allowDuplicateXValues) {
+            add(x, y);
+            return null;
+        }
 
         // if we get to here, we know that duplicate X values are not permitted
         XYDataItem overwritten = null;
         int index = indexOf(x);
-        if (index >= 0 && !this.allowDuplicateXValues) {
+        if (index >= 0) {
             XYDataItem existing = (XYDataItem) this.data.get(index);
             try {
                 overwritten = (XYDataItem) existing.clone();
```
### ConFix

Seed:37
PTLRH
PatchNum:19
Time:1 min. 49 sec.
CompileError:18
TestFailure:0
Concretize:hash-local
```
---	chart/chart5/buggy/org/jfree/data/xy/XYSeries.java
+++	chart/chart5/confix/org/jfree/data/xy/XYSeries.java
@@ -85,6 +85,7 @@
 import org.jfree.data.general.Series;
 import org.jfree.data.general.SeriesChangeEvent;
 import org.jfree.data.general.SeriesException;
+import java.util.Map;
 
 /**
  * Represents a sequence of zero or more data items in the form (x, y).  By
@@ -524,7 +525,7 @@
      * @since 1.0.10
      */
     public XYDataItem addOrUpdate(double x, double y) {
-        return addOrUpdate(new Double(x), new Double(y));
+        return addOrUpdate(new Double(y), new Double(y));
     }
 
     /**
```
## chart7

### Human

```
---	chart/chart7/buggy/org/jfree/data/time/TimePeriodValues.java
+++	chart/chart7/human/org/jfree/data/time/TimePeriodValues.java
@@ -297,9 +297,9 @@
         }
         
         if (this.maxMiddleIndex >= 0) {
-            long s = getDataItem(this.minMiddleIndex).getPeriod().getStart()
+            long s = getDataItem(this.maxMiddleIndex).getPeriod().getStart()
                 .getTime();
-            long e = getDataItem(this.minMiddleIndex).getPeriod().getEnd()
+            long e = getDataItem(this.maxMiddleIndex).getPeriod().getEnd()
                 .getTime();
             long maxMiddle = s + (e - s) / 2;
             if (middle > maxMiddle) {
```
### ConFix

Seed:31
PTLRH
PatchNum:7
Time:1 min. 44 sec.
CompileError:4
TestFailure:2
Concretize:hash-local
```
---	chart/chart7/buggy/org/jfree/data/time/TimePeriodValues.java
+++	chart/chart7/confix/org/jfree/data/time/TimePeriodValues.java
@@ -58,6 +58,7 @@
 import org.jfree.data.general.Series;
 import org.jfree.data.general.SeriesChangeEvent;
 import org.jfree.data.general.SeriesException;
+import java.util.Map;
 
 /**
  * A structure containing zero, one or many {@link TimePeriodValue} instances.  
@@ -549,7 +550,7 @@
      * @return The index.
      */
     public int getMaxMiddleIndex() {
-        return this.maxMiddleIndex;
+        return this.maxEndIndex;
     }
 
     /**
```
## chart9

### Human

```
---	chart/chart9/buggy/org/jfree/data/time/TimeSeries.java
+++	chart/chart9/human/org/jfree/data/time/TimeSeries.java
@@ -941,7 +941,7 @@
             endIndex = -(endIndex + 1); // this is first item AFTER end period
             endIndex = endIndex - 1;    // so this is last item BEFORE end
         }
-        if (endIndex < 0) {
+        if ((endIndex < 0)  || (endIndex < startIndex)) {
             emptyRange = true;
         }
         if (emptyRange) {
```
### ConFix

Seed:45
PLRT
PatchNum:18082
Time:39 min. 20 sec.
CompileError:15438
TestFailure:2642
Concretize:neighbors
```
---	chart/chart9/buggy/org/jfree/data/time/TimeSeries.java
+++	chart/chart9/confix/org/jfree/data/time/TimeSeries.java
@@ -941,7 +941,7 @@
             endIndex = -(endIndex + 1); // this is first item AFTER end period
             endIndex = endIndex - 1;    // so this is last item BEFORE end
         }
-        if (endIndex < 0) {
+        if (endIndex < startIndex) {
             emptyRange = true;
         }
         if (emptyRange) {
```
## chart10

### Human

```
---	chart/chart10/buggy/org/jfree/chart/imagemap/StandardToolTipTagFragmentGenerator.java
+++	chart/chart10/human/org/jfree/chart/imagemap/StandardToolTipTagFragmentGenerator.java
@@ -62,7 +62,7 @@
      * @return The formatted HTML area tag attribute(s).
      */
     public String generateToolTipFragment(String toolTipText) {
-        return " title=\"" + toolTipText
+        return " title=\"" + ImageMapUtilities.htmlEscape(toolTipText) 
             + "\" alt=\"\"";
     }
 
```
### ConFix

Seed:4
PTLRH
PatchNum:28
Time:1 min. 28 sec.
CompileError:15
TestFailure:12
Concretize:hash-package
```
---	chart/chart10/buggy/org/jfree/chart/imagemap/StandardToolTipTagFragmentGenerator.java
+++	chart/chart10/confix/org/jfree/chart/imagemap/StandardToolTipTagFragmentGenerator.java
@@ -62,7 +62,7 @@
      * @return The formatted HTML area tag attribute(s).
      */
     public String generateToolTipFragment(String toolTipText) {
-        return " title=\"" + toolTipText
+        return " title=\"" + ImageMapUtilities.htmlEscape(toolTipText)
             + "\" alt=\"\"";
     }
 
```
## chart11

### Human

```
---	chart/chart11/buggy/org/jfree/chart/util/ShapeUtilities.java
+++	chart/chart11/human/org/jfree/chart/util/ShapeUtilities.java
@@ -272,7 +272,7 @@
             return false;
         }
         PathIterator iterator1 = p1.getPathIterator(null);
-        PathIterator iterator2 = p1.getPathIterator(null);
+        PathIterator iterator2 = p2.getPathIterator(null);
         double[] d1 = new double[6];
         double[] d2 = new double[6];
         boolean done = iterator1.isDone() && iterator2.isDone();
```
### ConFix

Seed:5
PTLRH
PatchNum:2269
Time:4 min. 17 sec.
CompileError:2147
TestFailure:121
Concretize:neighbors
```
---	chart/chart11/buggy/org/jfree/chart/util/ShapeUtilities.java
+++	chart/chart11/confix/org/jfree/chart/util/ShapeUtilities.java
@@ -72,6 +72,7 @@
 import java.awt.geom.Point2D;
 import java.awt.geom.Rectangle2D;
 import java.util.Arrays;
+import java.util.Map;
 
 /**
  * Utility methods for {@link Shape} objects.
@@ -271,7 +272,7 @@
         if (p1.getWindingRule() != p2.getWindingRule()) {
             return false;
         }
-        PathIterator iterator1 = p1.getPathIterator(null);
+        PathIterator iterator1 = p2.getPathIterator(null);
         PathIterator iterator2 = p1.getPathIterator(null);
         double[] d1 = new double[6];
         double[] d2 = new double[6];
```
## chart12

### Human

```
```
### ConFix

Seed:49
PTLRH
PatchNum:899
Time:3 min. 11 sec.
CompileError:816
TestFailure:82
Concretize:neighbors
```
---	chart/chart12/buggy/org/jfree/data/general/AbstractDataset.java
+++	chart/chart12/confix/org/jfree/data/general/AbstractDataset.java
@@ -157,7 +157,7 @@
      * @see #removeChangeListener(DatasetChangeListener)
      */
     public boolean hasListener(EventListener listener) {
-        List list = Arrays.asList(this.listenerList.getListenerList());
+        List list = Arrays.asList(listener);
         return list.contains(listener);
     }
     
```
## chart13

### Human

```
---	chart/chart13/buggy/org/jfree/chart/block/BorderArrangement.java
+++	chart/chart13/human/org/jfree/chart/block/BorderArrangement.java
@@ -452,7 +452,7 @@
         h[3] = h[2];
         if (this.rightBlock != null) {
             RectangleConstraint c4 = new RectangleConstraint(0.0,
-                    new Range(0.0, constraint.getWidth() - w[2]),
+                    new Range(0.0, Math.max(constraint.getWidth() - w[2], 0.0)),
                     LengthConstraintType.RANGE, h[2], null,
                     LengthConstraintType.FIXED);
             Size2D size = this.rightBlock.arrange(g2, c4);
```
### ConFix

Seed:71
PTLRH
PatchNum:3732
Time:8 min. 27 sec.
CompileError:3117
TestFailure:614
Concretize:hash-local
```
---	chart/chart13/buggy/org/jfree/chart/block/BorderArrangement.java
+++	chart/chart13/confix/org/jfree/chart/block/BorderArrangement.java
@@ -55,6 +55,7 @@
 import org.jfree.chart.util.RectangleEdge;
 import org.jfree.chart.util.Size2D;
 import org.jfree.data.Range;
+import java.util.Map;
 
 /**
  * An arrangement manager that lays out blocks in a similar way to
@@ -447,7 +448,7 @@
                     LengthConstraintType.RANGE, h[2], null,
                     LengthConstraintType.FIXED);
             Size2D size = this.leftBlock.arrange(g2, c3);
-            w[2] = size.width;
+            h[2] = size.width;
         }
         h[3] = h[2];
         if (this.rightBlock != null) {
```
## chart15

### Human

```
```
### ConFix

Seed:86
PLRT
PatchNum:25443
Time:1 hrs. 6 min. 50 sec.
CompileError:21935
TestFailure:3506
Concretize:neighbors
```
---	chart/chart15/buggy/org/jfree/chart/plot/PiePlot3D.java
+++	chart/chart15/confix/org/jfree/chart/plot/PiePlot3D.java
@@ -235,6 +235,9 @@
             info.setPlotArea(plotArea);
             info.setDataArea(plotArea);
         }
+		if (info == null) {
+			return;
+		}
 
         drawBackground(g2, plotArea);
 
```
## chart24

### Human

```
---	chart/chart24/buggy/org/jfree/chart/renderer/GrayPaintScale.java
+++	chart/chart24/human/org/jfree/chart/renderer/GrayPaintScale.java
@@ -123,7 +123,7 @@
     public Paint getPaint(double value) {
         double v = Math.max(value, this.lowerBound);
         v = Math.min(v, this.upperBound);
-        int g = (int) ((value - this.lowerBound) / (this.upperBound 
+        int g = (int) ((v - this.lowerBound) / (this.upperBound 
                 - this.lowerBound) * 255.0);
         return new Color(g, g, g);
     }
```
### ConFix

Seed:87
PTLRH
PatchNum:247
Time:1 min. 38 sec.
CompileError:229
TestFailure:17
Concretize:neighbors
```
---	chart/chart24/buggy/org/jfree/chart/renderer/GrayPaintScale.java
+++	chart/chart24/confix/org/jfree/chart/renderer/GrayPaintScale.java
@@ -50,6 +50,7 @@
 import java.io.Serializable;
 
 import org.jfree.chart.util.PublicCloneable;
+import java.util.Map;
 
 /**
  * A paint scale that returns shades of gray.
@@ -123,7 +124,7 @@
     public Paint getPaint(double value) {
         double v = Math.max(value, this.lowerBound);
         v = Math.min(v, this.upperBound);
-        int g = (int) ((value - this.lowerBound) / (this.upperBound 
+        int g = (int) ((v - this.lowerBound) / (this.upperBound 
                 - this.lowerBound) * 255.0);
         return new Color(g, g, g);
     }
```
## chart25

### Human

```
---	chart/chart25/buggy/org/jfree/chart/renderer/category/StatisticalBarRenderer.java
+++	chart/chart25/human/org/jfree/chart/renderer/category/StatisticalBarRenderer.java
@@ -256,6 +256,9 @@
 
         // BAR X
         Number meanValue = dataset.getMeanValue(row, column);
+        if (meanValue == null) {
+            return;
+        }
 
         double value = meanValue.doubleValue();
         double base = 0.0;
@@ -312,7 +315,9 @@
         }
 
         // standard deviation lines
-            double valueDelta = dataset.getStdDevValue(row, column).doubleValue();
+        Number n = dataset.getStdDevValue(row, column);
+        if (n != null) {
+            double valueDelta = n.doubleValue();
             double highVal = rangeAxis.valueToJava2D(meanValue.doubleValue() 
                     + valueDelta, dataArea, yAxisLocation);
             double lowVal = rangeAxis.valueToJava2D(meanValue.doubleValue() 
@@ -341,6 +346,7 @@
             line = new Line2D.Double(lowVal, rectY + rectHeight * 0.25, 
                                      lowVal, rectY + rectHeight * 0.75);
             g2.draw(line);
+        }
         
         CategoryItemLabelGenerator generator = getItemLabelGenerator(row, 
                 column);
@@ -400,6 +406,9 @@
 
         // BAR Y
         Number meanValue = dataset.getMeanValue(row, column);
+        if (meanValue == null) {
+            return;
+        }
 
         double value = meanValue.doubleValue();
         double base = 0.0;
@@ -456,7 +465,9 @@
         }
 
         // standard deviation lines
-            double valueDelta = dataset.getStdDevValue(row, column).doubleValue();
+        Number n = dataset.getStdDevValue(row, column);
+        if (n != null) {
+            double valueDelta = n.doubleValue();
             double highVal = rangeAxis.valueToJava2D(meanValue.doubleValue() 
                     + valueDelta, dataArea, yAxisLocation);
             double lowVal = rangeAxis.valueToJava2D(meanValue.doubleValue() 
@@ -484,6 +495,7 @@
             line = new Line2D.Double(rectX + rectWidth / 2.0d - 5.0d, lowVal,
                                      rectX + rectWidth / 2.0d + 5.0d, lowVal);
             g2.draw(line);
+        }
         
         CategoryItemLabelGenerator generator = getItemLabelGenerator(row, 
                 column);
```
### ConFix

Seed:0
PTLRH
PatchNum:143
Time:1 min. 43 sec.
CompileError:136
TestFailure:6
Concretize:neighbors
```
---	chart/chart25/buggy/org/jfree/chart/renderer/category/StatisticalBarRenderer.java
+++	chart/chart25/confix/org/jfree/chart/renderer/category/StatisticalBarRenderer.java
@@ -203,7 +203,7 @@
         }
         StatisticalCategoryDataset statData = (StatisticalCategoryDataset) data;
 
-        PlotOrientation orientation = plot.getOrientation();
+        PlotOrientation orientation = null;
         if (orientation == PlotOrientation.HORIZONTAL) {
             drawHorizontalItem(g2, state, dataArea, plot, domainAxis, 
                     rangeAxis, statData, row, column);
```
## chart26

### Human

```
```
### ConFix

Seed:33
PTLRH
PatchNum:1106
Time:7 min. 18 sec.
CompileError:1074
TestFailure:31
Concretize:hash-local
```
---	chart/chart26/buggy/org/jfree/chart/plot/CategoryPlot.java
+++	chart/chart26/confix/org/jfree/chart/plot/CategoryPlot.java
@@ -2568,7 +2568,7 @@
             drawBackground(g2, dataArea);
         }
        
-        Map axisStateMap = drawAxes(g2, area, dataArea, state);
+        Map axisStateMap = drawAxes(g2, area, dataArea, null);
 
         // don't let anyone draw outside the data area
         Shape savedClip = g2.getClip();
```
# Closure

## closure2

### Human

```
---	closure/closure2/buggy/com/google/javascript/jscomp/TypeCheck.java
+++	closure/closure2/human/com/google/javascript/jscomp/TypeCheck.java
@@ -1569,9 +1569,13 @@
       ObjectType interfaceType) {
     ObjectType implicitProto = interfaceType.getImplicitPrototype();
     Set<String> currentPropertyNames;
+    if (implicitProto == null) {
       // This can be the case if interfaceType is proxy to a non-existent
       // object (which is a bad type annotation, but shouldn't crash).
+      currentPropertyNames = ImmutableSet.of();
+    } else {
       currentPropertyNames = implicitProto.getOwnPropertyNames();
+    }
     for (String name : currentPropertyNames) {
       ObjectType oType = properties.get(name);
       if (oType != null) {
```
### ConFix

Seed:44
PTLRH
PatchNum:2039
Time:19 min. 45 sec.
CompileError:1962
TestFailure:76
Concretize:neighbors,local+members
```
---	closure/closure2/buggy/com/google/javascript/jscomp/TypeCheck.java
+++	closure/closure2/confix/com/google/javascript/jscomp/TypeCheck.java
@@ -1653,7 +1653,7 @@
       }
 
       // Check whether the extended interfaces have any conflicts
-      if (functionType.getExtendedInterfacesCount() > 1) {
+      if (typedCount > 1) {
         // Only check when extending more than one interfaces
         HashMap<String, ObjectType> properties
             = new HashMap<String, ObjectType>();
```
## closure14

### Human

```
---	closure/closure14/buggy/com/google/javascript/jscomp/ControlFlowAnalysis.java
+++	closure/closure14/human/com/google/javascript/jscomp/ControlFlowAnalysis.java
@@ -764,7 +764,7 @@
         } else if (parent.getLastChild() == node){
           if (cfa != null) {
             for (Node finallyNode : cfa.finallyMap.get(parent)) {
-              cfa.createEdge(fromNode, Branch.UNCOND, finallyNode);
+              cfa.createEdge(fromNode, Branch.ON_EX, finallyNode);
             }
           }
           return computeFollowNode(fromNode, parent, cfa);
```
### ConFix

Seed:68
PTLRH
PatchNum:429
Time:6 min. 17 sec.
CompileError:370
TestFailure:58
Concretize:neighbors,global
```
---	closure/closure14/buggy/com/google/javascript/jscomp/ControlFlowAnalysis.java
+++	closure/closure14/confix/com/google/javascript/jscomp/ControlFlowAnalysis.java
@@ -764,7 +764,7 @@
         } else if (parent.getLastChild() == node){
           if (cfa != null) {
             for (Node finallyNode : cfa.finallyMap.get(parent)) {
-              cfa.createEdge(fromNode, Branch.UNCOND, finallyNode);
+              cfa.createEdge(fromNode, Branch.ON_EX, finallyNode);
             }
           }
           return computeFollowNode(fromNode, parent, cfa);
```
## closure21

### Human

```
---	closure/closure21/buggy/com/google/javascript/jscomp/CheckSideEffects.java
+++	closure/closure21/human/com/google/javascript/jscomp/CheckSideEffects.java
@@ -98,7 +98,7 @@
     // Do not try to remove a block or an expr result. We already handle
     // these cases when we visit the child, and the peephole passes will
     // fix up the tree in more clever ways when these are removed.
-    if (n.isExprResult()) {
+    if (n.isExprResult() || n.isBlock()) {
       return;
     }
 
@@ -110,24 +110,7 @@
 
     boolean isResultUsed = NodeUtil.isExpressionResultUsed(n);
     boolean isSimpleOp = NodeUtil.isSimpleOperatorType(n.getType());
-    if (parent.getType() == Token.COMMA) {
-      if (isResultUsed) {
-        return;
-      }
-      if (n == parent.getLastChild()) {
-        for (Node an : parent.getAncestors()) {
-          int ancestorType = an.getType();
-          if (ancestorType == Token.COMMA) continue;
-          if (ancestorType != Token.EXPR_RESULT && ancestorType != Token.BLOCK) return;
-          else break;
-        }
-      }
-    } else if (parent.getType() != Token.EXPR_RESULT && parent.getType() != Token.BLOCK) {
-      if (! (parent.getType() == Token.FOR && parent.getChildCount() == 4 && (n == parent.getFirstChild() || n == parent.getFirstChild().getNext().getNext()))) {
-        return;
-      }
-    }
-    if (
+    if (!isResultUsed &&
         (isSimpleOp || !NodeUtil.mayHaveSideEffects(n, t.getCompiler()))) {
       String msg = "This code lacks side-effects. Is there a bug?";
       if (n.isString()) {
```
### ConFix

Seed:91
PTLRH
PatchNum:2
Time:7 min. 35 sec.
CompileError:0
TestFailure:1
Concretize:neighbors,global
```
---	closure/closure21/buggy/com/google/javascript/jscomp/CheckSideEffects.java
+++	closure/closure21/confix/com/google/javascript/jscomp/CheckSideEffects.java
@@ -116,7 +116,9 @@
       }
       if (n == parent.getLastChild()) {
         for (Node an : parent.getAncestors()) {
-          int ancestorType = an.getType();
+          if (!parent.isCall())
+				continue;
+		int ancestorType = an.getType();
           if (ancestorType == Token.COMMA) continue;
           if (ancestorType != Token.EXPR_RESULT && ancestorType != Token.BLOCK) return;
           else break;
```
## closure22

### Human

```
---	closure/closure22/buggy/com/google/javascript/jscomp/CheckSideEffects.java
+++	closure/closure22/human/com/google/javascript/jscomp/CheckSideEffects.java
@@ -98,44 +98,20 @@
     // Do not try to remove a block or an expr result. We already handle
     // these cases when we visit the child, and the peephole passes will
     // fix up the tree in more clever ways when these are removed.
-    if (parent.getType() == Token.COMMA) {
-      Node gramps = parent.getParent();
-      if (gramps.isCall() && parent == gramps.getFirstChild()) {
-        if (n == parent.getFirstChild() && parent.getChildCount() == 2 && n.getNext().isName() && "eval".equals(n.getNext().getString())) {
+    if (n.isExprResult() || n.isBlock()) {
       return;
-        }
     }
 
     // This no-op statement was there so that JSDoc information could
     // be attached to the name. This check should not complain about it.
-      if (n == parent.getLastChild()) {
-        for (Node an : parent.getAncestors()) {
-          int ancestorType = an.getType();
-          if (ancestorType == Token.COMMA)
-            continue;
-          if (ancestorType != Token.EXPR_RESULT && ancestorType != Token.BLOCK)
-            return;
-          else
-            break;
-        }
-      }
-    } else if (parent.getType() != Token.EXPR_RESULT && parent.getType() != Token.BLOCK) {
-      if (parent.getType() == Token.FOR && parent.getChildCount() == 4 && (n == parent.getFirstChild() ||
-           n == parent.getFirstChild().getNext().getNext())) {
-      } else {
+    if (n.isQualifiedName() && n.getJSDocInfo() != null) {
       return;
-      }
     }
 
     boolean isResultUsed = NodeUtil.isExpressionResultUsed(n);
     boolean isSimpleOp = NodeUtil.isSimpleOperatorType(n.getType());
     if (!isResultUsed &&
         (isSimpleOp || !NodeUtil.mayHaveSideEffects(n, t.getCompiler()))) {
-      if (n.isQualifiedName() && n.getJSDocInfo() != null) {
-        return;
-      } else if (n.isExprResult()) {
-        return;
-      }
       String msg = "This code lacks side-effects. Is there a bug?";
       if (n.isString()) {
         msg = "Is there a missing '+' on the previous line?";
```
### ConFix

Seed:25
PTLRH
PatchNum:757
Time:8 min. 31 sec.
CompileError:647
TestFailure:109
Concretize:neighbors,global
```
---	closure/closure22/buggy/com/google/javascript/jscomp/CheckSideEffects.java
+++	closure/closure22/confix/com/google/javascript/jscomp/CheckSideEffects.java
@@ -110,7 +110,9 @@
     // be attached to the name. This check should not complain about it.
       if (n == parent.getLastChild()) {
         for (Node an : parent.getAncestors()) {
-          int ancestorType = an.getType();
+          if (!an.isExprResult())
+				continue;
+		int ancestorType = an.getType();
           if (ancestorType == Token.COMMA)
             continue;
           if (ancestorType != Token.EXPR_RESULT && ancestorType != Token.BLOCK)
```
## closure38

### Human

```
---	closure/closure38/buggy/com/google/javascript/jscomp/CodeConsumer.java
+++	closure/closure38/human/com/google/javascript/jscomp/CodeConsumer.java
@@ -242,7 +242,7 @@
     // x--4 (which is a syntax error).
     char prev = getLastChar();
     boolean negativeZero = isNegativeZero(x);
-    if (x < 0 && prev == '-') {
+    if ((x < 0 || negativeZero) && prev == '-') {
       add(" ");
     }
 
```
### ConFix

Seed:74
PTLRH
PatchNum:12232
Time:50 min. 2 sec.
CompileError:10946
TestFailure:1285
Concretize:hash-local
```
---	closure/closure38/buggy/com/google/javascript/jscomp/CodeConsumer.java
+++	closure/closure38/confix/com/google/javascript/jscomp/CodeConsumer.java
@@ -242,7 +242,7 @@
     // x--4 (which is a syntax error).
     char prev = getLastChar();
     boolean negativeZero = isNegativeZero(x);
-    if (x < 0 && prev == '-') {
+    if (x < 1 && prev == '-') {
       add(" ");
     }
 
```
## closure46

### Human

```
---	closure/closure46/buggy/com/google/javascript/rhino/jstype/RecordType.java
+++	closure/closure46/human/com/google/javascript/rhino/jstype/RecordType.java
@@ -137,22 +137,6 @@
         propertyNode);
   }
 
-  @Override
-  public JSType getLeastSupertype(JSType that) {
-    if (!that.isRecordType()) {
-      return super.getLeastSupertype(that);
-    }
-    RecordTypeBuilder builder = new RecordTypeBuilder(registry);
-    for (String property : properties.keySet()) {
-      if (that.toMaybeRecordType().hasProperty(property) &&
-          that.toMaybeRecordType().getPropertyType(property).isEquivalentTo(
-              getPropertyType(property))) {
-        builder.addProperty(property, getPropertyType(property),
-            getPropertyNode(property));
-      }
-    }
-    return builder.build();
-  }
   JSType getGreatestSubtypeHelper(JSType that) {
     if (that.isRecordType()) {
       RecordType thatRecord = that.toMaybeRecordType();
```
### ConFix

Seed:3
PLRT
PatchNum:30962
Time:1 hrs. 54 min. 34 sec.
CompileError:27182
TestFailure:3778
Concretize:hash-package
```
---	closure/closure46/buggy/com/google/javascript/rhino/jstype/RecordType.java
+++	closure/closure46/confix/com/google/javascript/rhino/jstype/RecordType.java
@@ -139,7 +139,7 @@
 
   @Override
   public JSType getLeastSupertype(JSType that) {
-    if (!that.isRecordType()) {
+    if (!isNativeObjectType()) {
       return super.getLeastSupertype(that);
     }
     RecordTypeBuilder builder = new RecordTypeBuilder(registry);
```
## closure55

### Human

```
---	closure/closure55/buggy/com/google/javascript/jscomp/FunctionRewriter.java
+++	closure/closure55/human/com/google/javascript/jscomp/FunctionRewriter.java
@@ -114,7 +114,8 @@
   }
 
   private static boolean isReduceableFunctionExpression(Node n) {
-    return NodeUtil.isFunctionExpression(n);
+    return NodeUtil.isFunctionExpression(n)
+        && !NodeUtil.isGetOrSetKey(n.getParent());
   }
 
   /**
```
### ConFix

Seed:62
PLRT
PatchNum:36872
Time:50 min. 19 sec.
CompileError:34232
TestFailure:2638
Concretize:neighbors,global
```
---	closure/closure55/buggy/com/google/javascript/jscomp/FunctionRewriter.java
+++	closure/closure55/confix/com/google/javascript/jscomp/FunctionRewriter.java
@@ -268,7 +268,7 @@
      */
     protected final Node maybeGetSingleReturnRValue(Node functionNode) {
       Node body = functionNode.getLastChild();
-      if (!body.hasOneChild()) {
+      if (body.getLineno() != 1 || !body.hasOneChild()) {
         return null;
       }
 
```
## closure59

### Human

```
```
### ConFix

Seed:66
PTLRH
PatchNum:14393
Time:1 hrs. 31 min. 56 sec.
CompileError:13021
TestFailure:1371
Concretize:hash-local
```
---	closure/closure59/buggy/com/google/javascript/jscomp/WarningLevel.java
+++	closure/closure59/confix/com/google/javascript/jscomp/WarningLevel.java
@@ -76,7 +76,7 @@
 
     // checkSuspiciousCode needs to be enabled for CheckGlobalThis to get run.
     options.checkSuspiciousCode = true;
-    options.checkGlobalThisLevel = CheckLevel.WARNING;
+    options.checkMissingReturn = CheckLevel.WARNING;
     options.checkSymbols = true;
     options.checkMissingReturn = CheckLevel.WARNING;
 
```
## closure73

### Human

```
---	closure/closure73/buggy/com/google/javascript/jscomp/CodeGenerator.java
+++	closure/closure73/human/com/google/javascript/jscomp/CodeGenerator.java
@@ -1042,7 +1042,7 @@
             // No charsetEncoder provided - pass straight latin characters
             // through, and escape the rest.  Doing the explicit character
             // check is measurably faster than using the CharsetEncoder.
-            if (c > 0x1f && c <= 0x7f) {
+            if (c > 0x1f && c < 0x7f) {
               sb.append(c);
             } else {
               // Other characters can be misinterpreted by some js parsers,
```
### ConFix

Seed:19
PTLRH
PatchNum:8214
Time:25 min. 24 sec.
CompileError:7431
TestFailure:782
Concretize:hash-local
```
---	closure/closure73/buggy/com/google/javascript/jscomp/CodeGenerator.java
+++	closure/closure73/confix/com/google/javascript/jscomp/CodeGenerator.java
@@ -1042,7 +1042,7 @@
             // No charsetEncoder provided - pass straight latin characters
             // through, and escape the rest.  Doing the explicit character
             // check is measurably faster than using the CharsetEncoder.
-            if (c > 0x1f && c <= 0x7f) {
+            if (c < 0x7F && c > 0x1f && c <= 0x7f) {
               sb.append(c);
             } else {
               // Other characters can be misinterpreted by some js parsers,
```
## closure79

### Human

```
---	closure/closure79/buggy/com/google/javascript/jscomp/Normalize.java
+++	closure/closure79/human/com/google/javascript/jscomp/Normalize.java
@@ -119,7 +119,7 @@
   public void process(Node externs, Node root) {
     new NodeTraversal(
         compiler, new NormalizeStatements(compiler, assertOnChange))
-        .traverse(root);
+        .traverseRoots(externs, root);
     if (MAKE_LOCAL_NAMES_UNIQUE) {
       MakeDeclaredNamesUnique renamer = new MakeDeclaredNamesUnique();
       NodeTraversal t = new NodeTraversal(compiler, renamer);
```
### ConFix

Seed:81
PTLRH
PatchNum:18104
Time:1 hrs. 12 min. 54 sec.
CompileError:16605
TestFailure:1498
Concretize:neighbors
```
---	closure/closure79/buggy/com/google/javascript/jscomp/Normalize.java
+++	closure/closure79/confix/com/google/javascript/jscomp/Normalize.java
@@ -496,7 +496,7 @@
     private void extractForInitializer(
         Node n, Node before, Node beforeParent) {
 
-      for (Node next, c = n.getFirstChild(); c != null; c = next) {
+      for (Node next, c = n.getFirstChild(); c != null; c = n) {
         next = c.getNext();
         Node insertBefore = (before == null) ? c : before;
         Node insertBeforeParent = (before == null) ? n : beforeParent;
```
## closure83

### Human

```
---	closure/closure83/buggy/com/google/javascript/jscomp/CommandLineRunner.java
+++	closure/closure83/human/com/google/javascript/jscomp/CommandLineRunner.java
@@ -331,7 +331,10 @@
 
       @Override
       public int parseArguments(Parameters params) throws CmdLineException {
-        String param = params.getParameter(0);
+        String param = null;
+        try {
+          param = params.getParameter(0);
+        } catch (CmdLineException e) {}
 
         if (param == null) {
           setter.addValue(true);
```
### ConFix

Seed:6
PTLRH
PatchNum:18
Time:2 min. 43 sec.
CompileError:17
TestFailure:0
Concretize:neighbors,global
```
---	closure/closure83/buggy/com/google/javascript/jscomp/CommandLineRunner.java
+++	closure/closure83/confix/com/google/javascript/jscomp/CommandLineRunner.java
@@ -430,7 +430,7 @@
     try {
       parser.parseArgument(processedArgs.toArray(new String[] {}));
     } catch (CmdLineException e) {
-      err.println(e.getMessage());
+      System.err.println(e.getMessage());
       isConfigValid = false;
     }
 
```
## closure89

### Human

```
---	closure/closure89/buggy/com/google/javascript/jscomp/CollapseProperties.java
+++	closure/closure89/human/com/google/javascript/jscomp/CollapseProperties.java
@@ -481,6 +481,9 @@
     Node greatGramps = gramps.getParent();
     Node greatGreatGramps = greatGramps.getParent();
 
+    if (rvalue != null && rvalue.getType() == Token.FUNCTION) {
+      checkForHosedThisReferences(rvalue, refName.docInfo, refName);
+    }
 
     // Create the new alias node.
     Node nameNode = NodeUtil.newName(
```
### ConFix

Seed:8
PTLRH
PatchNum:81
Time:3 min. 9 sec.
CompileError:69
TestFailure:11
Concretize:neighbors
```
---	closure/closure89/buggy/com/google/javascript/jscomp/CollapseProperties.java
+++	closure/closure89/confix/com/google/javascript/jscomp/CollapseProperties.java
@@ -824,7 +824,7 @@
           Node nameNode = Node.newString(Token.NAME, propAlias);
           Node newVar = new Node(Token.VAR, nameNode)
               .copyInformationFromForTree(addAfter);
-          parent.addChildAfter(newVar, addAfter);
+          newVar.addChildAfter(newVar, addAfter);
           addAfter = newVar;
           numStubs++;
           compiler.reportCodeChange();
```
## closure90

### Human

```
```
### ConFix

Seed:52
PTLRH
PatchNum:18
Time:4 min. 37 sec.
CompileError:15
TestFailure:2
Concretize:neighbors,local+members
```
---	closure/closure90/buggy/com/google/javascript/jscomp/TypeCheck.java
+++	closure/closure90/confix/com/google/javascript/jscomp/TypeCheck.java
@@ -43,6 +43,7 @@
 import com.google.javascript.rhino.jstype.TernaryValue;
 
 import java.util.Iterator;
+import java.util.Map;
 
 /**
  * <p>Checks the types of JS expressions against any declared type
@@ -474,7 +475,7 @@
         break;
 
       case Token.THIS:
-        ensureTyped(t, n, t.getScope().getTypeOfThis());
+        checkEnumInitializer(t, n, t.getScope().getTypeOfThis());
         break;
 
       case Token.REF_SPECIAL:
```
## closure92

### Human

```
---	closure/closure92/buggy/com/google/javascript/jscomp/ProcessClosurePrimitives.java
+++	closure/closure92/human/com/google/javascript/jscomp/ProcessClosurePrimitives.java
@@ -786,7 +786,7 @@
         } else {
           // In this case, the name was implicitly provided by two independent
           // modules. We need to move this code up to a common module.
-          int indexOfDot = namespace.indexOf('.');
+          int indexOfDot = namespace.lastIndexOf('.');
           if (indexOfDot == -1) {
             // Any old place is fine.
             compiler.getNodeForCodeInsertion(minimumModule)
```
### ConFix

Seed:51
PTLRH
PatchNum:421
Time:4 min. 6 sec.
CompileError:376
TestFailure:44
Concretize:hash-local
```
---	closure/closure92/buggy/com/google/javascript/jscomp/ProcessClosurePrimitives.java
+++	closure/closure92/confix/com/google/javascript/jscomp/ProcessClosurePrimitives.java
@@ -786,7 +786,7 @@
         } else {
           // In this case, the name was implicitly provided by two independent
           // modules. We need to move this code up to a common module.
-          int indexOfDot = namespace.indexOf('.');
+          int indexOfDot = namespace.lastIndexOf('.');
           if (indexOfDot == -1) {
             // Any old place is fine.
             compiler.getNodeForCodeInsertion(minimumModule)
```
## closure93

### Human

```
---	closure/closure93/buggy/com/google/javascript/jscomp/ProcessClosurePrimitives.java
+++	closure/closure93/human/com/google/javascript/jscomp/ProcessClosurePrimitives.java
@@ -786,7 +786,7 @@
         } else {
           // In this case, the name was implicitly provided by two independent
           // modules. We need to move this code up to a common module.
-          int indexOfDot = namespace.indexOf('.');
+          int indexOfDot = namespace.lastIndexOf('.');
           if (indexOfDot == -1) {
             // Any old place is fine.
             compiler.getNodeForCodeInsertion(minimumModule)
```
### ConFix

Seed:28
PTLRH
PatchNum:421
Time:4 min. 27 sec.
CompileError:374
TestFailure:46
Concretize:hash-local
```
---	closure/closure93/buggy/com/google/javascript/jscomp/ProcessClosurePrimitives.java
+++	closure/closure93/confix/com/google/javascript/jscomp/ProcessClosurePrimitives.java
@@ -786,7 +786,7 @@
         } else {
           // In this case, the name was implicitly provided by two independent
           // modules. We need to move this code up to a common module.
-          int indexOfDot = namespace.indexOf('.');
+          int indexOfDot = namespace.lastIndexOf('.');
           if (indexOfDot == -1) {
             // Any old place is fine.
             compiler.getNodeForCodeInsertion(minimumModule)
```
## closure108

### Human

```
---	closure/closure108/buggy/com/google/javascript/jscomp/ScopedAliases.java
+++	closure/closure108/human/com/google/javascript/jscomp/ScopedAliases.java
@@ -256,6 +256,7 @@
     private final Map<String, Var> aliases = Maps.newHashMap();
 
     // Also temporary and cleared for each scope.
+    private final Set<Node> injectedDecls = Sets.newHashSet();
 
     // Suppose you create an alias.
     // var x = goog.x;
@@ -313,6 +314,7 @@
 
       if (t.getScopeDepth() == 2) {
         renameNamespaceShadows(t);
+        injectedDecls.clear();
         aliases.clear();
         forbiddenLocals.clear();
         transformation = null;
@@ -429,6 +431,7 @@
             } else {
               grandparent.addChildBefore(newDecl, varNode);
             }
+            injectedDecls.add(newDecl.getFirstChild());
           }
 
           // Rewrite "var name = EXPR;" to "var name = $jscomp.scope.name;"
@@ -578,7 +581,7 @@
         // When we inject declarations, we duplicate jsdoc. Make sure
         // we only process that jsdoc once.
         JSDocInfo info = n.getJSDocInfo();
-        if (info != null) {
+        if (info != null && !injectedDecls.contains(n)) {
           for (Node node : info.getTypeNodes()) {
             fixTypeNode(node);
           }
```
### ConFix

Seed:87
PTLRH
PatchNum:4300
Time:18 min. 5 sec.
CompileError:4033
TestFailure:266
Concretize:neighbors
```
---	closure/closure108/buggy/com/google/javascript/jscomp/ScopedAliases.java
+++	closure/closure108/confix/com/google/javascript/jscomp/ScopedAliases.java
@@ -233,7 +233,7 @@
       String typeName = aliasReference.getString();
       String aliasExpanded =
           Preconditions.checkNotNull(aliasDefinition.getQualifiedName());
-      Preconditions.checkState(typeName.startsWith(aliasName));
+      Preconditions.checkState(typeName.startsWith(typeName));
       String replacement =
           aliasExpanded + typeName.substring(aliasName.length());
       aliasReference.setString(replacement);
```
## closure109

### Human

```
---	closure/closure109/buggy/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
+++	closure/closure109/human/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
@@ -1905,7 +1905,11 @@
    * For expressions on the right hand side of a this: or new:
    */
   private Node parseContextTypeExpression(JsDocToken token) {
-          return parseTypeName(token);
+    if (token == JsDocToken.QMARK) {
+      return newNode(Token.QMARK);
+    } else {
+      return parseBasicTypeExpression(token);
+    }
   }
 
   /**
```
### ConFix

Seed:70
PTLRH
PatchNum:570
Time:9 min. 34 sec.
CompileError:498
TestFailure:71
Concretize:hash-local
```
---	closure/closure109/buggy/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
+++	closure/closure109/confix/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
@@ -1905,7 +1905,7 @@
    * For expressions on the right hand side of a this: or new:
    */
   private Node parseContextTypeExpression(JsDocToken token) {
-          return parseTypeName(token);
+          return parseTypeExpression(token);
   }
 
   /**
```
## closure119

### Human

```
```
### ConFix

Seed:94
PTLRH
PatchNum:2905
Time:13 min. 48 sec.
CompileError:2771
TestFailure:133
Concretize:hash-local
```
---	closure/closure119/buggy/com/google/javascript/jscomp/CheckGlobalNames.java
+++	closure/closure119/confix/com/google/javascript/jscomp/CheckGlobalNames.java
@@ -98,7 +98,7 @@
         continue;
       }
 
-      checkDescendantNames(name, name.globalSets + name.localSets > 0);
+      checkDescendantNames(name, 256 + name.globalSets + name.localSets > 0);
     }
   }
 
```
## closure125

### Human

```
---	closure/closure125/buggy/com/google/javascript/jscomp/TypeCheck.java
+++	closure/closure125/human/com/google/javascript/jscomp/TypeCheck.java
@@ -1658,7 +1658,7 @@
     JSType type = getJSType(constructor).restrictByNotNullOrUndefined();
     if (type.isConstructor() || type.isEmptyType() || type.isUnknownType()) {
       FunctionType fnType = type.toMaybeFunctionType();
-      if (fnType != null) {
+      if (fnType != null && fnType.hasInstanceType()) {
         visitParameterList(t, n, fnType);
         ensureTyped(t, n, fnType.getInstanceType());
       } else {
```
### ConFix

Seed:91
PTLRH
PatchNum:3494
Time:38 min. 12 sec.
CompileError:3331
TestFailure:162
Concretize:neighbors,global
```
---	closure/closure125/buggy/com/google/javascript/jscomp/TypeCheck.java
+++	closure/closure125/confix/com/google/javascript/jscomp/TypeCheck.java
@@ -49,6 +49,7 @@
 import java.util.HashMap;
 import java.util.Iterator;
 import java.util.Set;
+import java.util.Map;
 
 /**
  * <p>Checks the types of JS expressions against any declared type
@@ -1660,7 +1661,7 @@
       FunctionType fnType = type.toMaybeFunctionType();
       if (fnType != null) {
         visitParameterList(t, n, fnType);
-        ensureTyped(t, n, fnType.getInstanceType());
+        ensureTyped(t, n, fnType.toMaybeEnumElementType());
       } else {
         ensureTyped(t, n);
       }
```
## closure126

### Human

```
---	closure/closure126/buggy/com/google/javascript/jscomp/MinimizeExitPoints.java
+++	closure/closure126/human/com/google/javascript/jscomp/MinimizeExitPoints.java
@@ -138,10 +138,6 @@
        * can cause problems if it changes the completion type of the finally
        * block. See ECMA 262 Sections 8.9 & 12.14
        */
-      if (NodeUtil.hasFinally(n)) {
-        Node finallyBlock = n.getLastChild();
-        tryMinimizeExits(finallyBlock, exitType, labelName);
-      }
     }
 
     // Just a 'label'.
```
### ConFix

Seed:4
PTLRH
PatchNum:30
Time:3 min. 26 sec.
CompileError:29
TestFailure:0
Concretize:hash-local
```
---	closure/closure126/buggy/com/google/javascript/jscomp/MinimizeExitPoints.java
+++	closure/closure126/confix/com/google/javascript/jscomp/MinimizeExitPoints.java
@@ -22,6 +22,7 @@
 import com.google.javascript.rhino.Node;
 import com.google.javascript.rhino.Token;
 import com.google.javascript.rhino.jstype.TernaryValue;
+import java.util.Map;
 
 /**
  * Transform the structure of the AST so that the number of explicit exits
@@ -140,7 +141,7 @@
        */
       if (NodeUtil.hasFinally(n)) {
         Node finallyBlock = n.getLastChild();
-        tryMinimizeExits(finallyBlock, exitType, labelName);
+        tryMinimizeExits(tryBlock, exitType, labelName);
       }
     }
 
```
## closure133

### Human

```
---	closure/closure133/buggy/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
+++	closure/closure133/human/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
@@ -2398,6 +2398,7 @@
    */
   private String getRemainingJSDocLine() {
     String result = stream.getRemainingJSDocLine();
+    unreadToken = NO_UNREAD_TOKEN;
     return result;
   }
 
```
### ConFix

Seed:38
PLRT
PatchNum:30977
Time:1 hrs. 54 min. 50 sec.
CompileError:27403
TestFailure:3572
Concretize:neighbors
```
---	closure/closure133/buggy/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
+++	closure/closure133/confix/com/google/javascript/jscomp/parsing/JsDocInfoParser.java
@@ -878,7 +878,8 @@
                     token = next();
                     typeNode = parseAndRecordTypeNode(token);
 
-                    if (annotation == Annotation.THIS) {
+                    canSkipTypeAnnotation &= !hasType;
+					if (annotation == Annotation.THIS) {
                       typeNode = wrapNode(Token.BANG, typeNode);
                     }
                     type = createJSTypeExpression(typeNode);
```
# Lang

## lang6

### Human

```
---	lang/lang6/buggy/org/apache/commons/lang3/text/translate/CharSequenceTranslator.java
+++	lang/lang6/human/org/apache/commons/lang3/text/translate/CharSequenceTranslator.java
@@ -92,7 +92,7 @@
 //          // contract with translators is that they have to understand codepoints 
 //          // and they just took care of a surrogate pair
             for (int pt = 0; pt < consumed; pt++) {
-                pos += Character.charCount(Character.codePointAt(input, pos));
+                pos += Character.charCount(Character.codePointAt(input, pt));
             }
         }
     }
```
### ConFix

Seed:73
PTLRH
PatchNum:8553
Time:27 min. 24 sec.
CompileError:6220
TestFailure:2332
Concretize:neighbors
```
---	lang/lang6/buggy/org/apache/commons/lang3/text/translate/CharSequenceTranslator.java
+++	lang/lang6/confix/org/apache/commons/lang3/text/translate/CharSequenceTranslator.java
@@ -20,6 +20,7 @@
 import java.io.StringWriter;
 import java.io.Writer;
 import java.util.Locale;
+import java.util.Map;
 
 /**
  * An API for translating text. 
@@ -92,7 +93,7 @@
 //          // contract with translators is that they have to understand codepoints 
 //          // and they just took care of a surrogate pair
             for (int pt = 0; pt < consumed; pt++) {
-                pos += Character.charCount(Character.codePointAt(input, pos));
+                pos += Character.charCount(Character.codePointAt(input, pt));
             }
         }
     }
```
## lang7

### Human

```
---	lang/lang7/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang7/human/org/apache/commons/lang3/math/NumberUtils.java
@@ -449,9 +449,6 @@
         if (StringUtils.isBlank(str)) {
             throw new NumberFormatException("A blank string is not a valid number");
         }  
-        if (str.startsWith("--")) {
-            return null;
-        }
         if (str.startsWith("0x") || str.startsWith("-0x") || str.startsWith("0X") || str.startsWith("-0X")) {
             int hexDigits = str.length() - 2; // drop 0x
             if (str.startsWith("-")) { // drop -
@@ -718,10 +715,13 @@
         if (StringUtils.isBlank(str)) {
             throw new NumberFormatException("A blank string is not a valid number");
         }
+        if (str.trim().startsWith("--")) {
             // this is protection for poorness in java.lang.BigDecimal.
             // it accepts this as a legal value, but it does not appear 
             // to be in specification of class. OS X Java parses it to 
             // a wrong value.
+            throw new NumberFormatException(str + " is not a valid number.");
+        }
         return new BigDecimal(str);
     }
 
```
### ConFix

Seed:96
PTLRH
PatchNum:10274
Time:19 min. 31 sec.
CompileError:9030
TestFailure:1243
Concretize:neighbors
```
---	lang/lang7/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang7/confix/org/apache/commons/lang3/math/NumberUtils.java
@@ -449,7 +449,7 @@
         if (StringUtils.isBlank(str)) {
             throw new NumberFormatException("A blank string is not a valid number");
         }  
-        if (str.startsWith("--")) {
+        if ((new String()).startsWith("--")) {
             return null;
         }
         if (str.startsWith("0x") || str.startsWith("-0x") || str.startsWith("0X") || str.startsWith("-0X")) {
```
## lang22

### Human

```
---	lang/lang22/buggy/org/apache/commons/lang3/math/Fraction.java
+++	lang/lang22/human/org/apache/commons/lang3/math/Fraction.java
@@ -580,8 +580,14 @@
      */
     private static int greatestCommonDivisor(int u, int v) {
         // From Commons Math:
+        if ((u == 0) || (v == 0)) {
+            if ((u == Integer.MIN_VALUE) || (v == Integer.MIN_VALUE)) {
+                throw new ArithmeticException("overflow: gcd is 2^31");
+            }
+            return Math.abs(u) + Math.abs(v);
+        }
         //if either operand is abs 1, return 1:
-        if (Math.abs(u) <= 1 || Math.abs(v) <= 1) {
+        if (Math.abs(u) == 1 || Math.abs(v) == 1) {
             return 1;
         }
         // keep u and v negative, as negative integers range down to
```
### ConFix

Seed:1
PTLRH
PatchNum:3449
Time:38 min. 0 sec.
CompileError:2909
TestFailure:539
Concretize:hash-local
```
---	lang/lang22/buggy/org/apache/commons/lang3/math/Fraction.java
+++	lang/lang22/confix/org/apache/commons/lang3/math/Fraction.java
@@ -581,7 +581,7 @@
     private static int greatestCommonDivisor(int u, int v) {
         // From Commons Math:
         //if either operand is abs 1, return 1:
-        if (Math.abs(u) <= 1 || Math.abs(v) <= 1) {
+        if (Math.abs(v) <= 1 || Math.abs(v) <= 1) {
             return 1;
         }
         // keep u and v negative, as negative integers range down to
```
## lang24

### Human

```
---	lang/lang24/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang24/human/org/apache/commons/lang3/math/NumberUtils.java
@@ -1410,7 +1410,7 @@
             if (chars[i] == 'l'
                 || chars[i] == 'L') {
                 // not allowing L with an exponent or decimal point
-                return foundDigit && !hasExp;
+                return foundDigit && !hasExp && !hasDecPoint;
             }
             // last character is illegal
             return false;
```
### ConFix

Seed:47
PLRT
PatchNum:24231
Time:54 min. 0 sec.
CompileError:19610
TestFailure:4619
Concretize:neighbors,local+members
```
---	lang/lang24/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang24/confix/org/apache/commons/lang3/math/NumberUtils.java
@@ -1410,7 +1410,7 @@
             if (chars[i] == 'l'
                 || chars[i] == 'L') {
                 // not allowing L with an exponent or decimal point
-                return foundDigit && !hasExp;
+                return foundDigit && !hasExp && !hasDecPoint;
             }
             // last character is illegal
             return false;
```
## lang26

### Human

```
---	lang/lang26/buggy/org/apache/commons/lang3/time/FastDateFormat.java
+++	lang/lang26/human/org/apache/commons/lang3/time/FastDateFormat.java
@@ -817,7 +817,7 @@
      * @return the formatted string
      */
     public String format(Date date) {
-        Calendar c = new GregorianCalendar(mTimeZone);
+        Calendar c = new GregorianCalendar(mTimeZone, mLocale);
         c.setTime(date);
         return applyRules(c, new StringBuffer(mMaxLengthEstimate)).toString();
     }
```
### ConFix

Seed:89
PTLRH
PatchNum:976
Time:3 min. 1 sec.
CompileError:889
TestFailure:86
Concretize:neighbors,local+members
```
---	lang/lang26/buggy/org/apache/commons/lang3/time/FastDateFormat.java
+++	lang/lang26/confix/org/apache/commons/lang3/time/FastDateFormat.java
@@ -817,7 +817,7 @@
      * @return the formatted string
      */
     public String format(Date date) {
-        Calendar c = new GregorianCalendar(mTimeZone);
+        Calendar c = new GregorianCalendar(mTimeZone, mLocale);
         c.setTime(date);
         return applyRules(c, new StringBuffer(mMaxLengthEstimate)).toString();
     }
```
## lang27

### Human

```
---	lang/lang27/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang27/human/org/apache/commons/lang3/math/NumberUtils.java
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
### ConFix

Seed:23
PTLRH
PatchNum:3597
Time:5 min. 48 sec.
CompileError:3164
TestFailure:432
Concretize:hash-local
```
---	lang/lang27/buggy/org/apache/commons/lang3/math/NumberUtils.java
+++	lang/lang27/confix/org/apache/commons/lang3/math/NumberUtils.java
@@ -486,7 +486,7 @@
             mant = str.substring(0, decPos);
         } else {
             if (expPos > -1) {
-                mant = str.substring(0, expPos);
+                mant = str.substring(0, decPos + 1);
             } else {
                 mant = str;
             }
```
## lang31

### Human

```
---	lang/lang31/buggy/org/apache/commons/lang3/StringUtils.java
+++	lang/lang31/human/org/apache/commons/lang3/StringUtils.java
@@ -1443,13 +1443,21 @@
 		}
 		int csLength = cs.length();
 		int searchLength = searchChars.length;
+		int csLastIndex = csLength - 1;
+		int searchLastIndex = searchLength - 1;
 		for (int i = 0; i < csLength; i++) {
 			char ch = cs.charAt(i);
 			for (int j = 0; j < searchLength; j++) {
 				if (searchChars[j] == ch) {
+					if (i < csLastIndex && j < searchLastIndex && ch >= Character.MIN_HIGH_SURROGATE && ch <= Character.MAX_HIGH_SURROGATE) {
 						// ch is a supplementary character
+						if (searchChars[j + 1] == cs.charAt(i + 1)) {
+							return true;
+						}
+					} else {
 						// ch is in the Basic Multilingual Plane
 						return true;
+					}
 				}
 			}
 		}
```
### ConFix

Seed:60
PTLRH
PatchNum:1289
Time:4 min. 16 sec.
CompileError:1183
TestFailure:105
Concretize:hash-local
```
---	lang/lang31/buggy/org/apache/commons/lang3/StringUtils.java
+++	lang/lang31/confix/org/apache/commons/lang3/StringUtils.java
@@ -1443,7 +1443,7 @@
 		}
 		int csLength = cs.length();
 		int searchLength = searchChars.length;
-		for (int i = 0; i < csLength; i++) {
+		for (int i = 0; ++i < csLength; i++) {
 			char ch = cs.charAt(i);
 			for (int j = 0; j < searchLength; j++) {
 				if (searchChars[j] == ch) {
```
## lang39

### Human

```
---	lang/lang39/buggy/org/apache/commons/lang3/StringUtils.java
+++	lang/lang39/human/org/apache/commons/lang3/StringUtils.java
@@ -3673,6 +3673,9 @@
 
         // count the replacement text elements that are larger than their corresponding text being replaced
         for (int i = 0; i < searchList.length; i++) {
+            if (searchList[i] == null || replacementList[i] == null) {
+                continue;
+            }
             int greater = replacementList[i].length() - searchList[i].length();
             if (greater > 0) {
                 increase += 3 * greater; // assume 3 matches
```
### ConFix

Seed:93
PTLRH
PatchNum:1396
Time:5 min. 2 sec.
CompileError:1263
TestFailure:132
Concretize:hash-local
```
---	lang/lang39/buggy/org/apache/commons/lang3/StringUtils.java
+++	lang/lang39/confix/org/apache/commons/lang3/StringUtils.java
@@ -20,6 +20,7 @@
 import java.util.Iterator;
 import java.util.List;
 import java.util.Locale;
+import java.util.Map;
 
 /**
  * <p>Operations on {@link java.lang.String} that are
@@ -3673,7 +3674,7 @@
 
         // count the replacement text elements that are larger than their corresponding text being replaced
         for (int i = 0; i < searchList.length; i++) {
-            int greater = replacementList[i].length() - searchList[i].length();
+            int greater = searchList[i].length() - searchList[i].length();
             if (greater > 0) {
                 increase += 3 * greater; // assume 3 matches
             }
```
## lang43

### Human

```
---	lang/lang43/buggy/org/apache/commons/lang/text/ExtendedMessageFormat.java
+++	lang/lang43/human/org/apache/commons/lang/text/ExtendedMessageFormat.java
@@ -419,6 +419,7 @@
         int start = pos.getIndex();
         char[] c = pattern.toCharArray();
         if (escapingOn && c[start] == QUOTE) {
+            next(pos);
             return appendTo == null ? null : appendTo.append(QUOTE);
         }
         int lastHold = start;
```
### ConFix

Seed:11
PTLRH
PatchNum:23
Time:2 min. 45 sec.
CompileError:17
TestFailure:5
Concretize:hash-local
```
---	lang/lang43/buggy/org/apache/commons/lang/text/ExtendedMessageFormat.java
+++	lang/lang43/confix/org/apache/commons/lang/text/ExtendedMessageFormat.java
@@ -26,6 +26,7 @@
 import java.util.Map;
 
 import org.apache.commons.lang.Validate;
+import java.net.InetAddress;
 
 /**
  * Extends <code>java.text.MessageFormat</code> to allow pluggable/additional formatting
@@ -419,7 +420,7 @@
         int start = pos.getIndex();
         char[] c = pattern.toCharArray();
         if (escapingOn && c[start] == QUOTE) {
-            return appendTo == null ? null : appendTo.append(QUOTE);
+            return next(pos) == null ? null : appendTo.append(QUOTE);
         }
         int lastHold = start;
         for (int i = pos.getIndex(); i < pattern.length(); i++) {
```
## lang45

### Human

```
---	lang/lang45/buggy/org/apache/commons/lang/WordUtils.java
+++	lang/lang45/human/org/apache/commons/lang/WordUtils.java
@@ -613,6 +613,9 @@
 
         // if the lower value is greater than the length of the string,
         // set to the length of the string
+        if (lower > str.length()) {
+            lower = str.length();    
+        }
         // if the upper value is -1 (i.e. no limit) or is greater
         // than the length of the string, set to the length of the string
         if (upper == -1 || upper > str.length()) {
```
### ConFix

Seed:55
PTLRH
PatchNum:3965
Time:10 min. 49 sec.
CompileError:3381
TestFailure:583
Concretize:hash-local
```
---	lang/lang45/buggy/org/apache/commons/lang/WordUtils.java
+++	lang/lang45/confix/org/apache/commons/lang/WordUtils.java
@@ -619,7 +619,7 @@
             upper = str.length();
         }
         // if upper is less than lower, raise it to lower
-        if (upper < lower) {
+        if (upper < 3) {
             upper = lower;
         }
 
```
## lang51

### Human

```
---	lang/lang51/buggy/org/apache/commons/lang/BooleanUtils.java
+++	lang/lang51/human/org/apache/commons/lang/BooleanUtils.java
@@ -679,6 +679,7 @@
                         (str.charAt(1) == 'E' || str.charAt(1) == 'e') &&
                         (str.charAt(2) == 'S' || str.charAt(2) == 's');
                 }
+                return false;
             }
             case 4: {
                 char ch = str.charAt(0);
```
### ConFix

Seed:47
PLRT
PatchNum:2184
Time:4 min. 26 sec.
CompileError:1905
TestFailure:277
Concretize:hash-local
```
---	lang/lang51/buggy/org/apache/commons/lang/BooleanUtils.java
+++	lang/lang51/confix/org/apache/commons/lang/BooleanUtils.java
@@ -679,6 +679,7 @@
                         (str.charAt(1) == 'E' || str.charAt(1) == 'e') &&
                         (str.charAt(2) == 'S' || str.charAt(2) == 's');
                 }
+				break;
             }
             case 4: {
                 char ch = str.charAt(0);
```
## lang57

### Human

```
---	lang/lang57/buggy/org/apache/commons/lang/LocaleUtils.java
+++	lang/lang57/human/org/apache/commons/lang/LocaleUtils.java
@@ -220,7 +220,7 @@
      * @return true if the locale is a known locale
      */
     public static boolean isAvailableLocale(Locale locale) {
-        return cAvailableLocaleSet.contains(locale);
+        return availableLocaleList().contains(locale);
     }
 
     //-----------------------------------------------------------------------
```
### ConFix

Seed:89
PTLRH
PatchNum:360
Time:1 min. 8 sec.
CompileError:346
TestFailure:13
Concretize:hash-local
```
---	lang/lang57/buggy/org/apache/commons/lang/LocaleUtils.java
+++	lang/lang57/confix/org/apache/commons/lang/LocaleUtils.java
@@ -220,7 +220,7 @@
      * @return true if the locale is a known locale
      */
     public static boolean isAvailableLocale(Locale locale) {
-        return cAvailableLocaleSet.contains(locale);
+        return availableLocaleList().contains(locale);
     }
 
     //-----------------------------------------------------------------------
```
## lang59

### Human

```
---	lang/lang59/buggy/org/apache/commons/lang/text/StrBuilder.java
+++	lang/lang59/human/org/apache/commons/lang/text/StrBuilder.java
@@ -881,7 +881,7 @@
             String str = (obj == null ? getNullText() : obj.toString());
             int strLen = str.length();
             if (strLen >= width) {
-                str.getChars(0, strLen, buffer, size);
+                str.getChars(0, width, buffer, size);
             } else {
                 int padLen = width - strLen;
                 str.getChars(0, strLen, buffer, size);
```
### ConFix

Seed:43
PTLRH
PatchNum:608
Time:1 min. 38 sec.
CompileError:544
TestFailure:63
Concretize:hash-local
```
---	lang/lang59/buggy/org/apache/commons/lang/text/StrBuilder.java
+++	lang/lang59/confix/org/apache/commons/lang/text/StrBuilder.java
@@ -877,7 +877,7 @@
      */
     public StrBuilder appendFixedWidthPadRight(Object obj, int width, char padChar) {
         if (width > 0) {
-            ensureCapacity(size + width);
+            ensureCapacity(size + width + '\n');
             String str = (obj == null ? getNullText() : obj.toString());
             int strLen = str.length();
             if (strLen >= width) {
```
## lang60

### Human

```
---	lang/lang60/buggy/org/apache/commons/lang/text/StrBuilder.java
+++	lang/lang60/human/org/apache/commons/lang/text/StrBuilder.java
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
### ConFix

Seed:31
PTLRH
PatchNum:2865
Time:5 min. 51 sec.
CompileError:2374
TestFailure:490
Concretize:neighbors
```
---	lang/lang60/buggy/org/apache/commons/lang/text/StrBuilder.java
+++	lang/lang60/confix/org/apache/commons/lang/text/StrBuilder.java
@@ -1111,7 +1111,7 @@
      * @throws IndexOutOfBoundsException if any index is invalid
      */
     private void deleteImpl(int startIndex, int endIndex, int len) {
-        System.arraycopy(buffer, endIndex, buffer, startIndex, size - endIndex);
+        System.arraycopy(buffer, endIndex, buffer, startIndex, size - startIndex - 1);
         size -= len;
     }
 
```
## lang63

### Human

```
---	lang/lang63/buggy/org/apache/commons/lang/time/DurationFormatUtils.java
+++	lang/lang63/human/org/apache/commons/lang/time/DurationFormatUtils.java
@@ -303,25 +303,20 @@
             days -= 1;
         }
         while (days < 0) {
-            days += 31;
+            end.add(Calendar.MONTH, -1);
+            days += end.getActualMaximum(Calendar.DAY_OF_MONTH);
 //days += 31; // TODO: Need tests to show this is bad and the new code is good.
 // HEN: It's a tricky subject. Jan 15th to March 10th. If I count days-first it is 
 // 1 month and 26 days, but if I count month-first then it is 1 month and 23 days.
 // Also it's contextual - if asked for no M in the format then I should probably 
 // be doing no calculating here.
             months -= 1;
+            end.add(Calendar.MONTH, 1);
         }
         while (months < 0) {
             months += 12;
             years -= 1;
         }
-        milliseconds -= reduceAndCorrect(start, end, Calendar.MILLISECOND, milliseconds);
-        seconds -= reduceAndCorrect(start, end, Calendar.SECOND, seconds);
-        minutes -= reduceAndCorrect(start, end, Calendar.MINUTE, minutes);
-        hours -= reduceAndCorrect(start, end, Calendar.HOUR_OF_DAY, hours);
-        days -= reduceAndCorrect(start, end, Calendar.DAY_OF_MONTH, days);
-        months -= reduceAndCorrect(start, end, Calendar.MONTH, months);
-        years -= reduceAndCorrect(start, end, Calendar.YEAR, years);
 
         // This next block of code adds in values that 
         // aren't requested. This allows the user to ask for the 
@@ -429,18 +424,6 @@
         }
         return buffer.toString();
     }
-    static int reduceAndCorrect(Calendar start, Calendar end, int field, int difference) {
-        end.add( field, -1 * difference );
-        int endValue = end.get(field);
-        int startValue = start.get(field);
-        if (endValue < startValue) {
-            int newdiff = startValue - endValue;
-            end.add( field, newdiff );
-            return newdiff;
-        } else {
-            return 0;
-        }
-    }
 
     static final Object y = "y";
     static final Object M = "M";
```
### ConFix

Seed:36
PTLRH
PatchNum:17
Time:45 sec.
CompileError:15
TestFailure:1
Concretize:neighbors
```
---	lang/lang63/buggy/org/apache/commons/lang/time/DurationFormatUtils.java
+++	lang/lang63/confix/org/apache/commons/lang/time/DurationFormatUtils.java
@@ -21,6 +21,7 @@
 import java.util.Calendar;
 import java.util.Date;
 import java.util.TimeZone;
+import java.util.Map;
 
 /**
  * <p>Duration formatting utilities and constants. The following table describes the tokens 
@@ -435,7 +436,7 @@
         int startValue = start.get(field);
         if (endValue < startValue) {
             int newdiff = startValue - endValue;
-            end.add( field, newdiff );
+            end.add( newdiff, newdiff );
             return newdiff;
         } else {
             return 0;
```
# Math

## math2

### Human

```
```
### ConFix

Seed:65
PTLRH
PatchNum:4973
Time:13 min. 57 sec.
CompileError:3707
TestFailure:1265
Concretize:hash-local
```
---	math/math2/buggy/org/apache/commons/math3/distribution/AbstractIntegerDistribution.java
+++	math/math2/confix/org/apache/commons/math3/distribution/AbstractIntegerDistribution.java
@@ -127,7 +127,7 @@
         final boolean chebyshevApplies = !(Double.isInfinite(mu) || Double.isNaN(mu) ||
                 Double.isInfinite(sigma) || Double.isNaN(sigma) || sigma == 0.0);
         if (chebyshevApplies) {
-            double k = FastMath.sqrt((1.0 - p) / p);
+            double k = FastMath.sqrt((1.0 - p - 1) / p);
             double tmp = mu - k * sigma;
             if (tmp > lower) {
                 lower = ((int) Math.ceil(tmp)) - 1;
```
## math3

### Human

```
---	math/math3/buggy/org/apache/commons/math3/util/MathArrays.java
+++	math/math3/human/org/apache/commons/math3/util/MathArrays.java
@@ -818,7 +818,10 @@
             throw new DimensionMismatchException(len, b.length);
         }
 
+        if (len == 1) {
             // Revert to scalar multiplication.
+            return a[0] * b[0];
+        }
 
         final double[] prodHigh = new double[len];
         double prodLowSum = 0;
```
### ConFix

Seed:13
PTLRH
PatchNum:1635
Time:10 min. 29 sec.
CompileError:1240
TestFailure:394
Concretize:hash-local
```
---	math/math3/buggy/org/apache/commons/math3/util/MathArrays.java
+++	math/math3/confix/org/apache/commons/math3/util/MathArrays.java
@@ -820,7 +820,7 @@
 
             // Revert to scalar multiplication.
 
-        final double[] prodHigh = new double[len];
+        final double[] prodHigh = new double[64];
         double prodLowSum = 0;
 
         for (int i = 0; i < len; i++) {
```
## math5

### Human

```
---	math/math5/buggy/org/apache/commons/math3/complex/Complex.java
+++	math/math5/human/org/apache/commons/math3/complex/Complex.java
@@ -302,7 +302,7 @@
         }
 
         if (real == 0.0 && imaginary == 0.0) {
-            return NaN;
+            return INF;
         }
 
         if (isInfinite) {
```
### ConFix

Seed:96
PTLRH
PatchNum:273
Time:4 min. 18 sec.
CompileError:154
TestFailure:118
Concretize:hash-local
```
---	math/math5/buggy/org/apache/commons/math3/complex/Complex.java
+++	math/math5/confix/org/apache/commons/math3/complex/Complex.java
@@ -302,7 +302,7 @@
         }
 
         if (real == 0.0 && imaginary == 0.0) {
-            return NaN;
+            return INF;
         }
 
         if (isInfinite) {
```
## math7

### Human

```
---	math/math7/buggy/org/apache/commons/math3/ode/AbstractIntegrator.java
+++	math/math7/human/org/apache/commons/math3/ode/AbstractIntegrator.java
@@ -343,8 +343,10 @@
                 final double[] eventY = interpolator.getInterpolatedState().clone();
 
                 // advance all event states to current time
-                currentEvent.stepAccepted(eventT, eventY);
-                isLastStep = currentEvent.stop();
+                for (final EventState state : eventsStates) {
+                    state.stepAccepted(eventT, eventY);
+                    isLastStep = isLastStep || state.stop();
+                }
 
                 // handle the first part of the step, up to the event
                 for (final StepHandler handler : stepHandlers) {
@@ -354,22 +356,19 @@
                 if (isLastStep) {
                     // the event asked to stop integration
                     System.arraycopy(eventY, 0, y, 0, y.length);
-                    for (final EventState remaining : occuringEvents) {
-                        remaining.stepAccepted(eventT, eventY);
-                    }
                     return eventT;
                 }
 
-                boolean needReset = currentEvent.reset(eventT, eventY);
+                boolean needReset = false;
+                for (final EventState state : eventsStates) {
+                    needReset =  needReset || state.reset(eventT, eventY);
+                }
                 if (needReset) {
                     // some event handler has triggered changes that
                     // invalidate the derivatives, we need to recompute them
                     System.arraycopy(eventY, 0, y, 0, y.length);
                     computeDerivatives(eventT, y, yDot);
                     resetOccurred = true;
-                    for (final EventState remaining : occuringEvents) {
-                        remaining.stepAccepted(eventT, eventY);
-                    }
                     return eventT;
                 }
 
```
### ConFix

Seed:64
PLRT
PatchNum:35263
Time:3 hrs. 3 min. 11 sec.
CompileError:27182
TestFailure:8079
Concretize:neighbors
```
---	math/math7/buggy/org/apache/commons/math3/ode/AbstractIntegrator.java
+++	math/math7/confix/org/apache/commons/math3/ode/AbstractIntegrator.java
@@ -124,7 +124,7 @@
                                 final double maxCheckInterval,
                                 final double convergence,
                                 final int maxIterationCount) {
-        addEventHandler(handler, maxCheckInterval, convergence,
+        addEventHandler(handler, maxIterationCount + 1, convergence,
                         maxIterationCount,
                         new BracketingNthOrderBrentSolver(convergence, 5));
     }
```
## math8

### Human

```
---	math/math8/buggy/org/apache/commons/math3/distribution/DiscreteDistribution.java
+++	math/math8/human/org/apache/commons/math3/distribution/DiscreteDistribution.java
@@ -178,13 +178,13 @@
      * @throws NotStrictlyPositiveException if {@code sampleSize} is not
      * positive.
      */
-    public T[] sample(int sampleSize) throws NotStrictlyPositiveException {
+    public Object[] sample(int sampleSize) throws NotStrictlyPositiveException {
         if (sampleSize <= 0) {
             throw new NotStrictlyPositiveException(LocalizedFormats.NUMBER_OF_SAMPLES,
                     sampleSize);
         }
 
-        final T[]out = (T[]) java.lang.reflect.Array.newInstance(singletons.get(0).getClass(), sampleSize);
+        final Object[] out = new Object[sampleSize];
 
         for (int i = 0; i < sampleSize; i++) {
             out[i] = sample();
```
### ConFix

Seed:27
PTLRH
PatchNum:979
Time:5 min. 59 sec.
CompileError:935
TestFailure:43
Concretize:neighbors
```
---	math/math8/buggy/org/apache/commons/math3/distribution/DiscreteDistribution.java
+++	math/math8/confix/org/apache/commons/math3/distribution/DiscreteDistribution.java
@@ -184,7 +184,7 @@
                     sampleSize);
         }
 
-        final T[]out = (T[]) java.lang.reflect.Array.newInstance(singletons.get(0).getClass(), sampleSize);
+        final T[]out = (T[]) java.lang.reflect.Array.newInstance(singletons.get(sampleSize).getClass(), sampleSize);
 
         for (int i = 0; i < sampleSize; i++) {
             out[i] = sample();
```
## math18

### Human

```
---	math/math18/buggy/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
+++	math/math18/human/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
@@ -929,7 +929,7 @@
             double[] res = new double[x.length];
             for (int i = 0; i < x.length; i++) {
                 double diff = boundaries[1][i] - boundaries[0][i];
-                res[i] = (x[i] - boundaries[0][i]) / diff;
+                res[i] = x[i] / diff;
             }
             return res;
         }
@@ -955,7 +955,7 @@
             double[] res = new double[x.length];
             for (int i = 0; i < x.length; i++) {
                 double diff = boundaries[1][i] - boundaries[0][i];
-                res[i] = diff * x[i] + boundaries[0][i];
+                res[i] = diff * x[i];
             }
             return res;
         }
@@ -987,12 +987,14 @@
                 return true;
             }
 
+            final double[] bLoEnc = encode(boundaries[0]);
+            final double[] bHiEnc = encode(boundaries[1]);
 
             for (int i = 0; i < x.length; i++) {
-                if (x[i] < 0) {
+                if (x[i] < bLoEnc[i]) {
                     return false;
                 }
-                if (x[i] > 1.0) {
+                if (x[i] > bHiEnc[i]) {
                     return false;
                 }
             }
```
### ConFix

Seed:60
PTLRH
PatchNum:3664
Time:1 hrs. 10 min. 58 sec.
CompileError:3010
TestFailure:653
Concretize:hash-local
```
---	math/math18/buggy/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
+++	math/math18/confix/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
@@ -41,6 +41,7 @@
 import org.apache.commons.math3.random.MersenneTwister;
 import org.apache.commons.math3.random.RandomGenerator;
 import org.apache.commons.math3.util.MathArrays;
+import java.nio.channels.FileLock;
 
 /**
  * <p>An implementation of the active Covariance Matrix Adaptation Evolution Strategy (CMA-ES)
@@ -511,7 +512,7 @@
         for (int i = 0; i < lB.length; i++) {
             if (!Double.isInfinite(lB[i]) ||
                 !Double.isInfinite(uB[i])) {
-                hasFiniteBounds = true;
+                hasFiniteBounds = boundaries == null;
                 break;
             }
         }
```
## math20

### Human

```
---	math/math20/buggy/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
+++	math/math20/human/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
@@ -918,7 +918,8 @@
          * @return the original objective variables, possibly repaired.
          */
         public double[] repairAndDecode(final double[] x) {
-            return
+            return boundaries != null && isRepairMode ?
+                decode(repair(x)) :
                 decode(x);
         }
 
```
### ConFix

Seed:80
PTLRH
PatchNum:52
Time:4 min. 10 sec.
CompileError:41
TestFailure:10
Concretize:hash-local
```
---	math/math20/buggy/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
+++	math/math20/confix/org/apache/commons/math3/optimization/direct/CMAESOptimizer.java
@@ -559,7 +559,7 @@
      */
     private void initializeCMA(double[] guess) {
         if (lambda <= 0) {
-            lambda = 4 + (int) (3. * Math.log(dimension));
+            lambda = this.maxIterations + 4 + (int) (3. * Math.log(dimension));
         }
         // initialize sigma
         double[][] sigmaArray = new double[guess.length][1];
```
## math28

### Human

```
---	math/math28/buggy/org/apache/commons/math3/optimization/linear/SimplexSolver.java
+++	math/math28/human/org/apache/commons/math3/optimization/linear/SimplexSolver.java
@@ -116,6 +116,7 @@
             // there's a degeneracy as indicated by a tie in the minimum ratio test
 
             // 1. check if there's an artificial variable that can be forced out of the basis
+            if (tableau.getNumArtificialVariables() > 0) {
                 for (Integer row : minRatioPositions) {
                     for (int i = 0; i < tableau.getNumArtificialVariables(); i++) {
                         int column = i + tableau.getArtificialVariableOffset();
@@ -125,6 +126,7 @@
                         }
                     }
                 }
+            }
 
             // 2. apply Bland's rule to prevent cycling:
             //    take the row for which the corresponding basic variable has the smallest index
@@ -135,6 +137,7 @@
             // Additional heuristic: if we did not get a solution after half of maxIterations
             //                       revert to the simple case of just returning the top-most row
             // This heuristic is based on empirical data gathered while investigating MATH-828.
+            if (getIterations() < getMaxIterations() / 2) {
                 Integer minRow = null;
                 int minIndex = tableau.getWidth();
                 for (Integer row : minRatioPositions) {
@@ -149,6 +152,7 @@
                     }
                 }
                 return minRow;
+            }
         }
         return minRatioPositions.get(0);
     }
```
### ConFix

Seed:59
PTLRH
PatchNum:21
Time:2 min. 25 sec.
CompileError:18
TestFailure:2
Concretize:neighbors
```
---	math/math28/buggy/org/apache/commons/math3/optimization/linear/SimplexSolver.java
+++	math/math28/confix/org/apache/commons/math3/optimization/linear/SimplexSolver.java
@@ -23,6 +23,7 @@
 import org.apache.commons.math3.exception.MaxCountExceededException;
 import org.apache.commons.math3.optimization.PointValuePair;
 import org.apache.commons.math3.util.Precision;
+import java.util.Map;
 
 
 /**
@@ -140,7 +141,7 @@
                 for (Integer row : minRatioPositions) {
                     int i = tableau.getNumObjectiveFunctions();
                     for (; i < tableau.getWidth() - 1 && minRow != row; i++) {
-                        if (row == tableau.getBasicRow(i)) {
+                        if (minRow == tableau.getBasicRow(i)) {
                             if (i < minIndex) {
                                 minIndex = i;
                                 minRow = row;
```
## math29

### Human

```
---	math/math29/buggy/org/apache/commons/math3/linear/OpenMapRealVector.java
+++	math/math29/human/org/apache/commons/math3/linear/OpenMapRealVector.java
@@ -346,10 +346,9 @@
          * this only. Indeed, if this[i] = 0d and v[i] = 0d, then
          * this[i] / v[i] = NaN, and not 0d.
          */
-        Iterator iter = entries.iterator();
-        while (iter.hasNext()) {
-            iter.advance();
-            res.setEntry(iter.key(), iter.value() / v.getEntry(iter.key()));
+        final int n = getDimension();
+        for (int i = 0; i < n; i++) {
+            res.setEntry(i, this.getEntry(i) / v.getEntry(i));
         }
         return res;
     }
@@ -371,6 +370,18 @@
          *
          * These special cases are handled below.
          */
+        if (v.isNaN() || v.isInfinite()) {
+            final int n = getDimension();
+            for (int i = 0; i < n; i++) {
+                final double y = v.getEntry(i);
+                if (Double.isNaN(y)) {
+                    res.setEntry(i, Double.NaN);
+                } else if (Double.isInfinite(y)) {
+                    final double x = this.getEntry(i);
+                    res.setEntry(i, x * y);
+                }
+            }
+        }
         return res;
     }
 
```
### ConFix

Seed:50
PTLRH
PatchNum:15916
Time:41 min. 48 sec.
CompileError:14135
TestFailure:1780
Concretize:neighbors
```
---	math/math29/buggy/org/apache/commons/math3/linear/OpenMapRealVector.java
+++	math/math29/confix/org/apache/commons/math3/linear/OpenMapRealVector.java
@@ -24,6 +24,7 @@
 import org.apache.commons.math3.util.OpenIntToDoubleHashMap;
 import org.apache.commons.math3.util.OpenIntToDoubleHashMap.Iterator;
 import org.apache.commons.math3.util.FastMath;
+import java.util.Map;
 
 /**
  * This class implements the {@link RealVector} interface with a
@@ -136,7 +137,7 @@
         this.epsilon = epsilon;
         for (int key = 0; key < values.length; key++) {
             double value = values[key];
-            if (!isDefaultValue(value)) {
+            if (!isDefaultValue(epsilon)) {
                 entries.put(key, value);
             }
         }
```
## math30

### Human

```
---	math/math30/buggy/org/apache/commons/math3/stat/inference/MannWhitneyUTest.java
+++	math/math30/human/org/apache/commons/math3/stat/inference/MannWhitneyUTest.java
@@ -170,7 +170,7 @@
                                              final int n2)
         throws ConvergenceException, MaxCountExceededException {
 
-        final int n1n2prod = n1 * n2;
+        final double n1n2prod = n1 * n2;
 
         // http://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U#Normal_approximation
         final double EU = n1n2prod / 2.0;
```
### ConFix

Seed:79
PTLRH
PatchNum:2193
Time:5 min. 7 sec.
CompileError:1978
TestFailure:214
Concretize:neighbors
```
---	math/math30/buggy/org/apache/commons/math3/stat/inference/MannWhitneyUTest.java
+++	math/math30/confix/org/apache/commons/math3/stat/inference/MannWhitneyUTest.java
@@ -174,7 +174,7 @@
 
         // http://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U#Normal_approximation
         final double EU = n1n2prod / 2.0;
-        final double VarU = n1n2prod * (n1 + n2 + 1) / 12.0;
+        final double VarU = n1n2prod * (((double) n1) + n2 + 1) / 12.0;
 
         final double z = (Umin - EU) / FastMath.sqrt(VarU);
 
```
## math32

### Human

```
```
### ConFix

Seed:51
PTLRH
PatchNum:4872
Time:9 min. 34 sec.
CompileError:4402
TestFailure:469
Concretize:hash-local
```
---	math/math32/buggy/org/apache/commons/math3/geometry/partitioning/AbstractRegion.java
+++	math/math32/confix/org/apache/commons/math3/geometry/partitioning/AbstractRegion.java
@@ -202,7 +202,7 @@
                 break;
             case BOTH:
                 final SubHyperplane.SplitSubHyperplane<S> split = other.split(inserted);
-                plusList.add(split.getPlus());
+                plusList.add(0, split.getPlus());
                 minusList.add(split.getMinus());
                 break;
             default:
```
## math33

### Human

```
---	math/math33/buggy/org/apache/commons/math3/optimization/linear/SimplexTableau.java
+++	math/math33/human/org/apache/commons/math3/optimization/linear/SimplexTableau.java
@@ -335,7 +335,7 @@
         // positive cost non-artificial variables
         for (int i = getNumObjectiveFunctions(); i < getArtificialVariableOffset(); i++) {
             final double entry = tableau.getEntry(0, i);
-            if (Precision.compareTo(entry, 0d, maxUlps) > 0) {
+            if (Precision.compareTo(entry, 0d, epsilon) > 0) {
                 columnsToDrop.add(i);
             }
         }
```
### ConFix

Seed:75
PTLRH
PatchNum:10289
Time:19 min. 53 sec.
CompileError:9210
TestFailure:1078
Concretize:hash-local
```
---	math/math33/buggy/org/apache/commons/math3/optimization/linear/SimplexTableau.java
+++	math/math33/confix/org/apache/commons/math3/optimization/linear/SimplexTableau.java
@@ -34,6 +34,7 @@
 import org.apache.commons.math3.optimization.GoalType;
 import org.apache.commons.math3.optimization.PointValuePair;
 import org.apache.commons.math3.util.Precision;
+import java.util.Map;
 
 /**
  * A tableau for use in the Simplex method.
@@ -335,7 +336,7 @@
         // positive cost non-artificial variables
         for (int i = getNumObjectiveFunctions(); i < getArtificialVariableOffset(); i++) {
             final double entry = tableau.getEntry(0, i);
-            if (Precision.compareTo(entry, 0d, maxUlps) > 0) {
+            if (Precision.compareTo(entry, 0d, epsilon) > 0) {
                 columnsToDrop.add(i);
             }
         }
```
## math34

### Human

```
---	math/math34/buggy/org/apache/commons/math3/genetics/ListPopulation.java
+++	math/math34/human/org/apache/commons/math3/genetics/ListPopulation.java
@@ -206,6 +206,6 @@
      * @return chromosome iterator
      */
     public Iterator<Chromosome> iterator() {
-        return chromosomes.iterator();
+        return getChromosomes().iterator();
     }
 }
```
### ConFix

Seed:19
PTLRH
PatchNum:160
Time:2 min. 12 sec.
CompileError:138
TestFailure:21
Concretize:hash-local
```
---	math/math34/buggy/org/apache/commons/math3/genetics/ListPopulation.java
+++	math/math34/confix/org/apache/commons/math3/genetics/ListPopulation.java
@@ -206,6 +206,6 @@
      * @return chromosome iterator
      */
     public Iterator<Chromosome> iterator() {
-        return chromosomes.iterator();
+        return Collections.unmodifiableList(chromosomes).iterator();
     }
 }
```
## math40

### Human

```
---	math/math40/buggy/org/apache/commons/math/analysis/solvers/BracketingNthOrderBrentSolver.java
+++	math/math40/human/org/apache/commons/math/analysis/solvers/BracketingNthOrderBrentSolver.java
@@ -232,10 +232,16 @@
             double targetY;
             if (agingA >= MAXIMAL_AGING) {
                 // we keep updating the high bracket, try to compensate this
-                targetY = -REDUCTION_FACTOR * yB;
+                final int p = agingA - MAXIMAL_AGING;
+                final double weightA = (1 << p) - 1;
+                final double weightB = p + 1;
+                targetY = (weightA * yA - weightB * REDUCTION_FACTOR * yB) / (weightA + weightB);
             } else if (agingB >= MAXIMAL_AGING) {
                 // we keep updating the low bracket, try to compensate this
-                targetY = -REDUCTION_FACTOR * yA;
+                final int p = agingB - MAXIMAL_AGING;
+                final double weightA = p + 1;
+                final double weightB = (1 << p) - 1;
+                targetY = (weightB * yB - weightA * REDUCTION_FACTOR * yA) / (weightA + weightB);
             } else {
                 // bracketing is balanced, try to find the root itself
                 targetY = 0;
```
### ConFix

Seed:63
PTLRH
PatchNum:1603
Time:6 min. 17 sec.
CompileError:1292
TestFailure:310
Concretize:hash-local
```
---	math/math40/buggy/org/apache/commons/math/analysis/solvers/BracketingNthOrderBrentSolver.java
+++	math/math40/confix/org/apache/commons/math/analysis/solvers/BracketingNthOrderBrentSolver.java
@@ -257,7 +257,7 @@
                     // the guessed root is either not strictly inside the interval or it
                     // is a NaN (which occurs when some sampling points share the same y)
                     // we try again with a lower interpolation order
-                    if (signChangeIndex - start >= end - signChangeIndex) {
+                    if (signChangeIndex - start >= end - signChangeIndex - 1) {
                         // we have more points before the sign change, drop the lowest point
                         ++start;
                     } else {
```
## math42

### Human

```
---	math/math42/buggy/org/apache/commons/math/optimization/linear/SimplexTableau.java
+++	math/math42/human/org/apache/commons/math/optimization/linear/SimplexTableau.java
@@ -407,10 +407,12 @@
             continue;
           }
           Integer basicRow = getBasicRow(colIndex);
+          if (basicRow != null && basicRow == 0) {
               // if the basic row is found to be the objective function row
               // set the coefficient to 0 -> this case handles unconstrained 
               // variables that are still part of the objective function
-          if (basicRows.contains(basicRow)) {
+              coefficients[i] = 0;
+          } else if (basicRows.contains(basicRow)) {
               // if multiple variables can take a given value
               // then we choose the first and set the rest equal to 0
               coefficients[i] = 0 - (restrictToNonNegative ? 0 : mostNegative);
```
### ConFix

Seed:1
PTLRH
PatchNum:14783
Time:37 min. 57 sec.
CompileError:13154
TestFailure:1628
Concretize:hash-local
```
---	math/math42/buggy/org/apache/commons/math/optimization/linear/SimplexTableau.java
+++	math/math42/confix/org/apache/commons/math/optimization/linear/SimplexTableau.java
@@ -311,7 +311,7 @@
         Integer row = null;
         for (int i = 0; i < getHeight(); i++) {
             final double entry = getEntry(i, col);
-            if (Precision.equals(entry, 1d, maxUlps) && (row == null)) {
+            if (Precision.equals(entry, 1d, i - 1) && (row == null)) {
                 row = i;
             } else if (!Precision.equals(entry, 0d, maxUlps)) {
                 return null;
```
## math44

### Human

```
```
### ConFix

Seed:81
PLRT
PatchNum:25010
Time:1 hrs. 10 min. 5 sec.
CompileError:20033
TestFailure:4975
Concretize:hash-local
```
---	math/math44/buggy/org/apache/commons/math/ode/events/EventState.java
+++	math/math44/confix/org/apache/commons/math/ode/events/EventState.java
@@ -27,6 +27,7 @@
 import org.apache.commons.math.ode.events.EventHandler;
 import org.apache.commons.math.ode.sampling.StepInterpolator;
 import org.apache.commons.math.util.FastMath;
+import java.io.DataInputStream;
 
 /** This class handles the state for one {@link EventHandler
  * event handler} during integration steps.
@@ -188,7 +189,8 @@
         throws ConvergenceException {
 
             forward = interpolator.isForward();
-            final double t1 = interpolator.getCurrentTime();
+            t0 = interpolator.getPreviousTime();
+			final double t1 = interpolator.getCurrentTime();
             final double dt = t1 - t0;
             if (FastMath.abs(dt) < convergence) {
                 // we cannot do anything on such a small step, don't trigger any events
```
## math49

### Human

```
---	math/math49/buggy/org/apache/commons/math/linear/OpenMapRealVector.java
+++	math/math49/human/org/apache/commons/math/linear/OpenMapRealVector.java
@@ -342,7 +342,7 @@
     public OpenMapRealVector ebeDivide(RealVector v) {
         checkVectorDimensions(v.getDimension());
         OpenMapRealVector res = new OpenMapRealVector(this);
-        Iterator iter = res.entries.iterator();
+        Iterator iter = entries.iterator();
         while (iter.hasNext()) {
             iter.advance();
             res.setEntry(iter.key(), iter.value() / v.getEntry(iter.key()));
@@ -355,7 +355,7 @@
     public OpenMapRealVector ebeDivide(double[] v) {
         checkVectorDimensions(v.length);
         OpenMapRealVector res = new OpenMapRealVector(this);
-        Iterator iter = res.entries.iterator();
+        Iterator iter = entries.iterator();
         while (iter.hasNext()) {
             iter.advance();
             res.setEntry(iter.key(), iter.value() / v[iter.key()]);
@@ -367,7 +367,7 @@
     public OpenMapRealVector ebeMultiply(RealVector v) {
         checkVectorDimensions(v.getDimension());
         OpenMapRealVector res = new OpenMapRealVector(this);
-        Iterator iter = res.entries.iterator();
+        Iterator iter = entries.iterator();
         while (iter.hasNext()) {
             iter.advance();
             res.setEntry(iter.key(), iter.value() * v.getEntry(iter.key()));
@@ -380,7 +380,7 @@
     public OpenMapRealVector ebeMultiply(double[] v) {
         checkVectorDimensions(v.length);
         OpenMapRealVector res = new OpenMapRealVector(this);
-        Iterator iter = res.entries.iterator();
+        Iterator iter = entries.iterator();
         while (iter.hasNext()) {
             iter.advance();
             res.setEntry(iter.key(), iter.value() * v[iter.key()]);
```
### ConFix

Seed:98
PTLRH
PatchNum:1480
Time:3 min. 10 sec.
CompileError:1372
TestFailure:107
Concretize:hash-local
```
---	math/math49/buggy/org/apache/commons/math/linear/OpenMapRealVector.java
+++	math/math49/confix/org/apache/commons/math/linear/OpenMapRealVector.java
@@ -664,7 +664,7 @@
         if (!isDefaultValue(value)) {
             entries.put(index, value);
         } else if (entries.containsKey(index)) {
-            entries.remove(index);
+            entries.put(index, value);
         }
     }
 
```
## math50

### Human

```
---	math/math50/buggy/org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
+++	math/math50/human/org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
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
### ConFix

Seed:20
PTLRH
PatchNum:33
Time:1 min. 53 sec.
CompileError:25
TestFailure:7
Concretize:hash-local
```
---	math/math50/buggy/org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
+++	math/math50/confix/org/apache/commons/math/analysis/solvers/BaseSecantSolver.java
@@ -185,7 +185,7 @@
                 case REGULA_FALSI:
                     // Nothing.
                     if (x == x1) {
-                        x0 = 0.5 * (x0 + x1 - FastMath.max(rtol * FastMath.abs(x1), atol));
+                        x0 = 0.5 * (x0 + x1 + 1 - FastMath.max(rtol * FastMath.abs(x1), atol));
                         f0 = computeObjectiveValue(x0);
                     }
                     break;
```
## math56

### Human

```
---	math/math56/buggy/org/apache/commons/math/util/MultidimensionalCounter.java
+++	math/math56/human/org/apache/commons/math/util/MultidimensionalCounter.java
@@ -234,13 +234,7 @@
             indices[i] = idx;
         }
 
-        int idx = 1;
-        while (count < index) {
-            count += idx;
-            ++idx;
-        }
-        --idx;
-        indices[last] = idx;
+        indices[last] = index - count;
 
         return indices;
     }
```
### ConFix

Seed:6
PTLRH
PatchNum:1527
Time:16 min. 2 sec.
CompileError:1149
TestFailure:377
Concretize:hash-package
```
---	math/math56/buggy/org/apache/commons/math/util/MultidimensionalCounter.java
+++	math/math56/confix/org/apache/commons/math/util/MultidimensionalCounter.java
@@ -236,7 +236,7 @@
 
         int idx = 1;
         while (count < index) {
-            count += idx;
+            count += Math.PI / 2.0;
             ++idx;
         }
         --idx;
```
## math57

### Human

```
---	math/math57/buggy/org/apache/commons/math/stat/clustering/KMeansPlusPlusClusterer.java
+++	math/math57/human/org/apache/commons/math/stat/clustering/KMeansPlusPlusClusterer.java
@@ -172,7 +172,7 @@
         while (resultSet.size() < k) {
             // For each data point x, compute D(x), the distance between x and
             // the nearest center that has already been chosen.
-            int sum = 0;
+            double sum = 0;
             for (int i = 0; i < pointSet.size(); i++) {
                 final T p = pointSet.get(i);
                 final Cluster<T> nearest = getNearestCluster(resultSet, p);
```
### ConFix

Seed:58
PTLRH
PatchNum:1880
Time:8 min. 31 sec.
CompileError:1696
TestFailure:183
Concretize:neighbors
```
---	math/math57/buggy/org/apache/commons/math/stat/clustering/KMeansPlusPlusClusterer.java
+++	math/math57/confix/org/apache/commons/math/stat/clustering/KMeansPlusPlusClusterer.java
@@ -172,7 +172,7 @@
         while (resultSet.size() < k) {
             // For each data point x, compute D(x), the distance between x and
             // the nearest center that has already been chosen.
-            int sum = 0;
+            int sum = -1;
             for (int i = 0; i < pointSet.size(); i++) {
                 final T p = pointSet.get(i);
                 final Cluster<T> nearest = getNearestCluster(resultSet, p);
```
## math58

### Human

```
---	math/math58/buggy/org/apache/commons/math/optimization/fitting/GaussianFitter.java
+++	math/math58/human/org/apache/commons/math/optimization/fitting/GaussianFitter.java
@@ -118,7 +118,7 @@
      */
     public double[] fit() {
         final double[] guess = (new ParameterGuesser(getObservations())).guess();
-        return fit(new Gaussian.Parametric(), guess);
+        return fit(guess);
     }
 
     /**
```
### ConFix

Seed:21
PTLRH
PatchNum:1658
Time:3 min. 37 sec.
CompileError:1517
TestFailure:140
Concretize:hash-local
```
---	math/math58/buggy/org/apache/commons/math/optimization/fitting/GaussianFitter.java
+++	math/math58/confix/org/apache/commons/math/optimization/fitting/GaussianFitter.java
@@ -310,7 +310,7 @@
                     if (p2 == null) {
                         return 1;
                     }
-                    if (p1.getX() < p2.getX()) {
+                    if (p2.getY() < p2.getX()) {
                         return -1;
                     }
                     if (p1.getX() > p2.getX()) {
```
## math61

### Human

```
---	math/math61/buggy/org/apache/commons/math/distribution/PoissonDistributionImpl.java
+++	math/math61/human/org/apache/commons/math/distribution/PoissonDistributionImpl.java
@@ -19,7 +19,7 @@
 import java.io.Serializable;
 
 import org.apache.commons.math.MathException;
-import org.apache.commons.math.MathRuntimeException;
+import org.apache.commons.math.exception.NotStrictlyPositiveException;
 import org.apache.commons.math.exception.util.LocalizedFormats;
 import org.apache.commons.math.special.Gamma;
 import org.apache.commons.math.util.MathUtils;
@@ -91,7 +91,7 @@
      */
     public PoissonDistributionImpl(double p, double epsilon, int maxIterations) {
         if (p <= 0) {
-            throw MathRuntimeException.createIllegalArgumentException(LocalizedFormats.NOT_POSITIVE_POISSON_MEAN, p);
+            throw new NotStrictlyPositiveException(LocalizedFormats.MEAN, p);
         }
         mean = p;
         normal = new NormalDistributionImpl(p, FastMath.sqrt(p));
```
### ConFix

Seed:92
PLRT
PatchNum:20455
Time:47 min. 47 sec.
CompileError:17077
TestFailure:3376
Concretize:hash-local
```
---	math/math61/buggy/org/apache/commons/math/distribution/PoissonDistributionImpl.java
+++	math/math61/confix/org/apache/commons/math/distribution/PoissonDistributionImpl.java
@@ -91,7 +91,8 @@
      */
     public PoissonDistributionImpl(double p, double epsilon, int maxIterations) {
         if (p <= 0) {
-            throw MathRuntimeException.createIllegalArgumentException(LocalizedFormats.NOT_POSITIVE_POISSON_MEAN, p);
+            randomData.nextPoisson(mean);
+			throw MathRuntimeException.createIllegalArgumentException(LocalizedFormats.NOT_POSITIVE_POISSON_MEAN, p);
         }
         mean = p;
         normal = new NormalDistributionImpl(p, FastMath.sqrt(p));
```
## math62

### Human

```
---	math/math62/buggy/org/apache/commons/math/optimization/univariate/MultiStartUnivariateRealOptimizer.java
+++	math/math62/human/org/apache/commons/math/optimization/univariate/MultiStartUnivariateRealOptimizer.java
@@ -143,7 +143,7 @@
                                                  final GoalType goal,
                                                  final double min, final double max)
         throws FunctionEvaluationException {
-        return optimize(f, goal, min, max, 0);
+        return optimize(f, goal, min, max, min + 0.5 * (max - min));
     }
 
     /** {@inheritDoc} */
@@ -157,9 +157,8 @@
         // Multi-start loop.
         for (int i = 0; i < starts; ++i) {
             try {
-                final double bound1 = (i == 0) ? min : min + generator.nextDouble() * (max - min);
-                final double bound2 = (i == 0) ? max : min + generator.nextDouble() * (max - min);
-                optima[i] = optimizer.optimize(f, goal, FastMath.min(bound1, bound2), FastMath.max(bound1, bound2));
+                final double s = (i == 0) ? startValue : min + generator.nextDouble() * (max - min);
+                optima[i] = optimizer.optimize(f, goal, min, max, s);
             } catch (FunctionEvaluationException fee) {
                 optima[i] = null;
             } catch (ConvergenceException ce) {
```
### ConFix

Seed:14
PLRT
PatchNum:20341
Time:34 min. 13 sec.
CompileError:18226
TestFailure:2113
Concretize:neighbors
```
---	math/math62/buggy/org/apache/commons/math/optimization/univariate/MultiStartUnivariateRealOptimizer.java
+++	math/math62/confix/org/apache/commons/math/optimization/univariate/MultiStartUnivariateRealOptimizer.java
@@ -29,6 +29,7 @@
 import org.apache.commons.math.optimization.GoalType;
 import org.apache.commons.math.optimization.ConvergenceChecker;
 import org.apache.commons.math.util.FastMath;
+import java.util.Map;
 
 /**
  * Special implementation of the {@link UnivariateRealOptimizer} interface
@@ -159,7 +160,7 @@
             try {
                 final double bound1 = (i == 0) ? min : min + generator.nextDouble() * (max - min);
                 final double bound2 = (i == 0) ? max : min + generator.nextDouble() * (max - min);
-                optima[i] = optimizer.optimize(f, goal, FastMath.min(bound1, bound2), FastMath.max(bound1, bound2));
+                optima[i] = optimizer.optimize(f, goal, FastMath.min(bound1, min), FastMath.max(bound1, bound2));
             } catch (FunctionEvaluationException fee) {
                 optima[i] = null;
             } catch (ConvergenceException ce) {
```
## math63

### Human

```
---	math/math63/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math63/human/org/apache/commons/math/util/MathUtils.java
@@ -414,7 +414,7 @@
      * @return {@code true} if the values are equal.
      */
     public static boolean equals(double x, double y) {
-        return (Double.isNaN(x) && Double.isNaN(y)) || x == y;
+        return equals(x, y, 1);
     }
 
     /**
```
### ConFix

Seed:17
PTLRH
PatchNum:19
Time:1 min. 51 sec.
CompileError:18
TestFailure:0
Concretize:hash-local
```
---	math/math63/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math63/confix/org/apache/commons/math/util/MathUtils.java
@@ -414,7 +414,7 @@
      * @return {@code true} if the values are equal.
      */
     public static boolean equals(double x, double y) {
-        return (Double.isNaN(x) && Double.isNaN(y)) || x == y;
+        return (Double.isNaN(x) && Double.isNaN(y) && x < y) || x == y;
     }
 
     /**
```
## math70

### Human

```
---	math/math70/buggy/org/apache/commons/math/analysis/solvers/BisectionSolver.java
+++	math/math70/human/org/apache/commons/math/analysis/solvers/BisectionSolver.java
@@ -69,7 +69,7 @@
     /** {@inheritDoc} */
     public double solve(final UnivariateRealFunction f, double min, double max, double initial)
         throws MaxIterationsExceededException, FunctionEvaluationException {
-        return solve(min, max);
+        return solve(f, min, max);
     }
 
     /** {@inheritDoc} */
```
### ConFix

Seed:3
PTLRH
PatchNum:116
Time:1 min. 4 sec.
CompileError:101
TestFailure:14
Concretize:hash-local
```
---	math/math70/buggy/org/apache/commons/math/analysis/solvers/BisectionSolver.java
+++	math/math70/confix/org/apache/commons/math/analysis/solvers/BisectionSolver.java
@@ -19,6 +19,7 @@
 import org.apache.commons.math.FunctionEvaluationException;
 import org.apache.commons.math.MaxIterationsExceededException;
 import org.apache.commons.math.analysis.UnivariateRealFunction;
+import java.util.List;
 
 /**
  * Implements the <a href="http://mathworld.wolfram.com/Bisection.html">
@@ -69,7 +70,7 @@
     /** {@inheritDoc} */
     public double solve(final UnivariateRealFunction f, double min, double max, double initial)
         throws MaxIterationsExceededException, FunctionEvaluationException {
-        return solve(min, max);
+        return solve(f, min, max);
     }
 
     /** {@inheritDoc} */
```
## math74

### Human

```
```
### ConFix

Seed:75
PTLRH
PatchNum:8606
Time:1 hrs. 15 min. 53 sec.
CompileError:7811
TestFailure:794
Concretize:neighbors
```
---	math/math74/buggy/org/apache/commons/math/ode/nonstiff/AdamsMoultonIntegrator.java
+++	math/math74/confix/org/apache/commons/math/ode/nonstiff/AdamsMoultonIntegrator.java
@@ -28,6 +28,7 @@
 import org.apache.commons.math.ode.events.CombinedEventsManager;
 import org.apache.commons.math.ode.sampling.NordsieckStepInterpolator;
 import org.apache.commons.math.ode.sampling.StepHandler;
+import java.util.Map;
 
 
 /**
@@ -236,7 +237,7 @@
         interpolator.reinitialize(stepStart, stepSize, scaled, nordsieck);
         interpolator.storeTime(stepStart);
 
-        double hNew = stepSize;
+        double hNew = t;
         interpolator.rescale(hNew);
 
         boolean lastStep = false;
```
## math75

### Human

```
---	math/math75/buggy/org/apache/commons/math/stat/Frequency.java
+++	math/math75/human/org/apache/commons/math/stat/Frequency.java
@@ -300,7 +300,7 @@
      */
     @Deprecated
     public double getPct(Object v) {
-        return getCumPct((Comparable<?>) v);
+        return getPct((Comparable<?>) v);
     }
 
     /**
```
### ConFix

Seed:22
PLRT
PatchNum:4890
Time:9 min. 52 sec.
CompileError:4238
TestFailure:650
Concretize:neighbors,local+members
```
---	math/math75/buggy/org/apache/commons/math/stat/Frequency.java
+++	math/math75/confix/org/apache/commons/math/stat/Frequency.java
@@ -23,6 +23,7 @@
 import java.util.TreeMap;
 
 import org.apache.commons.math.MathRuntimeException;
+import java.util.Map;
 
 /**
  * Maintains a frequency distribution.
@@ -300,7 +301,7 @@
      */
     @Deprecated
     public double getPct(Object v) {
-        return getCumPct((Comparable<?>) v);
+        return getPct((Comparable<?>) v);
     }
 
     /**
```
## math78

### Human

```
---	math/math78/buggy/org/apache/commons/math/ode/events/EventState.java
+++	math/math78/human/org/apache/commons/math/ode/events/EventState.java
@@ -188,6 +188,7 @@
                 if (g0Positive ^ (gb >= 0)) {
                     // there is a sign change: an event is expected during this step
 
+                    if (ga * gb > 0) {
                         // this is a corner case:
                         // - there was an event near ta,
                         // - there is another event between ta and tb
@@ -195,7 +196,17 @@
                         // this implies that the real sign of ga is the same as gb, so we need to slightly
                         // shift ta to make sure ga and gb get opposite signs and the solver won't complain
                         // about bracketing
+                        final double epsilon = (forward ? 0.25 : -0.25) * convergence;
+                        for (int k = 0; (k < 4) && (ga * gb > 0); ++k) {
+                            ta += epsilon;
+                            interpolator.setInterpolatedTime(ta);
+                            ga = handler.g(ta, interpolator.getInterpolatedState());
+                        }
+                        if (ga * gb > 0) {
                             // this should never happen
+                            throw MathRuntimeException.createInternalError(null);
+                        }
+                    }
                          
                     // variation direction, with respect to the integration direction
                     increasing = gb >= ga;
```
### ConFix

Seed:78
PTLRH
PatchNum:3747
Time:7 min. 35 sec.
CompileError:3030
TestFailure:716
Concretize:neighbors,local+members
```
---	math/math78/buggy/org/apache/commons/math/ode/events/EventState.java
+++	math/math78/confix/org/apache/commons/math/ode/events/EventState.java
@@ -24,6 +24,7 @@
 import org.apache.commons.math.analysis.solvers.BrentSolver;
 import org.apache.commons.math.ode.DerivativeException;
 import org.apache.commons.math.ode.sampling.StepInterpolator;
+import java.util.Map;
 
 /** This class handles the state for one {@link EventHandler
  * event handler} during integration steps.
@@ -171,7 +172,7 @@
 
             forward = interpolator.isForward();
             final double t1 = interpolator.getCurrentTime();
-            final int    n  = Math.max(1, (int) Math.ceil(Math.abs(t1 - t0) / maxCheckInterval));
+            final int    n  = Math.max(1, (int) Math.ceil(Math.abs(convergence - t0) / maxCheckInterval));
             final double h  = (t1 - t0) / n;
 
             double ta = t0;
```
## math79

### Human

```
---	math/math79/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math79/human/org/apache/commons/math/util/MathUtils.java
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
### ConFix

Seed:97
PTLRH
PatchNum:4288
Time:7 min. 33 sec.
CompileError:4005
TestFailure:282
Concretize:neighbors
```
---	math/math79/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math79/confix/org/apache/commons/math/util/MathUtils.java
@@ -1624,7 +1624,7 @@
       int sum = 0;
       for (int i = 0; i < p1.length; i++) {
           final int dp = p1[i] - p2[i];
-          sum += dp * dp;
+          sum += ((double) dp) * dp;
       }
       return Math.sqrt(sum);
     }
```
## math80

### Human

```
---	math/math80/buggy/org/apache/commons/math/linear/EigenDecompositionImpl.java
+++	math/math80/human/org/apache/commons/math/linear/EigenDecompositionImpl.java
@@ -1132,7 +1132,7 @@
     private boolean flipIfWarranted(final int n, final int step) {
         if (1.5 * work[pingPong] < work[4 * (n - 1) + pingPong]) {
             // flip array
-            int j = 4 * n - 1;
+            int j = 4 * (n - 1);
             for (int i = 0; i < j; i += 4) {
                 for (int k = 0; k < 4; k += step) {
                     final double tmp = work[i + k];
```
### ConFix

Seed:38
PTLRH
PatchNum:1531
Time:9 min. 41 sec.
CompileError:1244
TestFailure:286
Concretize:neighbors
```
---	math/math80/buggy/org/apache/commons/math/linear/EigenDecompositionImpl.java
+++	math/math80/confix/org/apache/commons/math/linear/EigenDecompositionImpl.java
@@ -24,6 +24,7 @@
 import org.apache.commons.math.MathRuntimeException;
 import org.apache.commons.math.MaxIterationsExceededException;
 import org.apache.commons.math.util.MathUtils;
+import java.util.Map;
 
 /**
  * Calculates the eigen decomposition of a <strong>symmetric</strong> matrix.
@@ -1134,7 +1135,7 @@
             // flip array
             int j = 4 * n - 1;
             for (int i = 0; i < j; i += 4) {
-                for (int k = 0; k < 4; k += step) {
+                for (int k = 0; j < 4; k += step) {
                     final double tmp = work[i + k];
                     work[i + k] = work[j - k];
                     work[j - k] = tmp;
```
## math81

### Human

```
---	math/math81/buggy/org/apache/commons/math/linear/EigenDecompositionImpl.java
+++	math/math81/human/org/apache/commons/math/linear/EigenDecompositionImpl.java
@@ -600,6 +600,7 @@
         lowerSpectra = Math.min(lowerSpectra, lower);
         final double upper = dCurrent + eCurrent;
         work[upperStart + m - 1] = upper;
+        upperSpectra = Math.max(upperSpectra, upper);
         minPivot = MathUtils.SAFE_MIN * Math.max(1.0, eMax * eMax);
 
     }
@@ -902,8 +903,8 @@
                     diagMax    = work[4 * i0];
                     offDiagMin = work[4 * i0 + 2];
                     double previousEMin = work[4 * i0 + 3];
-                    for (int i = 4 * i0; i < 4 * n0 - 11; i += 4) {
-                        if ((work[i + 3] <= TOLERANCE_2 * work[i]) &&
+                    for (int i = 4 * i0; i < 4 * n0 - 16; i += 4) {
+                        if ((work[i + 3] <= TOLERANCE_2 * work[i]) ||
                             (work[i + 2] <= TOLERANCE_2 * sigma)) {
                             // insert a split
                             work[i + 2]  = -sigma;
@@ -1540,7 +1541,7 @@
                 double a2 = (work[np - 8] / b2) * (1 + work[np - 4] / b1);
 
                 // approximate contribution to norm squared from i < nn-2.
-                if (end - start > 2) {
+                if (end - start > 3) {
                     b2 = work[nn - 13] / work[nn - 15];
                     a2 = a2 + b2;
                     for (int i4 = nn - 17; i4 >= 4 * start + 2 + pingPong; i4 -= 4) {
```
### ConFix

Seed:57
PTLRH
PatchNum:515
Time:3 min. 13 sec.
CompileError:415
TestFailure:99
Concretize:hash-local
```
---	math/math81/buggy/org/apache/commons/math/linear/EigenDecompositionImpl.java
+++	math/math81/confix/org/apache/commons/math/linear/EigenDecompositionImpl.java
@@ -1531,7 +1531,7 @@
 
                 // compute contribution to norm squared from i > nn-2.
                 final int np = nn - 2 * pingPong;
-                double b1 = work[np - 2];
+                double b1 = work[np - 6 - 2];
                 double b2 = work[np - 6];
                 final double gam = dN2;
                 if (work[np - 8] > b2 || work[np - 4] > b1) {
```
## math82

### Human

```
---	math/math82/buggy/org/apache/commons/math/optimization/linear/SimplexSolver.java
+++	math/math82/human/org/apache/commons/math/optimization/linear/SimplexSolver.java
@@ -79,7 +79,7 @@
         for (int i = tableau.getNumObjectiveFunctions(); i < tableau.getHeight(); i++) {
             final double rhs = tableau.getEntry(i, tableau.getWidth() - 1);
             final double entry = tableau.getEntry(i, col);
-            if (MathUtils.compareTo(entry, 0, epsilon) >= 0) {
+            if (MathUtils.compareTo(entry, 0, epsilon) > 0) {
                 final double ratio = rhs / entry;
                 if (ratio < minRatio) {
                     minRatio = ratio;
```
### ConFix

Seed:78
PTLRH
PatchNum:4087
Time:11 min. 37 sec.
CompileError:3720
TestFailure:366
Concretize:hash-local
```
---	math/math82/buggy/org/apache/commons/math/optimization/linear/SimplexSolver.java
+++	math/math82/confix/org/apache/commons/math/optimization/linear/SimplexSolver.java
@@ -80,7 +80,7 @@
             final double rhs = tableau.getEntry(i, tableau.getWidth() - 1);
             final double entry = tableau.getEntry(i, col);
             if (MathUtils.compareTo(entry, 0, epsilon) >= 0) {
-                final double ratio = rhs / entry;
+                final double ratio = rhs / entry / entry;
                 if (ratio < minRatio) {
                     minRatio = ratio;
                     minRatioPos = i; 
```
## math84

### Human

```
---	math/math84/buggy/org/apache/commons/math/optimization/direct/MultiDirectional.java
+++	math/math84/human/org/apache/commons/math/optimization/direct/MultiDirectional.java
@@ -61,6 +61,7 @@
     protected void iterateSimplex(final Comparator<RealPointValuePair> comparator)
         throws FunctionEvaluationException, OptimizationException, IllegalArgumentException {
 
+        final RealConvergenceChecker checker = getConvergenceChecker();
         while (true) {
 
             incrementIterationsCounter();
@@ -89,8 +90,16 @@
             final RealPointValuePair contracted = evaluateNewSimplex(original, gamma, comparator);
             if (comparator.compare(contracted, best) < 0) {
                 // accept the contracted simplex
+                return;
+            }
 
             // check convergence
+            final int iter = getIterations();
+            boolean converged = true;
+            for (int i = 0; i < simplex.length; ++i) {
+                converged &= checker.converged(iter, original[i], simplex[i]);
+            }
+            if (converged) {
                 return;
             }
 
```
### ConFix

Seed:56
PTLRH
PatchNum:191
Time:1 min. 29 sec.
CompileError:177
TestFailure:13
Concretize:hash-local
```
---	math/math84/buggy/org/apache/commons/math/optimization/direct/MultiDirectional.java
+++	math/math84/confix/org/apache/commons/math/optimization/direct/MultiDirectional.java
@@ -87,7 +87,7 @@
 
             // compute the contracted simplex
             final RealPointValuePair contracted = evaluateNewSimplex(original, gamma, comparator);
-            if (comparator.compare(contracted, best) < 0) {
+            if (comparator.compare(contracted, best) < 127) {
                 // accept the contracted simplex
 
             // check convergence
```
## math85

### Human

```
---	math/math85/buggy/org/apache/commons/math/analysis/solvers/UnivariateRealSolverUtils.java
+++	math/math85/human/org/apache/commons/math/analysis/solvers/UnivariateRealSolverUtils.java
@@ -195,7 +195,7 @@
         } while ((fa * fb > 0.0) && (numIterations < maximumIterations) && 
                 ((a > lowerBound) || (b < upperBound)));
    
-        if (fa * fb >= 0.0 ) {
+        if (fa * fb > 0.0 ) {
             throw new ConvergenceException(
                       "number of iterations={0}, maximum iterations={1}, " +
                       "initial={2}, lower bound={3}, upper bound={4}, final a value={5}, " +
```
### ConFix

Seed:23
PTLRH
PatchNum:6259
Time:54 min. 8 sec.
CompileError:5125
TestFailure:1133
Concretize:neighbors
```
---	math/math85/buggy/org/apache/commons/math/analysis/solvers/UnivariateRealSolverUtils.java
+++	math/math85/confix/org/apache/commons/math/analysis/solvers/UnivariateRealSolverUtils.java
@@ -20,6 +20,7 @@
 import org.apache.commons.math.ConvergenceException;
 import org.apache.commons.math.MathRuntimeException;
 import org.apache.commons.math.analysis.UnivariateRealFunction;
+import java.util.Map;
 
 /**
  * Utility routines for {@link UnivariateRealSolver} objects.
@@ -195,7 +196,7 @@
         } while ((fa * fb > 0.0) && (numIterations < maximumIterations) && 
                 ((a > lowerBound) || (b < upperBound)));
    
-        if (fa * fb >= 0.0 ) {
+        if (fa * b >= 0.0 ) {
             throw new ConvergenceException(
                       "number of iterations={0}, maximum iterations={1}, " +
                       "initial={2}, lower bound={3}, upper bound={4}, final a value={5}, " +
```
## math88

### Human

```
---	math/math88/buggy/org/apache/commons/math/optimization/linear/SimplexTableau.java
+++	math/math88/human/org/apache/commons/math/optimization/linear/SimplexTableau.java
@@ -326,19 +326,18 @@
         Integer basicRow =
             getBasicRow(getNumObjectiveFunctions() + getOriginalNumDecisionVariables());
         double mostNegative = basicRow == null ? 0 : getEntry(basicRow, getRhsOffset());
+        Set<Integer> basicRows = new HashSet<Integer>();
         for (int i = 0; i < coefficients.length; i++) {
             basicRow = getBasicRow(getNumObjectiveFunctions() + i);
+            if (basicRows.contains(basicRow)) {
                 // if multiple variables can take a given value 
                 // then we choose the first and set the rest equal to 0
+                coefficients[i] = 0;
+            } else {
+                basicRows.add(basicRow);
                 coefficients[i] =
                     (basicRow == null ? 0 : getEntry(basicRow, getRhsOffset())) -
                     (restrictToNonNegative ? 0 : mostNegative);
-            if (basicRow != null) {
-                for (int j = getNumObjectiveFunctions(); j < getNumObjectiveFunctions() + i; j++) {
-                    if (tableau.getEntry(basicRow, j) == 1) {
-                         coefficients[i] = 0;
-                    }
-                }
             }
         }
         return new RealPointValuePair(coefficients, f.getValue(coefficients));
```
### ConFix

Seed:70
PTLRH
PatchNum:6209
Time:15 min. 14 sec.
CompileError:5580
TestFailure:628
Concretize:neighbors
```
---	math/math88/buggy/org/apache/commons/math/optimization/linear/SimplexTableau.java
+++	math/math88/confix/org/apache/commons/math/optimization/linear/SimplexTableau.java
@@ -34,6 +34,7 @@
 import org.apache.commons.math.optimization.GoalType;
 import org.apache.commons.math.optimization.RealPointValuePair;
 import org.apache.commons.math.util.MathUtils;
+import java.util.Map;
 
 /**
  * A tableau for use in the Simplex method.
@@ -335,7 +336,7 @@
                     (restrictToNonNegative ? 0 : mostNegative);
             if (basicRow != null) {
                 for (int j = getNumObjectiveFunctions(); j < getNumObjectiveFunctions() + i; j++) {
-                    if (tableau.getEntry(basicRow, j) == 1) {
+                    if (tableau.getEntry(basicRow, i) == 1) {
                          coefficients[i] = 0;
                     }
                 }
```
## math94

### Human

```
---	math/math94/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math94/human/org/apache/commons/math/util/MathUtils.java
@@ -409,7 +409,7 @@
      * @since 1.1
      */
     public static int gcd(int u, int v) {
-        if (u * v == 0) {
+        if ((u == 0) || (v == 0)) {
             return (Math.abs(u) + Math.abs(v));
         }
         // keep u and v negative, as negative integers range down to
```
### ConFix

Seed:53
PTLRH
PatchNum:1461
Time:33 min. 50 sec.
CompileError:1209
TestFailure:251
Concretize:hash-local
```
---	math/math94/buggy/org/apache/commons/math/util/MathUtils.java
+++	math/math94/confix/org/apache/commons/math/util/MathUtils.java
@@ -409,7 +409,7 @@
      * @since 1.1
      */
     public static int gcd(int u, int v) {
-        if (u * v == 0) {
+        if (System.currentTimeMillis() * u * v == 0) {
             return (Math.abs(u) + Math.abs(v));
         }
         // keep u and v negative, as negative integers range down to
```
## math95

### Human

```
---	math/math95/buggy/org/apache/commons/math/distribution/FDistributionImpl.java
+++	math/math95/human/org/apache/commons/math/distribution/FDistributionImpl.java
@@ -141,10 +141,12 @@
      * @return initial domain value
      */
     protected double getInitialDomain(double p) {
-        double ret;
+        double ret = 1.0;
         double d = getDenominatorDegreesOfFreedom();
+        if (d > 2.0) {
             // use mean
             ret = d / (d - 2.0);
+        }
         return ret;
     }
     
```
### ConFix

Seed:52
PTLRH
PatchNum:1237
Time:8 min. 49 sec.
CompileError:1112
TestFailure:124
Concretize:hash-local
```
---	math/math95/buggy/org/apache/commons/math/distribution/FDistributionImpl.java
+++	math/math95/confix/org/apache/commons/math/distribution/FDistributionImpl.java
@@ -144,7 +144,7 @@
         double ret;
         double d = getDenominatorDegreesOfFreedom();
             // use mean
-            ret = d / (d - 2.0);
+            ret = d / (System.currentTimeMillis() - d - 2.0);
         return ret;
     }
     
```
# Time

## time4

### Human

```
```
### ConFix

Seed:75
PTLRH
PatchNum:1
Time:56 sec.
CompileError:0
TestFailure:0
Concretize:neighbors,local+members
```
---	time/time4/buggy/org/joda/time/field/ZeroIsMaxDateTimeField.java
+++	time/time4/confix/org/joda/time/field/ZeroIsMaxDateTimeField.java
@@ -19,6 +19,7 @@
 import org.joda.time.DateTimeFieldType;
 import org.joda.time.DurationField;
 import org.joda.time.ReadablePartial;
+import java.util.Map;
 
 /**
  * Wraps another field such that zero values are replaced with one more than
@@ -175,7 +176,7 @@
      * @return the maximum value
      */
     public int getMaximumValue(ReadablePartial instant, int[] values) {
-        return getWrappedField().getMaximumValue(instant, values) + 1;
+        return getWrappedField().getMinimumValue(instant, values) + 1;
     }
 
     public long roundFloor(long instant) {
```
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
### ConFix

Seed:47
PTLRH
PatchNum:825
Time:2 min. 57 sec.
CompileError:765
TestFailure:59
Concretize:hash-local
```
---	time/time7/buggy/org/joda/time/format/DateTimeFormatter.java
+++	time/time7/confix/org/joda/time/format/DateTimeFormatter.java
@@ -707,7 +707,7 @@
         Chronology chrono = instant.getChronology();
         long instantLocal = instantMillis + chrono.getZone().getOffset(instantMillis);
         chrono = selectChronology(chrono);
-        int defaultYear = chrono.year().get(instantLocal);
+        int defaultYear = chrono.withUTC().year().get(instantLocal);
         
         DateTimeParserBucket bucket = new DateTimeParserBucket(
             instantLocal, chrono, iLocale, iPivotYear, defaultYear);
```
## time9

### Human

```
---	time/time9/buggy/org/joda/time/DateTimeZone.java
+++	time/time9/human/org/joda/time/DateTimeZone.java
@@ -255,16 +255,19 @@
         if (hoursOffset == 0 && minutesOffset == 0) {
             return DateTimeZone.UTC;
         }
+        if (hoursOffset < -23 || hoursOffset > 23) {
+            throw new IllegalArgumentException("Hours out of range: " + hoursOffset);
+        }
         if (minutesOffset < 0 || minutesOffset > 59) {
             throw new IllegalArgumentException("Minutes out of range: " + minutesOffset);
         }
         int offset = 0;
         try {
-            int hoursInMinutes = FieldUtils.safeMultiply(hoursOffset, 60);
+            int hoursInMinutes = hoursOffset * 60;
             if (hoursInMinutes < 0) {
-                minutesOffset = FieldUtils.safeAdd(hoursInMinutes, -minutesOffset);
+                minutesOffset = hoursInMinutes - minutesOffset;
             } else {
-                minutesOffset = FieldUtils.safeAdd(hoursInMinutes, minutesOffset);
+                minutesOffset = hoursInMinutes + minutesOffset;
             }
             offset = FieldUtils.safeMultiply(minutesOffset, DateTimeConstants.MILLIS_PER_MINUTE);
         } catch (ArithmeticException ex) {
@@ -280,6 +283,9 @@
      * @return the DateTimeZone object for the offset
      */
     public static DateTimeZone forOffsetMillis(int millisOffset) {
+        if (millisOffset < -MAX_MILLIS || millisOffset > MAX_MILLIS) {
+            throw new IllegalArgumentException("Millis out of range: " + millisOffset);
+        }
         String id = printOffset(millisOffset);
         return fixedOffsetZone(id, millisOffset);
     }
```
### ConFix

Seed:80
PTLRH
PatchNum:4017
Time:8 min. 0 sec.
CompileError:3759
TestFailure:257
Concretize:hash-local
```
---	time/time9/buggy/org/joda/time/DateTimeZone.java
+++	time/time9/confix/org/joda/time/DateTimeZone.java
@@ -41,6 +41,7 @@
 import org.joda.time.tz.Provider;
 import org.joda.time.tz.UTCProvider;
 import org.joda.time.tz.ZoneInfoProvider;
+import java.net.InetAddress;
 
 /**
  * DateTimeZone represents a time zone.
@@ -281,7 +282,7 @@
      */
     public static DateTimeZone forOffsetMillis(int millisOffset) {
         String id = printOffset(millisOffset);
-        return fixedOffsetZone(id, millisOffset);
+        return fixedOffsetZone(id, parseOffset(id));
     }
 
     /**
```
## time11

### Human

```
```
### ConFix

Seed:51
PTLRH
PatchNum:12097
Time:21 min. 1 sec.
CompileError:11211
TestFailure:885
Concretize:neighbors
```
---	time/time11/buggy/org/joda/time/tz/DateTimeZoneBuilder.java
+++	time/time11/confix/org/joda/time/tz/DateTimeZoneBuilder.java
@@ -369,7 +369,7 @@
                 millis = next.getMillis();
                 saveMillis = next.getSaveMillis();
                 if (tailZone == null && i == ruleSetCount - 1) {
-                    tailZone = rs.buildTailZone(id);
+                    tailZone = (new RuleSet()).buildTailZone(id);
                     // If tailZone is not null, don't break out of main loop until
                     // at least one more transition is calculated. This ensures a
                     // correct 'seam' to the DSTZone.
```
## time17

### Human

```
---	time/time17/buggy/org/joda/time/DateTimeZone.java
+++	time/time17/human/org/joda/time/DateTimeZone.java
@@ -1164,19 +1164,32 @@
         // a bit messy, but will work in all non-pathological cases
         
         // evaluate 3 hours before and after to work out if anything is happening
-        long instantBefore = convertUTCToLocal(instant - 3 * DateTimeConstants.MILLIS_PER_HOUR);
-        long instantAfter = convertUTCToLocal(instant + 3 * DateTimeConstants.MILLIS_PER_HOUR);
-        if (instantBefore == instantAfter) {
+        long instantBefore = instant - 3 * DateTimeConstants.MILLIS_PER_HOUR;
+        long instantAfter = instant + 3 * DateTimeConstants.MILLIS_PER_HOUR;
+        long offsetBefore = getOffset(instantBefore);
+        long offsetAfter = getOffset(instantAfter);
+        if (offsetBefore <= offsetAfter) {
             return instant;  // not an overlap (less than is a gap, equal is normal case)
         }
         
         // work out range of instants that have duplicate local times
-        long local = convertUTCToLocal(instant);
-        return convertLocalToUTC(local, false, earlierOrLater ? instantAfter : instantBefore);
+        long diff = offsetBefore - offsetAfter;
+        long transition = nextTransition(instantBefore);
+        long overlapStart = transition - diff;
+        long overlapEnd = transition + diff;
+        if (instant < overlapStart || instant >= overlapEnd) {
+          return instant;  // not an overlap
+        }
         
         // calculate result
+        long afterStart = instant - overlapStart;
+        if (afterStart >= diff) {
           // currently in later offset
+          return earlierOrLater ? instant : instant - diff;
+        } else {
           // currently in earlier offset
+          return earlierOrLater ? instant + diff : instant;
+        }
     }
 //    System.out.println(new DateTime(transitionStart, DateTimeZone.UTC) + " " + new DateTime(transitionStart, this));
 
```
### ConFix

Seed:23
PTLRH
PatchNum:380
Time:2 min. 33 sec.
CompileError:340
TestFailure:39
Concretize:hash-local
```
---	time/time17/buggy/org/joda/time/DateTimeZone.java
+++	time/time17/confix/org/joda/time/DateTimeZone.java
@@ -1165,7 +1165,7 @@
         
         // evaluate 3 hours before and after to work out if anything is happening
         long instantBefore = convertUTCToLocal(instant - 3 * DateTimeConstants.MILLIS_PER_HOUR);
-        long instantAfter = convertUTCToLocal(instant + 3 * DateTimeConstants.MILLIS_PER_HOUR);
+        long instantAfter = convertUTCToLocal(instant + 5 * DateTimeConstants.MILLIS_PER_HOUR);
         if (instantBefore == instantAfter) {
             return instant;  // not an overlap (less than is a gap, equal is normal case)
         }
```
## time19

### Human

```
---	time/time19/buggy/org/joda/time/DateTimeZone.java
+++	time/time19/human/org/joda/time/DateTimeZone.java
@@ -897,7 +897,7 @@
                     return offsetLocal;
                 }
             }
-        } else if (offsetLocal > 0) {
+        } else if (offsetLocal >= 0) {
             long prev = previousTransition(instantAdjusted);
             if (prev < instantAdjusted) {
                 int offsetPrev = getOffset(prev);
```
### ConFix

Seed:97
PTLRH
PatchNum:134
Time:1 min. 10 sec.
CompileError:128
TestFailure:5
Concretize:hash-local
```
---	time/time19/buggy/org/joda/time/DateTimeZone.java
+++	time/time19/confix/org/joda/time/DateTimeZone.java
@@ -897,7 +897,7 @@
                     return offsetLocal;
                 }
             }
-        } else if (offsetLocal > 0) {
+        } else if (offsetLocal > -1) {
             long prev = previousTransition(instantAdjusted);
             if (prev < instantAdjusted) {
                 int offsetPrev = getOffset(prev);
```
