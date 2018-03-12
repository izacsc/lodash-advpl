#translate import lodash [as <id>] => Static lodashversion := u__(<id>)

// Syntatic Sugar
#xtranslate Function[([<prm,...>])]-><expr,...> => { |[<prm>]| <expr> }
#xtranslate Eval <blockName>([<prm,...>])=> Eval(<blockName> [, <prm>])
#xtranslate If <expr> ? <true> : <false> => If(<expr>, <true>, <false>)

//translate to make dynamic arguments an array
#translate _:concat(<value>, [<prm,...>]) => _:concatenate(<value>, {[<prm>]})