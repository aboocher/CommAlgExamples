
needsPackage "Nauty"

--- populate takes a hash table and adds a new key ``name'' and 
--- evaluates a function on the ideal and stores the output as value
populate = method()
populate(Function, String, MutableHashTable) :=  (attribute, name, T) -> (
    (T#name = attribute(T#"ideal"));
    )


--- I'm not sure how to keep track of the header file?  At the moment we just
--- extract the keys from any entry since they'll all be the same.
header = method();
header(MutableHashTable) := (T) -> (str = ""; 
    for k from 0 to #keys T -2 do (str = str | ("\""|(toString (keys T)#k)|"\","));
    str = str|"\""|(toString (last keys T))|"\"\n"
    )

toCSVEntry = (T) -> (
    str = "";
    for k from 0 to #keys T -2 do (str = str | ("\""|toString (T#((keys T)_2))|"\","));
    str = str|"\""|(toString (last values T))|"\"\n"
    )

end

restart
load "Examples.m2"

R = QQ[a..e]
L = generateGraphs R
listOfIdeals = delete({},L/(i-> i#"edges")/(i-> i/product)/ideal/(i-> i_*))

H = new MutableHashTable from {}

for I in listOfIdeals do (
    H#I = new MutableHashTable from {("ideal", ideal I)} )

for k in keys H do populate(codim, "codim", H#k);
for k in keys H do populate(regularity, "regularity", H#k);
for k in keys H do populate(i-> length res i , "pdim", H#k);
for k in keys H do populate(degree , "degree", H#k);

--- the code below will write the contents of the hash table to exampleDB.csv

f = openOut("exampleDB.csv")
f << header(first values H) 
for k in values H do (
   f << toCSVEntry k;
   )
close(f)

