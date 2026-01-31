

{3. Implementar un programa que contenga:
a. Un módulo que lea información de los finales rendidos por los alumnos de la Facultad de
Informática y los almacene en una estructura de datos. La información que se lee es legajo,
código de materia, fecha y nota. La lectura de los alumnos finaliza con legajo 0. La estructura
generada debe ser eficiente para la búsqueda por número de legajo y para cada alumno deben
guardarse los finales que rindió en una lista.
b. Un módulo que reciba la estructura generada en a. y retorne la cantidad de alumnos con
legajo impar.
c. Un módulo que reciba la estructura generada en a. e informe, para cada alumno, su legajo y
su cantidad de finales aprobados (nota mayor o igual a 4).
c. Un módulo que reciba la estructura generada en a. y un valor real. Este módulo debe
retornar los legajos y promedios de los alumnos cuyo promedio supera el valor ingresado}

Program actividad3;

Const 
  fin = 0;
  notaAprobado = 4;

Type 
  dias = 1..31;
  meses = 1..12;
  anos = 1800..2025;
  fechas = Record
    d : dias;
    m : meses;
    y : anos;
  End;
  finales = Record
    code : integer;
    date : fechas;
    grade : real;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : finales;
    sig : lista;
  End;
  datoArbol = Record
    legajo : integer;
    listaFinales : lista;
  End;
  tree = ^nodo;
  nodo = Record
    dato : datoArbol;
    hi : tree;
    hd : tree;
  End;
  PromedioLegajo = Record
    avg : real;
    legajo : integer;
  End;
  listaPromedios = ^nodoListaPromedios;
  nodoListaPromedios = Record
    dato : PromedioLegajo;
    sig : listaPromedios;
  End;

Procedure LeerExamen(Var f : finales; Var legajo : integer);
Begin
  writeln('Ingresar legajo: ');
  readln(legajo);
  If (legajo <> fin) Then
    Begin
      writeln('Ingresar dia: ');
      readln(f.date.d);
      writeln('Ingresar mes: ');
      readln(f.date.m);
      writeln('Ingresar ano: ');
      readln(f.date.y);
      writeln('Ingresar nota: ');
      readln(f.grade);
      writeln('Ingresar codigo de materia: ');
      readln(f.code);
    End;
End;
Procedure AgregarAdelante(Var l : lista;f : finales);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := f;
  aux^.sig := l;
  l := aux;
End;
Procedure AgregarAdelante2(Var l : listaPromedios ;pl : PromedioLegajo);

Var aux : listaPromedios;
Begin
  new(aux);
  aux^.dato := pl;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar (Var t : tree; f : finales; legajo : integer);
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.hd := Nil;
      t^.hi := Nil;
      t^.dato.listaFinales := Nil;
      t^.dato.legajo := legajo;
      AgregarAdelante(t^.dato.listaFinales,f);
    End
  Else If (legajo<t^.dato.legajo) Then Agregar(t^.hi,f,legajo)

  Else If (legajo>t^.dato.legajo) Then Agregar(t^.hd,f,legajo)
  Else AgregarAdelante(t^.dato.listaFinales,f);
End;
Procedure CargarArbol(Var t : tree);

Var 
  f : finales;
  legajo : integer;
Begin
  t := Nil;
  LeerExamen(f,legajo);
  While (legajo <> fin) Do
    Begin
      Agregar(t,f,legajo);
      LeerExamen(f,legajo);
    End;
End;

Function EsImpar(num : integer) : boolean;
Begin
  If (num Mod 2 =1) Then
    EsImpar := true
  Else EsImpar := false;
End;
Function cantidadLegajoImpar (t : tree; aux : integer) : integer;
Begin
  If (t<>Nil) Then
    Begin
      cantidadLegajoImpar := cantidadLegajoImpar(t^.hd,aux);
      If EsImpar(t^.dato.legajo) Then
        aux := aux+1;
      cantidadLegajoImpar := cantidadLegajoImpar(t^.hi,aux);
    End
  Else
    cantidadLegajoImpar := aux;
End;

Function ElementosEnListaMayoresQueN(l : lista; n : real) : integer;

Var aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      If (l^.dato.grade >= n) Then
        aux := aux +1;
      l := l^.sig;
    End;
  ElementosEnListaMayoresQueN := aux;
End;
Procedure InformarAprobados (t : tree);
Begin
  If (t<>Nil) Then
    Begin
      InformarAprobados(t^.hi);
      writeln('La cantidad de examenes aprobados de ',t^.dato.legajo,' es: ',
              ElementosEnListaMayoresQueN(t^.dato.listaFinales,notaAprobado));
      InformarAprobados(t^.hd);
    End;
End;




Function PromedioDeLista(l : lista) : real;

Var auxTot : real;
  auxCant : integer;
Begin
  auxTot := 0;
  auxCant := 0;
  While (l<>Nil) Do
    Begin
      auxCant := auxCant+1;
      auxTot := auxTot + l^.dato.grade;
      l := l^.sig;
    End;
  PromedioDeLista := auxTot/auxCant;
End;
Procedure LegajosConMayorPromedioQueN (t : tree; n : real; Var l :listaPromedios
);

Var PL : PromedioLegajo;
Begin
  If (t<>Nil) Then
    Begin
      LegajosConMayorPromedioQueN(t^.hi,n,l);
      If (PromedioDeLista(t^.dato.listaFinales)>n) Then
        Begin
          pl.avg := PromedioDeLista(t^.dato.listaFinales);
          pl.legajo := t^.dato.legajo;
          AgregarAdelante2(l,pl);
        End;
      LegajosConMayorPromedioQueN(t^.hd,n,l);
    End;
End;
Procedure ImprimirLista(l:listaPromedios);
Begin
  While (l<>Nil) Do
    Begin
      writeln('- Legajo: ',l^.dato.legajo);
      writeln('- Promedio: ',l^.dato.avg:0:2);
      l := l^.sig;
    End;
End;

Var 
  t : tree;
  l : listaPromedios;
  aux : integer;
  n : real;
Begin
  aux := 0;
  l := Nil;
  CargarArbol(t);
  writeln('Cantidad de alumnos con legajos impares: ', cantidadLegajoImpar(t,aux
  ));
  InformarAprobados(t);
  writeln(



'Ingresar valor del que se desea generar una lista de alumnos con mayor promedio que el: '
  );
  readln(n);
  LegajosConMayorPromedioQueN(t,n,l);
  If (l=Nil) Then writeln('No hay alumnos con mayor promedio que ',n:0:2)
  Else
    Begin
      writeln('Lista de alumnos con mayor promedio que ',n:0:2,': ');
      ImprimirLista(l);
    End;
End.
