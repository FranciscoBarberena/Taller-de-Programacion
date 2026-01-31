

{1. El administrador de un edificio de oficinas tiene la información del pago de las expensas
de dichas oficinas. Implementar un programa con:
a) Un módulo que retorne un vector, sin orden, con a lo sumo las 300 oficinas que
administra. Se deben cargar, para cada oficina, el código de identificación, DNI del
propietario y valor de la expensa. La lectura finaliza cuando llega el código de
identificación 0.
b) Un módulo que reciba el vector retornado en a) y retorne dicho vector ordenado por
código de identificación de la oficina. Ordenar el vector aplicando uno de los métodos
vistos en la cursada.
c) Un módulo que realice una búsqueda dicotómica. Este módulo debe recibir el vector
generado en b) y un código de identificación de oficina. En caso de encontrarlo, debe
retornar la posición del vector donde se encuentra y en caso contrario debe retornar 0.
Luego el programa debe informar el DNI del propietario o un cartel indicando que no
se encontró la oficina.
d) Un módulo recursivo que retorne el monto total acumulado de las expensas.}

Program actividad1;

Const 
  fin = 0;
  DF = 300;

Type 
  indice = 0..DF;
  office = Record
    code : integer;
    DNI : integer;
    expensas : real;
  End;
  vector = array [1..DF] Of office;
Procedure LeerOficina(Var o : office);
Begin
  writeln('Ingresar codigo: ');
  readln(o.code);
  If (o.code <> fin ) Then
    Begin
      writeln('Ingresar DNI: ');
      readln(o.dni);
      writeln('Ingresar valor de las expensas: ');
      readln(o.expensas);
    End;
End;
Procedure CargarVector (Var v : vector; Var DL : indice);

Var o : office;
Begin
  LeerOficina(o);
  While (o.code <> fin) And (DL<DF) Do
    Begin
      dl := dl+1;
      v[dl] := o;
      If (dl<df) Then
        LeerOficina(o);
    End;
End;

Procedure OrdenarVectorSeleccion(Var v : vector; dl : indice);

Var i,j,pos : integer;
  aux : office;
Begin
  For i:=1 To DL-1 Do
    Begin
      pos := i;
      For j:=i+1 To DL Do
        If (v[pos].code>v[j].code) Then
          pos := j;
      aux := v[pos];
      v[pos] := v[i];
      v[i] := aux;
    End;

End;




{c) Un módulo que realice una búsqueda dicotómica. Este módulo debe recibir
el vector
generado en b) y un código de identificación de oficina. En caso de
encontrarlo, debe
retornar la posición del vector donde se encuentra y en caso contrario debe
retornar 0.
Luego el programa debe informar el DNI del propietario o un cartel indicando que
no
se encontró la oficina.}

Function BusquedaDicotomica (v : vector;dl,code : integer): integer;

Var 
  medio : integer;
Begin
  If (dl>0)  Then
    Begin
      medio := (DL Div 2)+1;
      If (v[medio].code<code) Then
        Begin
          medio := ((medio+dl)Div 2)+ 1;
          BusquedaDicotomica := BusquedaDicotomica(v,dl Div 2,code);
        End
      Else If (v[medio].code>code) Then
             Begin
               medio := ((dl-medio)Div 2)-1;
               BusquedaDicotomica := BusquedaDicotomica(v,dl Div 2,code);
             End
      Else BusquedaDicotomica := medio;
    End
  Else BusquedaDicotomica := 0;
End;


Procedure ImprimirVector(v: vector; dl : indice);

Var 
  i : integer;
Begin
  For i:=1 To dl Do
    writeln(v[i].code);
End;

Function totalExpensas(v : vector; dl : indice) : real;
Begin
  If (dl>0) Then
    Begin
      totalExpensas := v[dl].expensas+totalExpensas(v,dl-1);
    End;
End;

Var 
  dl : indice;
  v : vector;
  code : integer;
Begin
  CargarVector(v,dl);
  OrdenarVectorSeleccion(v,dl);
  if (dl<>0) then begin
    ImprimirVector(v,dl);
    writeln('Ingresar codigo a buscar: ');
    readln(code);
    If (BusquedaDicotomica(v,dl,code) <> 0) Then
      writeln('DNI: ',v[BusquedaDicotomica(v,dl,code)].DNI)
    Else
      writeln('No se encontro el codigo');
    writeln('El total de expensas fue: ',totalExpensas(v,dl):0:2);
  end else writeln('Vector vacio');
End.
