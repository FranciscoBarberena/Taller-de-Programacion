


{Una clínica necesita un sistema para el procesamiento de las atenciones realizadas a los pacientes durante el año 2023.

a) Implementar un módulo que lea información de las atenciones y retorne un vector donde se almacenen las atenciones agrupadas por mes.
Las atenciones de cada mes deben quedar almacenadas en un árbol binario de búsqueda ordenado por DNI del paciente y sólo deben almacenarse dni del paciente y código de diagnóstico.
De cada atención se lee: matrícula del médico, DNI del paciente, mes y diagnóstico (valor entre L y P). La lectura finaliza con matrícula 0.

b) Implementar un módulo recursivo que reciba el vector generado en a) y retorne el mes con mayor cantidad de atenciones.

c) Implementar un módulo que reciba el vector generado en a) y un DNI de paciente, y retorne si fue atendido o no, el paciente con el DNI ingresado.

NOTA: Implementar el programa principal, que invoque a los incisos a, b y c. En caso de ser necesario, puede utilizar los módulos que se encuentran a continuación.}

Program Examen2024N;

Const 
  fin = 0;
  DF = 12;

Type 
  meses = 1..12;
  atencion = Record
    matricula: integer;
    dni: integer;
    mes: integer;
    diagnostico: char;
  End;
  tipoArbol = Record
    dni : integer;
    diagnostico: char;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
  vector = array[meses] Of tree;
  contador = array[meses] Of integer;
Procedure leerAtencion(Var a : atencion);

Var v: array [1..5] Of char = ('L', 'M', 'N', 'O', 'P');
Begin
  a.matricula := Random(15);
  If (a.matricula <> fin) Then
    Begin
      a.dni := Random(5000) + 1000;
      a.mes := Random(12) + 1;
      a.diagnostico := v[Random(5) + 1];
    End;
End;

Procedure CrearRegistro(a : atencion; Var ar : tipoArbol);
Begin
  ar.dni := a.dni;
  ar.diagnostico := a.diagnostico;
End;

Procedure InicializarVector(Var v : vector);

Var 
  i : integer;
Begin
  For i:=1 To 12 Do
    v[i] := Nil;
End;

Procedure InicializarContador(Var v : contador);

Var 
  i : integer;
Begin
  For i:=1 To 12 Do
    v[i] := 0;
End;


Procedure Agregar(Var t : tree; a : tipoArbol);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.dni := a.dni;
      t^.dato.diagnostico := a.diagnostico;
      t^.hi := Nil;
      t^.hd := Nil;
    End
  Else If (a.dni<t^.dato.dni) Then agregar(t^.hi,a)
  Else agregar(t^.hd,a);
End;

Procedure CargarEstructuras (Var v : vector);

Var 
  a : atencion;
  ar : tipoArbol;
Begin
  InicializarVector(v);
  leerAtencion(a);
  While (a.matricula <> fin) Do
    Begin
      CrearRegistro(a,ar);
      Agregar(v[a.mes],ar);
      leerAtencion(a);
    End;
End;

Procedure ImprimirArbol(Var t : tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('DNI: ',t^.dato.dni);
      writeln('Diagnostico: ',t^.dato.diagnostico);
      ImprimirArbol(t^.hd);
    End;
End;
{b) Implementar un módulo recursivo que reciba el vector generado en a) y retorne el mes con mayor cantidad de atenciones.}

Function cantidadEnArbol(t : tree) : integer;
Begin
  If (t=Nil) Then
    cantidadEnArbol := 0
  Else cantidadEnArbol := 1 + cantidadEnArbol(t^.hi) + cantidadEnArbol(t^.hd);
End;

Function EncontrarMaximo(vc : contador) : integer;

Var 
  maxCant,i,auxMes : integer;
Begin
  maxCant := 0;
  auxMes := 0;
  For i:=1 To 12 Do
    Begin
      If (vc[i]>maxCant) Then
        Begin
          maxCant := vc[i];
          auxMes := i;
        End;
    End;
  EncontrarMaximo := auxMes
End;

Function maxMes (  v : vector; vc : contador; DL : integer) : integer;

Begin
  If (dl<>0)Then
    Begin
      If (v[dl] <> Nil) Then
        vc[dl] := cantidadEnArbol(v[dl]);
      maxMes := maxMes(v,vc,dl-1);
    End
  Else maxMes := EncontrarMaximo(vc);

End;

Function arbolesVacios(v:vector) : boolean;

Var i : integer;
  aux : boolean;
Begin
  i := 1;
  aux := true;
  While (aux) And (i<=DF) Do
    Begin
      If (v[i]<>Nil) Then aux := false;
      i := i+1;
    End;
  arbolesVacios := aux;
End;
{c) Implementar un módulo que reciba el vector generado en a) y un DNI de paciente, y retorne si fue atendido o no, el paciente con el DNI ingresado.}


Function estaEnElArbol(t : tree; dni : integer) : boolean;
Begin
  If (t=Nil) Then estaEnElArbol := false
  Else If (dni<t^.dato.dni) Then estaEnElArbol := estaEnElArbol(t^.hi,dni)
  Else If (dni>t^.dato.dni) Then estaEnElArbol := estaEnElArbol(t^.hd,dni)
  Else estaEnElArbol := true;
End;

Function estaDni (v:vector; DNI : integer) : boolean;

Var i : integer;
  aux : boolean;
Begin
  aux := false;
  i := 1;
  While (Not aux) And (i<=DF) Do
    Begin
      aux := estaEnElArbol(v[i],dni);
      i := i+1;
    End;
  estaDni := aux;
End;

Var 
  v : vector;
  i : integer;
  vc: contador;
  dni : integer;
Begin
  randomize;
  CargarEstructuras(v);
  If (arbolesVacios(v)) Then
    writeln('Error: todos los arboles estan vacios')
  Else
    Begin
      InicializarContador(vc);
      For i:=1 To 12 Do
        Begin
          writeln('ATENCIONES DEL MES ',i);
          ImprimirArbol(v[i]);
        End;
      writeln('El mes con mayor cantidad de atenciones fue: ',maxMes(v,vc,DF));
      write('Ingresar DNI a buscar: ');
      readln(DNI);
      writeln('El DNI ',dni, ' esta en el vector? ',estaDni(v,dni));
    End;
End.
