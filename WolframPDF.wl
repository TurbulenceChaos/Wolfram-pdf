(* Options suggested by https://mathematica.stackexchange.com/a/133058/95308 *)

SetOptions[First[$Output], FormatType -> StandardForm];

(* Import script as a list of deferred expressions *)

file = $ScriptCommandLine[[2]];

exprs = Import[file, "HeldExpressions"];

(* Convert expressions into notebook cells *)

(* Defer manipulate: https://community.wolfram.com/groups/-/m/t/37054 *)

cells =
    Function[expr,
            If[StringContainsQ[ToString[expr], "Manipulate"],
                With[{expr = expr /. HoldComplete -> ReleaseHold},
                    ExpressionCell[
                        Block[{BoxForm`$UseTextFormattingWhenEvaluating
                             = True},
                            RawBoxes[MakeBoxes[expr]]
                        ]
                        ,
                        "Input"
                    ]
                ]
                ,
                With[{expr = expr /. HoldComplete -> Defer},
                    ExpressionCell[expr, "Input"]
                ]
            ]
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
