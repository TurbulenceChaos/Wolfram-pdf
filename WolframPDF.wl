file = $ScriptCommandLine[[2]];

dir = DirectoryName[file];

fileName = FileBaseName[file];

(* Check if the notebook is still evaluating *)

notebookEvaluatingQ[nb_] :=
    Length[notebookEvaluatingCells[nb]] > 0;

(* Get the currently evaluating cells in the notebook *)

notebookEvaluatingCells[nb_] :=
    Select[Cells[nb], "Evaluating" /. Developer`CellInformation[#]&];

(* Pause until evaluation is finished *)

notebookPauseForEvaluation[nb_] :=
    While[notebookEvaluatingQ[nb], Print["..."] Pause[0.25]];

(* Import script as a text string *)

text = Import[file, "Text"];

UsingFrontEnd[
    nb = CreateDocument[{TextCell[fileName <> ".wl script", "Title"],
         Cell[text, "Input"]}];
    SelectionMove[nb, All, Notebook];
    SelectionEvaluate[nb];
    notebookPauseForEvaluation[nb];
    NotebookSave[nb, dir <> fileName <> ".nb"];
    Export[dir <> fileName <> ".nb", nb];
    Export[dir <> fileName <> ".pdf", nb];
    NotebookClose[nb];
];
