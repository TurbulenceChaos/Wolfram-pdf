file = $ScriptCommandLine[[2]];

dir = DirectoryName[file];

fileName = FileBaseName[file];

(* Get the currently evaluating cells in the notebook *)

notebookEvaluatingCells[nb_] :=
    Select[Cells[nb], "Evaluating" /. Developer`CellInformation[#]&];

(* Check if the notebook is still evaluating *)

notebookEvaluatingQ[nb_] :=
    Length[notebookEvaluatingCells[nb]] > 0;

(* Pause until evaluation is finished *)

notebookPauseForEvaluation[nb_] :=
    While[notebookEvaluatingQ[nb], Print["..."] Pause[0.25]];

(* Import script as a list of deferred expressions *)

exprs = Import[file, "HeldExpressions"] /. HoldComplete -> Defer;

(* Convert expressions into notebook cells *)

cells =
    Function[e,
            ExpressionCell[e, "Input"]
        ] /@ exprs;

cells = Join[{TextCell[fileName <> ".wl", "Title"]}, cells];

UsingFrontEnd[
    nb = CreateDocument[cells];
    SelectionMove[nb, All, Notebook];
    SelectionEvaluate[nb];
    notebookPauseForEvaluation[nb];
    (* Export the notebook as CDF and PDF files *)
    Export[dir <> fileName <> #, nb]& /@ {".cdf", ".pdf"};
    NotebookClose[nb];
];
