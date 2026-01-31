
{3.- Implementar un programa que invoque a los siguientes módulos.
a. Un módulo recursivo que retorne un vector de 20 números enteros “random” mayores a 300
y menores a 1550 (incluidos ambos).
b. Un módulo que reciba el vector generado en a) y lo retorne ordenado. (Utilizar lo realizado
en la práctica anterior)
c. Un módulo que realice una búsqueda dicotómica en el vector, utilizando el siguiente
encabezado:
Procedure busquedaDicotomica (v: vector; ini,fin: indice; dato:integer; var pos: indice);
Nota: El parámetro “pos” debe retornar la posición del dato o -1 si el dato no se encuentra
en el vector.}

Program Actividad3;

Const 
  DF = 20;
  max = 1550;
  min = 300;

Type 
  indice = -1..DF;
  vector = array[1..DF] Of integer;
Procedure CargarVector(Var v : vector; i : integer);

Var 
  num : integer;
Begin
  If (i<=DF) Then
    Begin
      num := random(1550-300-1)+300;
      v[i] := num;
      CargarVector(v,i+1);
    End;
End;
Procedure OrdenarVector(Var v : vector);


Var 
  i,j,pos : integer;
  elemento : integer;
Begin
  For i:=1 To Df - 1 Do
    Begin
      pos := i;
      For j:=i+1 To df Do
        If (V[j]<V[pos]) Then
          pos := j;
      elemento := v[pos];
      v[pos] := v[i];
      v[i] := elemento;
    End;
End;

Procedure ImprimirVector(v:vector);

Var 
  i : integer;
Begin
  For i:=1 To DF Do
    writeln(i,': ',V[i]);
End;


Procedure busquedaDicotomica (v: vector; ini,fin: integer; dato:integer; Var pos
                              :integer);

Var 
  medio : integer;
Begin
  If (pos<>-1) Then
    Begin
      medio := (fin+ini) Div 2;

      If (dato>v[medio]) Then
        Begin
          If (ini>=fin) Then
            pos := -1;
          busquedaDicotomica (v, medio + 1,fin, dato,  pos)
        End
      Else If (dato = v[medio]) Then
             pos := medio
      Else
        Begin
          If (ini>=fin) Then
            pos := -1;
          busquedaDicotomica (v, ini,medio -1, dato,  pos);
        End;
    End;
End;

Var 
  v : vector;
  ini,fin, pos : integer;
  dato : integer;
Begin
  randomize;
  pos := 1;
  CargarVector(v,pos);
  pos := -2;
  ini := 1;
  fin := df;
  OrdenarVector(v);
  ImprimirVector(v);
  write('Numero a buscar: ');
  read(dato);
  busquedaDicotomica(v,ini,fin,dato,pos);
  If (pos<>-1) Then
    writeln(pos,': ',v[pos])
  Else writeln('El elemento no esta en el vector');
End.
