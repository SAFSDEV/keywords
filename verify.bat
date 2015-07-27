@echo off
echo "This will simply verify all of the xml files to see if there are any glaring"
echo "  errors, like no end tag, or problems with matching tags, etc."
echo "Note: make sure either ant.jar or another DOM parser is in your CLASSPATH"
echo "Note: change c:/src in this script to point to IndentingParser.class"
set localCP="c:/src;%CLASSPATH%"
set TMP_OUTFILE= ".tmp_outfile.xml"
set lib_DTD="keyword_library.dtd"
if exist %lib_DTD% goto dtdok
echo "ERROR: must have DTD: %lib_DTD% in same directory"
goto done
:dtdok
echo "The temporary output file is: %TMP_OUTFILE%"
if not exist %TMP_OUTFILE% goto over
del %TMP_OUTFILE%
:over
echo "" >%TMP_OUTFILE%
echo CheckBoxFunctions.xml
java -classpath %localCP% IndentingParser CheckBoxFunctions.xml >>%TMP_OUTFILE%
echo ComboBoxFunctions.xml
java -classpath %localCP% IndentingParser ComboBoxFunctions.xml >>%TMP_OUTFILE%
echo ComboEditBoxFunctions.xml
java -classpath %localCP% IndentingParser ComboEditBoxFunctions.xml >>%TMP_OUTFILE%
echo ComboListBoxFunctions.xml
java -classpath %localCP% IndentingParser ComboListBoxFunctions.xml >>%TMP_OUTFILE%
echo CustomTestCommands.xml
java -classpath %localCP% IndentingParser CustomTestCommands.xml >>%TMP_OUTFILE%
echo DDDriverCommands.xml
java -classpath %localCP% IndentingParser DDDriverCommands.xml >>%TMP_OUTFILE%
echo DDDriverCounterCommands.xml
java -classpath %localCP% IndentingParser DDDriverCounterCommands.xml >>%TMP_OUTFILE%
echo DDDriverDebugCommands.xml
java -classpath %localCP% IndentingParser DDDriverDebugCommands.xml >>%TMP_OUTFILE%
echo DDDriverDeprecatedCommands.xml
java -classpath %localCP% IndentingParser DDDriverDeprecatedCommands.xml >>%TMP_OUTFILE%
echo DDDriverFileCommands.xml
java -classpath %localCP% IndentingParser DDDriverFileCommands.xml >>%TMP_OUTFILE%
echo DDDriverFlowCommands.xml
java -classpath %localCP% IndentingParser DDDriverFlowCommands.xml >>%TMP_OUTFILE%
echo DDDriverLogCommands.xml
java -classpath %localCP% IndentingParser DDDriverLogCommands.xml >>%TMP_OUTFILE%
echo DDDriverStringCommands.xml
java -classpath %localCP% IndentingParser DDDriverStringCommands.xml >>%TMP_OUTFILE%
echo DDDriverDatabaseCommands.xml
java -classpath %localCP% IndentingParser DDDriverDatabaseCommands.xml>>%TMP_OUTFILE%
echo DatabaseFunctions.xml
java -classpath %localCP% IndentingParser DatabaseFunctions.xml >>%TMP_OUTFILE%
echo EditBoxFunctions.xml
java -classpath %localCP% IndentingParser EditBoxFunctions.xml >>%TMP_OUTFILE%
echo GenericMasterFunctions.xml
java -classpath %localCP% IndentingParser GenericMasterFunctions.xml >>%TMP_OUTFILE%
echo GenericObjectFunctions.xml
java -classpath %localCP% IndentingParser GenericObjectFunctions.xml >>%TMP_OUTFILE%
echo GraphicControlFunctions.xml
java -classpath %localCP% IndentingParser GraphicControlFunctions.xml >>%TMP_OUTFILE%
echo HTMLDocumentFunctions.xml
java -classpath %localCP% IndentingParser HTMLDocumentFunctions.xml >>%TMP_OUTFILE%
echo HTMLFunctions.xml
java -classpath %localCP% IndentingParser HTMLFunctions.xml >>%TMP_OUTFILE%
echo HTMLImageFunctions.xml
java -classpath %localCP% IndentingParser HTMLImageFunctions.xml >>%TMP_OUTFILE%
echo HTMLLinkFunctions.xml
java -classpath %localCP% IndentingParser HTMLLinkFunctions.xml >>%TMP_OUTFILE%
echo HTMLTableFunctions.xml
java -classpath %localCP% IndentingParser HTMLTableFunctions.xml >>%TMP_OUTFILE%
echo JavaMenuFunctions.xml
java -classpath %localCP% IndentingParser JavaMenuFunctions.xml >>%TMP_OUTFILE%
echo JavaTableFunctions.xml
java -classpath %localCP% IndentingParser JavaTableFunctions.xml >>%TMP_OUTFILE%
echo JavaTreeFunctions.xml
java -classpath %localCP% IndentingParser JavaTreeFunctions.xml >>%TMP_OUTFILE%
echo LabelFunctions.xml
java -classpath %localCP% IndentingParser LabelFunctions.xml >>%TMP_OUTFILE%
echo ListBoxFunctions.xml
java -classpath %localCP% IndentingParser ListBoxFunctions.xml >>%TMP_OUTFILE%
echo ListViewFunctions.xml
java -classpath %localCP% IndentingParser ListViewFunctions.xml >>%TMP_OUTFILE%
echo PopupMenuFunctions.xml
java -classpath %localCP% IndentingParser PopupMenuFunctions.xml >>%TMP_OUTFILE%
echo PushButtonFunctions.xml
java -classpath %localCP% IndentingParser PushButtonFunctions.xml >>%TMP_OUTFILE%
echo RadioButtonFunctions.xml
java -classpath %localCP% IndentingParser RadioButtonFunctions.xml >>%TMP_OUTFILE%
echo SSTreeFunctions.xml
java -classpath %localCP% IndentingParser SSTreeFunctions.xml >>%TMP_OUTFILE%
echo ScrollBarFunctions.xml
java -classpath %localCP% IndentingParser ScrollBarFunctions.xml >>%TMP_OUTFILE%
echo TabControlFunctions.xml
java -classpath %localCP% IndentingParser TabControlFunctions.xml >>%TMP_OUTFILE%
echo TableViewFunctions.xml
java -classpath %localCP% IndentingParser TableViewFunctions.xml >>%TMP_OUTFILE%
echo ToolBarFunctions.xml
java -classpath %localCP% IndentingParser ToolBarFunctions.xml >>%TMP_OUTFILE%
echo TreeViewFunctions.xml
java -classpath %localCP% IndentingParser TreeViewFunctions.xml >>%TMP_OUTFILE%
echo VSFlexGridFunctions.xml
java -classpath %localCP% IndentingParser VSFlexGridFunctions.xml >>%TMP_OUTFILE%
echo WindowFunctions.xml
java -classpath %localCP% IndentingParser WindowFunctions.xml >>%TMP_OUTFILE%
:done
