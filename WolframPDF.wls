FilePath = $ScriptCommandLine[[2]]

DirectoryPath = DirectoryName[FilePath]

FileName = FileBaseName[FilePath]

(* Check if the notebook is still evaluating *)

notebookEvaluatingQ[nb_] :=
    Length[notebookEvaluatingCells[nb]] > 0

$InputFileName

(* Get the currently evaluating cells in the notebook *)

notebookEvaluatingCells[nb_] :=
    Select[Cells[nb], "Evaluating" /. Developer`CellInformation[#]&]

(* Pause until evaluation is finished *)

notebookPauseForEvaluation[nb_] :=
    Module[{},
        While[notebookEvaluatingQ[nb], Print["..."] Pause[0.25]]
    ]

(* Import script as a text string *)

text = Import[FilePath, "Text"];

UsingFrontEnd[
    (* Make the cells into an in-memory notebook *)nb =
        CreateDocument[
            {
                (* This is for the eyes *)TextCell["Testing .wls Scripts",
                     "Title"], Cell[text, "Input"]
            }
        ];
    (* Select all cells and evaluate them *)
    SelectionMove[nb, All, Notebook];
    SelectionEvaluate[nb];
    (* Function to check if the notebook is still evaluating *)
    notebookPauseForEvaluation[nb]
        (* Save the notebook to a file and export it as a PDF *) NotebookSave[
            nb, DirectoryPath <> FileName <> ".nb"];
    Do[Export[DirectoryPath <> FileName <> Type, nb], {Type, {".nb", 
        ".pdf"}}];
    NotebookClose[nb]
]
