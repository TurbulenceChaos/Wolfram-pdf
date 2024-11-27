(* Options suggested by https://mathematica.stackexchange.com/a/133058/95308 *)

SetOptions[First[$Output], FormatType -> StandardForm];

(* Import script as a list of deferred expressions *)

file = $ScriptCommandLine[[2]];

exprs = Import[file, "HeldExpressions"] /. HoldComplete -> Defer;

(* Convert expressions into notebook cells *)

cells =
    Function[e,
            ExpressionCell[e, "Input"]
        ] /@ exprs;

cells = Join[{TextCell[FileNameTake @ file, "Title"]}, cells];

UsingFrontEnd[
    nb = CreateDocument[cells];
    NotebookEvaluate[nb, InsertResults -> True];
    Export[StringDrop[file, -StringLength @ FileExtension @ file] <> 
        #, nb]& /@ {"cdf", "pdf"};
    NotebookClose[nb];
];

(* If you use wolfram -f WolframPDF.wl "file.wl", add this line to stop frontend *)

Developer`UninstallFrontEnd[]
