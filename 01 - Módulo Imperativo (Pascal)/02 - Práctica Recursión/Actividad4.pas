
{4.- Realizar un programa que lea números y que utilice un módulo recursivo que escriba el
equivalente en binario de un número decimal. El programa termina cuando el usuario ingresa
el número 0 (cero).
Ayuda: Analizando las posibilidades encontramos que: Binario (N) es N si el valor es menor a 2.
¿Cómo obtenemos los dígitos que componen al número? ¿Cómo achicamos el número para la
próxima llamada recursiva? Ejemplo: si se ingresa 23, el programa debe mostrar: 10111.}

Program Actividad4;

Procedure Convertir_a_Base_N (x ,n: integer);

Var 
  dig : integer;
Begin
  If (x<>0) Then
    Begin
      dig := x Mod n;
      Convertir_a_Base_N(x Div n,n);
      Write(dig);
    End
End;

Var 
  x,n : integer;
Begin
  write('Ingresar numero decimal: ');
  readln(x);
  write('Ingresar base a la que se desea convertrir (entre 2 y 9): ');
  readln(n);
  While (x<>0) Do
    Begin
      write(x,' en base ',n, ' es: ');
      Convertir_a_Base_N(x,n);
      writeln('');
      write('Ingresar numero decimal: ');
      readln(x);
      If (x<>0) Then
        Begin
          write('Ingresar base a la que se desea convertrir (entre 2 y 9): ');
          readln(n);
        End;
    End;
  writeln('Se ingreso el 0');
End.
