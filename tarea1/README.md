# ¿Como jugar Treasure Hunt? 
---
Muy sencillo, con estos 3 pasos.
1) Clona el repositorio.
2) Ubicate en tarea 1.  
3) Ejecuta `./game.sh`.

Los permisos ya fueron otorgados con `chmod -R +x` y no deberia haber ningun problema para ejecutar ningun comando por permisos (espero, sino contactarme en la brevedad). 

En caso de querer romper el juego se puede hacer en el archivo principal en la funcion de `verify.sh` y cambiar `$x` por `$key`.

Disfruta.

---
# Detalles relevantes

La gestion de directorios fue tal cual la del aux5 no tome mucho mas, genero archivos sin extension porque no lo vi realmente necesario hacerlo .txt si en el fondo solo debemos trabajarlos dependiendo de un modo u otro.

Ocupe funciones auxiliares para `place_treasure` para ordenar un poco el codigo. Sobre la encriptacion si hay algo que comentar y es que se repite la extension del archivo (por ejemplo Jvt.gpg.gpg.gpg) lo cual investigando no supe un problema ya que es una respuesta natural para no tener archivos corruptos, por tiempo no lo mejore.

Agregue un poco de diseño al juego para hacerlo mas vistoso al correrlo, meramente porque queria.

La forma de ganar el juego segun el modo es:
- name: indicar el nombre del archivo
- content: indicar el contenido del archivo
- checksum: indicar el checksum del archivo
- encrypted: indicar la contrasena de encriptacion junto con la direccion del archivo
- signed: indicar la firma de encriptacion junto con la direccion del archivo

El formato de la ultimas dos es: "passwd /dir/al/archivo"