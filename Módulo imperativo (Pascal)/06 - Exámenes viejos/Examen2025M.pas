{Se leen atenciones. De cada atencion se lee matricula de odontologo, DNI del paciente, dia y diagnostico [1..10]. Finaliza con dni 0}

{a) Implementar un modulo que lea atenciones, y retorne un arbol ordenado por matricula. Para cada matricula se almacena una lista de las atenciones realizadas}



{b) Implementar un modulo que reciba el arbol , 2 matriculas y un DNI. Debe retornar la cantidad total de atenciones realizadas por odontologos entre las 2 matriculas al paciente con DNI ingresado (sin incluir}

{c) Realizar un modulo que reciba el arbol y retorne, para cada diagnostico, la cantidad de atenciones realizadas}

Program Examen2025M;

Const 
  cantDiagnostico = 10;
  fin = 0;
  cantDias = 30;

Type 
  diagnosticos = 1..cantDiagnostico;
  dias = 1..cantDias;
  atencion = Record
    matricula : integer;
    dni : integer;
    dia : dias;
    diagnostico: diagnosticos;
  End;
  atencion_reducida = Record
    dni : integer;
    dia : dias;
    diagnostico: diagnosticos;
  End;
  lista = ^nodoLista;
  nodoLista = Record
    dato : atencion_reducida;
    sig : lista;
  End;
  tipoArbol = Record
    listaMatricula : lista;
    matricula: integer;
  End;
  tree = ^nodo;
  nodo = Record
    dato : tipoArbol;
    hi : tree;
    hd : tree;
  End;
  contador = array[diagnosticos] Of integer;
Procedure leerAtencion ( Var a : atencion);
Begin
  a.dni := random(10);
  If (a.dni <> fin) Then
    Begin
      a.matricula := random(20);
      a.dia := random(cantDias)+1;
      a.diagnostico := random(cantDiagnostico)+1;
    End;
End;

Procedure CrearRegistro(a:atencion; Var ar : atencion_reducida);
Begin
  ar.dni := a.dni;
  ar.dia := a.dia;
  ar.diagnostico := a.diagnostico;
End;

Procedure AgregarAdelante(Var l : lista; ar : atencion_reducida);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := ar;
  aux^.sig := l;
  l := aux;
End;

Procedure Agregar ( Var t : tree; a : atencion);

Var ar : atencion_reducida;
Begin
  If (t=Nil) Then
    Begin
      new(t);
      t^.dato.matricula := a.matricula;
      t^.hi := Nil;
      t^.hd := Nil;
      t^.dato.listaMatricula := Nil;
      CrearRegistro(a,ar);
      AgregarAdelante(t^.dato.listaMatricula,ar);
    End
  Else If (a.matricula<t^.dato.matricula) Then Agregar(t^.hi,a)
  Else If (a.matricula>t^.dato.matricula) Then Agregar(t^.hd,a)
  Else
    Begin
      CrearRegistro(a,ar);
      AgregarAdelante(t^.dato.listaMatricula,ar);
    End;
End;

Procedure CargarArbol(Var t : tree);

Var 
  a : atencion;
Begin
  t := Nil;
  leerAtencion(a);
  While (a.dni<>fin) Do
    Begin
      Agregar(t,a);
      leerAtencion(a);
    End;
End;
Procedure ImprimirLista(l : lista);
Begin
  While (l<>Nil) Do
    Begin
      writeln('DNI: ',l^.dato.dni);
      writeln('Diagnostico: ',l^.dato.diagnostico);
      writeln('Dia: ',l^.dato.dia);
      l := l^.sig;
    End;
End;

Procedure ImprimirArbol(t : tree);
Begin
  If (t<>Nil) Then
    Begin
      ImprimirArbol(t^.hi);
      writeln('MATRICULAAAA: ',t^.dato.matricula);
      ImprimirLista(t^.dato.listaMatricula);
      ImprimirArbol(t^.hd);

    End;
End;


{b) Implementar un modulo que reciba el arbol , 2 matriculas y un DNI. 
Debe retornar la cantidad total de atenciones realizadas por odontologos entre las 2 matriculas al paciente con DNI ingresado (sin incluir}

Function ContarCumple(l : lista; dni : integer) : integer;

Var aux : integer;
Begin
  aux := 0;
  While (l<>Nil) Do
    Begin
      If (l^.dato.dni=dni) Then
        aux := aux+1;
      l := l^.sig;
    End;
  ContarCumple := aux;
End;

Function cantRango(t : tree; LimInf,LimSup,DNI : integer) : integer;
Begin
  If (t=Nil) Then
    cantRango := 0
  Else If (t^.dato.matricula<=LimInf) Then cantRango := cantRango(t^.hd,LimInf,LimSup,DNI)

  Else If (t^.dato.matricula>=LimSup) Then cantRango := cantRango(t^.hi,LimInf,LimSup,DNI)
  Else cantRango := ContarCumple(t^.dato.listaMatricula,dni) + cantRango(t^.hi,LimInf,LimSup,DNI) + cantRango(t^.hd,LimInf,LimSup,DNI)
End;

{c) Realizar un modulo que reciba el arbol y retorne, para cada diagnostico, la cantidad de atenciones realizadas}


Procedure InicializarVector(Var v : contador);

Var i : integer;
Begin
  For i:=1 To cantDiagnostico Do
    v[i] := 0;
End;

Procedure ActualizarContador(Var v : contador; l :lista);

Begin
  While (l<>Nil) Do
    Begin
      v[l^.dato.diagnostico] := v[l^.dato.diagnostico] + 1;
      l := l^.sig;
    End;
End;

Procedure ContarPorDiagnostico(t : tree; Var v : contador);
Begin
  If (t<>Nil) Then
    Begin
      ContarPorDiagnostico(t^.hi,v);
      ActualizarContador(v,t^.dato.listaMatricula);
      ContarPorDiagnostico(t^.hd,v);
    End;
End;
Procedure ImprimirVector(v : contador);

Var i : integer;
Begin
  For i:=1 To cantDiagnostico Do
    writeln('Diagnostico ',i,': ',v[i],' atenciones realizadas.');
End;

Var t : tree;
  dni,matricula1,matricula2 : integer;
  v : contador;
Begin
  randomize;
  CargarArbol(t);
  If (t<>Nil) Then
    Begin
      // t := Nil;  probar vacio
      InicializarVector(v);
      ImprimirArbol(t);
      write('Ingresar limite inferior de matriculas a buscar: ');
      readln(matricula1);
      write('Ingresar limite superior de matriculas a buscar: ');
      readln(matricula2);
      write('Ingresar DNI a buscar: ');
      readln(DNI);
      writeln('Al paciente con DNI ',dni,' lo atendieron odontologos con matriculas ',matricula1,'-',matricula2,' ',cantRango(t,matricula1,matricula2,DNI),' veces.');
      // InicializarVector(v); probar vacio
      ContarPorDiagnostico(t,v);
      ImprimirVector(v);
    End
  Else writeln('El arbol esta vacio');
End.
